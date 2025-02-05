clc;clear;close all;
path='/Users/mczhang/Documents/GitHub/FM3/02-data/';
fields={'AS1','AS2','CC1','EC1','EC2','EC3','ID1'};
groups = {'ES2','W1','W2','W3','W4','W5','W6','W7','W8','E1','E2','E3','E4','E5','E6','E7','E8','ES','ES2'};

min_Po_num=6;
min_SP_num=6;
average_num=6;
for gp=1%:length(groups)
    %load([path,'E_Po/E_',groups{gp},'.mat']);
    load([path,'F_Cl/F_ES2_for_test.mat']);
    Po=Po_Clu;clear Po_Clu
    %Po=Felix;clear Felix;
    Po = Po([Po.PoALL] > min_Po_num & [Po.SP_All] > min_SP_num); % in levy's place, the samllest number is 5, so that we use
    % Data preparation
    data_location = [Po.lat; Po.lon; Po.depth]';
    [data_location(:, 1), data_location(:, 2)] = latlon2xy(data_location(:, 1), data_location(:, 2));
    polarities = [];
    sp_ratios = [];

    for kz = 1:length(fields)
        polarities = [polarities; Po.(['Po_' fields{kz}])];
        sp_ratios = [sp_ratios; Po.(['SP_' fields{kz}])];
    end

    polarities = polarities';
    sp_ratios = sp_ratios';
    sp_ratios2 = sp_ratios';
    data_matrix = [data_location, polarities, sp_ratios, [Po.ID]'];

    % Perform hierarchical cclustering until every event is in one group
    group_matrix = [];
    group_count = 1;
    a = 3;
    b = 7;
    c = 100;
    fluc_num=5;
    zero_count = 0;
    data_matrix_remove = [];
    polarities_remove = [];
    spratios_remove = [];
    data_location_remove = [];
    group_numbers = [];
    loc_values = [];
    Po_values = [];
    Po_nums = [];
    Po_ratio = [];
    Spr_values = [];

    tic;
    minLeaves =average_num;
    maxLeaves = average_num+fluc_num;
    while size(data_matrix, 1) > average_num
        % Calculate pairwise distances
        eucD_loc = pdist(data_location, 'seuclidean')/ max(pdist(data_location, 'seuclidean'));
        eucD_spr = pdist(sp_ratios, @custom_distance_SPr);
        %eucD_po = pdist(polarities, 'cosine')/ max(pdist(polarities, 'seuclidean'));
        eucD_po = pdist(polarities, @custom_distance_Po);
        eucD = a * eucD_loc + b * eucD_spr + c * eucD_po;
        % D_matrix = squareform(eucD_po);
        % eucD=eucD_po;
        % imagesc(D_matrix)
        % colorbar;
        clustTreeEuc = linkage(eucD, 'complete');

        % Now you can iterate over the clusters and apply your criteria

        % Number of data points
        n = size(data_matrix, 1);

        % Initialize a vector to store the number of leaves under each node
        numLeaves = ones(2*n-1, 1);

        % Loop over each step in the clustering process
        for i = 1:size(clustTreeEuc, 1)
            % Get the indices of the clusters that were merged
            j = clustTreeEuc(i, 1:2);

            % Update the number of leaves under the new node
            numLeaves(n+i) = sum(numLeaves(j));
        end
        % Now, numLeaves(n+1:end) contains the number of leaves under each non-leaf node
        % Continue from the previous code...
        % Define the range of the number of leaves
        % Find the non-leaf nodes that have between minLeaves and maxLeaves leaves
        selectedNodes = find(numLeaves(n+1:end) >= minLeaves & numLeaves(n+1:end) <= maxLeaves) + n;

        % Initialize a cell array to store the leaves under each selected node
        selectedLeaves = cell(length(selectedNodes), 1);
        group_event_indices_all = [];
        Sprlim=0.2;
        Loclim=0.2;
        % Loop over each selected node
        if ~isempty(selectedNodes)
            for i = 1:length(selectedNodes)
                % Initialize a queue with the current node
                queue = selectedNodes(i);

                % Initialize a vector to store the leaves under the current node
                leaves = [];

                % Perform a breadth-first search to find all leaves under the current node
                while ~isempty(queue)
                    % Dequeue the first node
                    node = queue(1);
                    queue(1) = [];

                    % If the node is a leaf, add it to the leaves vector
                    if node <= n
                        leaves = [leaves; node];
                        % If the node is a non-leaf, enqueue its children
                    else
                        queue = [queue; clustTreeEuc(node-n, 1:2)'];
                    end
                end
                leavesall{i}=leaves;
                % Store the leaves under the current node
                group_data_matrix = data_matrix(leaves, :);

                % Inside the loop:
                group_size = size(group_data_matrix, 1);
                %loc_val = mean(pdist(group_data_matrix(:,1:3)));
                % Your data matrix
                data = group_data_matrix(:,1:3);
                mean_location = mean(data);

                % Step 2: Calculate Euclidean distances from each point to the mean location
                differences = data - mean_location;
                distances_to_mean = sqrt(sum(differences.^2, 2));
                rms_distance_to_mean = sqrt(mean(distances_to_mean.^2));
                loc_val(i)=rms_distance_to_mean;

                clear data
                data=group_data_matrix(:,4:10);
                % Initialize a counter for each station and the total counters
                mismatch_counts = zeros(1, size(data, 2));
                total_mismatches = 0;
                total_non_zeros = 0;

                % Loop over each station
                for station = 1:size(data, 2)
                    % Extract the non-zero entries for the station
                    non_zero_entries = data(data(:, station) ~= 0, station);
                    % Find the mode excluding zeros
                    mode_value = mode(non_zero_entries);
                    % Count how many non-zero entries do not match the mode
                    mismatches = non_zero_entries ~= mode_value;
                    % Update mismatch count for the station
                    mismatch_counts(station) = sum(mismatches);
                    % Update total mismatch and non-zero counts
                    total_mismatches = total_mismatches + sum(mismatches);
                    total_non_zeros = total_non_zeros + length(non_zero_entries);
                end


                Po_val(i) = total_mismatches;
                Po_nval(i)= total_non_zeros;
                Po_raval(i)= total_mismatches/total_non_zeros;
                Spr_val(i) = mean(pdist(group_data_matrix(:,11:17),@custom_distance_SPr));
                DIS(i,1)=a * loc_val(i) + b * Spr_val(i) + c * Po_val(i);
                DIS(i,2)=length(leaves);
            end
            [M,I]=min(DIS(:,1));
            %[J,I] = max(DIS(DIS(:,1)<100,2));
            % if isempty(I)
            %     minLeaves=minLeaves-1;
            %     continue;
            % end

            if Po_val(I)>0
                minLeaves=minLeaves-1;
                continue;
            end

            if Spr_val(I)>Sprlim
                minLeaves=minLeaves-1;
                continue;
            end

            if loc_val(I)>Loclim
                minLeaves=minLeaves-1;
                continue;
            end

            % Node with minimum DIS
            leaveindex=leavesall{I};
            group_data_matrix1=data_matrix(leaveindex, :);
            group_data_matrix1(:, end+1) = group_count;
            group_numbers = [group_numbers; group_count];
            loc_values = [loc_values; loc_val(I)];
            Po_values = [Po_values; Po_val(I)];
            Po_nums = [Po_nums; Po_nval(I)];
            Po_ratio = [Po_ratio;Po_raval(I)];
            Spr_values = [Spr_values; Spr_val(I)];
            group_matrix = [group_matrix; group_data_matrix1];

            group_event_indices_all = [group_event_indices_all; leaveindex];
            if length(leaveindex) <3
                break;
            end
            % find the minmun DIS as the one to output
            fprintf('Grouped %d events into group %d; RMS Loc: %.2f, Po: %d / %d; Ratio: %.2f , Spr: %.2f\n', ...
                length(leaveindex), group_count, loc_val(I), Po_val(I), Po_nval(I),Po_raval(I), Spr_val(I));
            group_count = group_count + 1;
            clear DIS
        end

        if isempty(group_event_indices_all)
            minLeaves=minLeaves-1;
        end

        % Remove the events that have been assigned to a group
        data_matrix(group_event_indices_all, :) = [];
        polarities(group_event_indices_all, :) = [];
        sp_ratios(group_event_indices_all, :) = [];
        data_location(group_event_indices_all, :) = [];
    end
    data_matrix(:, end+1) = group_count;

    % Sprlim=Sprlim+0.1;
    % Loclim=Loclim+0.1;

    % After the loop:
    group_size = size(data_matrix, 1);
    fprintf('Group %d Evs into %d cls. Meidan RMS Loc misfit %.2f; Meidan Po misfit %d / %d;Meidan Spr misfit %.2f;\n',length(Po) ,group_count, ...
        median(loc_values),median(Po_values),median(Po_nums),median(Spr_values));

    %group_numbers = [group_numbers; group_count];
    %group_count = group_count + 1;
    %group_matrix = [group_matrix; data_matrix];

    toc;
    % Create a new figure with specified width and height
    figure('Position', [200 400 1000 800]);

    % Subplot for Loc values (bar plot)
    subplot(3,2,1);
    bar(group_numbers, loc_values);
    title(['Loc RMS misfit in each group']);
    xlabel('Group Number');
    ylabel('Loc');
    set(gca,'fontsize',16)
    % Subplot for Loc values (histogram)
    subplot(3,2,2);
    hist(loc_values, 20); % Using 20 bins, adjust as needed
    title(['Loc RMS misfit distribution, median' num2str(median(loc_values),2)]);
    xlabel('Loc Value');
    ylabel('Frequency');
    set(gca,'fontsize',16)
    % Subplot for Po values (bar plot)
    subplot(3,2,3);
    bar(group_numbers, Po_ratio);
    title('Po misfit Ratio in each group');
    xlabel('Group Number');
    ylabel('Po');
    set(gca,'fontsize',16)
    % Subplot for Po values (histogram)
    subplot(3,2,4);
    hist(Po_ratio, 20); % Using 20 bins, adjust as needed
    title(['Po misfit Ratiodistribution, median' num2str(median(Po_values),2)]);
    xlabel('Po Value');
    ylabel('Frequency');
    set(gca,'fontsize',16)
    % Subplot for Spr values (bar plot)
    subplot(3,2,5);
    bar(group_numbers, Spr_values);
    title('Spr misfit in each group');
    xlabel('Group Number');
    ylabel('Spr');
    set(gca,'fontsize',16)
    % Subplot for Spr values (histogram)
    subplot(3,2,6);
    hist(Spr_values, 20); % Using 20 bins, adjust as needed
    title(['Spr misfit distribution, median' num2str(median(Spr_values),2)]);
    xlabel('Spr Value');
    ylabel('Frequency');
    set(gca,'fontsize',16)
    sgtitle(['Group ' num2str(length(Po)) ' into ' num2str(group_count) ' Clus, Avg: ' num2str(length(Po)/group_count,3)])
    set(gca,'fontsize',16)
    %% change the group matrix into the Po to run HASH
    % If Po does not have a field named 'Cluster', add it
    if ~isfield(Po, 'Cluster')
        [Po.Cluster] = deal(NaN);  % or some other default value
    end

    % Initialize Po_Clu with the same structure as Po
    Po_Clu = Po;
    Po_Clu = Po_Clu(1:length(group_matrix(:,1)));  % resize to the correct length

    for i=1:length(group_matrix(:,1))
        loc1=find([Po.ID]==group_matrix(i,18));
        Po_Clu(i)=Po(loc1);
        Po_Clu(i).Cluster=group_matrix(i,19);
    end
    save([path,'F_Cl/F_',groups{gp},'_for_test.mat'], 'Po_Clu');


    % Extract latitude, longitude, and depth from the first three columns of group_matrix
    lat = group_matrix(:,1);
    lon = group_matrix(:,2);
    depth = group_matrix(:,3);

    % Extract cluster assignments from the 19th column
    clusters = group_matrix(:,19);

    % Determine the number of clusters for color mapping
    numClusters = max(clusters);
    numClusters1=1;
    %numClusters=125;
    % Create a new figure for the 3D scatter plot
    figure;
    hold on; % Keep the plot for adding more points

    % Generate a colormap for the clusters
    colors = lines(numClusters); % 'lines' colormap provides distinct colors for better cluster visualization

    % Loop through each cluster and plot
    % Loop through each cluster and plot
    for i = numClusters1:numClusters
        % Find the indices of the points in the current cluster
        idx = clusters == i;

        % Extract the points for the current cluster
        clusterLat = lat(idx);
        clusterLon = lon(idx);
        clusterDepth = depth(idx);

        % (Optional) Sort points if needed
        % [sort code here, depending on how you want to sort them]

        % Scatter plot for the current cluster
        scatter3(clusterLon, clusterLat, -clusterDepth, 36, colors(i,:), 'filled');

        % Connect points with a line
        plot3(clusterLon, clusterLat, -clusterDepth, 'Color', colors(i,:));
    end
    % for i = numClusters1:numClusters
    %     % Find the indices of the points in the current cluster
    %     idx = clusters == i;
    %
    %     % Scatter plot for the current cluster
    %     scatter3(lon(idx), lat(idx), -depth(idx), 36, colors(i,:), 'filled');
    % end

    hold off; % No more plots are added

    % Set the view for a better 3D perspective
    view(3);

    % Add labels and title
    xlabel('Longitude');
    ylabel('Latitude');
    zlabel('Depth');
    title('3D Event Locations for Clusters');

    % Optionally, add a colorbar if you want to show the mapping of colors to cluster numbers
    colorbar;
    colormap(colors);
    caxis([numClusters1 numClusters]); % Set the color axis scaling
end