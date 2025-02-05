clear; close all;
path='/Users/mczhang/Documents/GitHub/FM3/02-data/';
groups = {'E1','E2','W1','W2','S1','E3','E4'};
project={'BF','DR','AF'};
projects={'Before','During','After'};
load('/Users/mczhang/Documents/GitHub/FM3/02-data/E_Po/E_BF_DR_AF.mat')
region={'West','EastDeep','ShallowEast','South','North','MiddleEast'};
pdf_file = ['/Users/mczhang/Documents/GitHub/FM3/03-output-graphics/G_sep.pdf'];
if exist(pdf_file, 'file') == 2
    delete(pdf_file);
end
regions = struct(...
    'West', struct('Lat', [45.925, 45.955], 'Lon', [-130.03, -130.006]), ...
    'EastDeep', struct('Lat', [45.931, 45.96], 'Lon', [-130.00, -129.975]), ...
    'ShallowEast', struct('Lat', [45.94, 45.955], 'Lon', [-130.00, -129.985]), ...
    'South', struct('Lat', [45.916, 45.929], 'Lon', [-130.004, -129.965]), ...
    'North', struct('Lat', [45.956, 45.985], 'Lon', [-130.015, -129.99]),...
    'MiddleEast', struct('Lat', [45.94, 45.96], 'Lon', [-130.00, -129.98]));

for reg=1
    define_region=region{reg};
    % Define overall depth range and colormap for all plots
    minDepthGlobal = 0; % Global minimum depth, adjust as needed
    maxDepthGlobal = 2; % Global maximum depth, adjust as needed
    colormap("summer"); % You can choose any colormap you prefer
    cmap = colormap;
    numColors = size(cmap, 1);
    for kp=1:length(project)
        %load([path,'G_FM/G_2015Erp.mat']);
        load('/Users/mczhang/Documents/GitHub/FM/02-data/G_FM_W_only7.mat')
        event=event1;
        eval(strcat('Felix=Felix_',project{kp},';'));
        % Filtering event data as required
        %if kp==1;indEv=1:2310;elseif kp==2;indEv=2311:2721;else indEv=2722:4090;end;
        %event=event(indEv);
        event([event.mechqual]=='C' | [event.mechqual]=='D')=[];
        event([event.faultType]=='U')=[];
        
        if strcmp(define_region, 'West')
            % Filtering for the West region using struct bounds
            event([event.lat] < regions.West.Lat(1) | [event.lat] > regions.West.Lat(2)) = [];
            event([event.lon] < regions.West.Lon(1) | [event.lon] > regions.West.Lon(2)) = [];
            event([event.faultType] == 'U') = [];

        elseif strcmp(define_region, 'EastDeep')
            % Filtering for the EastDeep region using struct bounds
            event([event.lat] < regions.EastDeep.Lat(1) | [event.lat] > regions.EastDeep.Lat(2)) = [];
            event([event.lon] < regions.EastDeep.Lon(1) | [event.lon] > regions.EastDeep.Lon(2)) = [];
            event([event.faultType] == 'U') = [];
            event([event.depth] < 1.2) = [];

        elseif strcmp(define_region, 'ShallowEast')
            % Filtering for the ShallowEast region using struct bounds
            event([event.lat] < regions.ShallowEast.Lat(1) | [event.lat] > regions.ShallowEast.Lat(2)) = [];
            event([event.lon] < regions.ShallowEast.Lon(1) | [event.lon] > regions.ShallowEast.Lon(2)) = [];
            event([event.faultType] == 'U') = [];
            event([event.depth] > 1.2) = [];

        elseif strcmp(define_region, 'South')
            % Filtering for the South region using struct bounds
            event([event.lat] < regions.South.Lat(1) | [event.lat] > regions.South.Lat(2)) = [];
            event([event.lon] < regions.South.Lon(1) | [event.lon] > regions.South.Lon(2)) = [];
            event([event.faultType] == 'U') = [];

        elseif strcmp(define_region, 'North')
            % Filtering for the North region using struct bounds
            event([event.lat] < regions.North.Lat(1) | [event.lat] > regions.North.Lat(2)) = [];
            event([event.lon] < regions.North.Lon(1) | [event.lon] > regions.North.Lon(2)) = [];
            event([event.faultType] == 'U') = [];

        elseif strcmp(define_region, 'MiddleEast')
            % Filtering for the MiddleEast region using struct bounds
            event([event.lat] < regions.MiddleEast.Lat(1) | [event.lat] > regions.MiddleEast.Lat(2)) = [];
            event([event.lon] < regions.MiddleEast.Lon(1) | [event.lon] > regions.MiddleEast.Lon(2)) = [];
            event([event.faultType] == 'U') = [];

        end
        depth_bins = 0:2:2; % depth bins from 0 to 2 km, with increments of 0.2 km
        radius = 0.003;
        radius = 0.002;
        scale = 1.45;
        % Prepare to plot one
        for j = 1:length(depth_bins) - 1
            load('/Users/mczhang/Documents/GitHub/FM/02-data/G_circle_calderal_point_generateV4.mat');
            depth_lower_bound = depth_bins(j);
            depth_upper_bound = depth_bins(j + 1);
            depth_range_events = event([event.depth] >= depth_lower_bound & [event.depth] < depth_upper_bound);
            depth_range_Felix = Felix([Felix.depth] >= depth_lower_bound & [Felix.depth] < depth_upper_bound);

            eventp=depth_range_events;
            %[B,I]=sort([eventp.faultType],'descend');
            %eventp=eventp(I);
            [~, I] = sortrows([[eventp.faultType].' [eventp.p_l].'], [1 -2],'descend');

            % Apply the sorting index
            eventp = eventp(I);
            Felixp= depth_range_Felix;
            %event_colors = cmap(ceil([eventp.depth] / 2 * numColors), :);%max([Felixp.depth])
            %event_colors = cmap(ceil(max(1, [eventp.depth] / 2) * numColors), :);
            event_colors = cmap(ceil(max(0.1, [eventp.depth])  / max([Felixp.depth]) * numColors), :);
            % figure;
            % h=basemap_2015([-130.10 -129.89], [45.89 46.01]);
            % h=set(gcf,'Position',[1000 571 956         815]);
            X_Z_test_fissures;
            % Define the bounds for each region
            hold on;
            scatter([Felixp.lon], [Felixp.lat], 1, [Felixp.depth], 'filled','MarkerEdgeColor','none');

            hold on; % Hold on to plot multiple shapes

            % Plotting each region as a box
            fields = fieldnames(regions);
            % for i = 1:length(fields)
            %     regionp = regions.(fields{i});
            %     rectangle('Position', [regionp.Lon(1), regionp.Lat(1), diff(regionp.Lon), diff(regionp.Lat)], 'EdgeColor', 'b', 'LineWidth', 2);
            %     text(mean(regionp.Lon), mean(regionp.Lat), fields{i}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
            % end
            hold on;
            regionp = regions.(fields{reg});
            rectangle('Position', [regionp.Lon(1), regionp.Lat(1), diff(regionp.Lon), diff(regionp.Lat)], 'EdgeColor', 'r', 'LineWidth', 2);

            colormap('summer');
            hold on;

            % Assuming x and y are column vectors of the same length
            % Initialize arrays to store indices of x and y that have been used

            used_indices = false(length(x), 1);
            for i = 1:length(eventp)
                event_color = event_colors(i, :);
                hold on;
                plot(eventp(i).lon, eventp(i).lat, 'ro', 'markersize', 4, ...
                    'markerfacecolor', event_color, 'markeredgecolor', event_color);

                % Calculate the Euclidean distance from the current event to all x, y points
                distances = sqrt((x - eventp(i).lon).^2 + (y - eventp(i).lat).^2);

                % Ignore already used indices by setting their distances to a very high value
                distances(used_indices) = inf;

                % Find the index of the nearest point that hasn't been used
                [minDist, idx] = min(distances);

                % Check if we have exhausted our points
                if isinf(minDist)
                    break;
                end

                % Mark this index as used
                used_indices(idx) = true;

                % Get the coordinates of the nearest point
                xxx = x(idx);
                yyy = y(idx);

                % Plot line between nearest point and event
                %plot([xxx eventp(i).lon], [yyy eventp(i).lat] ,'Color', event_color);

                % Plot additional features such as balloons and labels
                h = plot_balloon(eventp(i).avfnorm, eventp(i).avslip, xxx, yyy, radius, scale, eventp(i).color);
                plot(eventp(i).lon, eventp(i).lat, 'o', 'markersize', 4, 'markerfacecolor', 'none');
            end
            % Ensure consistent color scale across figures
            colorbarHandle = colorbar;  % Creates a colorbar and returns the handle to it
            caxis([minDepthGlobal maxDepthGlobal]);  % Sets the color axis scaling limits
            ylabel(colorbarHandle, 'Depth/km');


            title([define_region ': ' projects{kp} ' 2015 Eruption,' num2str(depth_lower_bound) ...
                ' to ' num2str(depth_upper_bound) ' km, Num:', num2str(length(depth_range_events)) '/' num2str(length(Felixp))]);
            xlabel('Longitude');
            ylabel('Latitude');
            grid on;
            hold off;
            set(gca,'FontSize',18);
            exportgraphics(gcf, pdf_file, 'Append', true);
            close;
        end


        % plot zoom in plot;
        for j = 1:length(depth_bins) - 1
            %load('/Users/mczhang/Documents/GitHub/FM/02-data/G_circle_calderal_point_generateV3.mat');
            depth_lower_bound = depth_bins(j);
            depth_upper_bound = depth_bins(j + 1);
            depth_range_events = event([event.depth] >= depth_lower_bound & [event.depth] < depth_upper_bound);
            depth_range_Felix = Felix([Felix.depth] >= depth_lower_bound & [Felix.depth] < depth_upper_bound);

            eventp=depth_range_events;
            %[B,I]=sort([eventp.faultType],'descend');
            %eventp=eventp(I);
            [~, I] = sortrows([[eventp.faultType].' [eventp.p_l].'], [1 -2],'descend');

            % Apply the sorting index
            eventp = eventp(I);
            if length(eventp)<2
                continue;
            end
            Felixp= depth_range_Felix;
            event_colors = cmap(ceil(max(0.1, [eventp.depth])  / max([Felixp.depth]) * numColors), :);
            %event_colors = cmap(ceil(max(1, [eventp.depth] / 2) * numColors), :);
            % figure;
            % h=basemap_2015([-130.10 -129.89], [45.89 46.01]);
            % h=set(gcf,'Position',[1000 571 956         815]);
            X_Z_test_fissures;
            axis equal;
            %x_length=(max([eventp.lon])-min([eventp.lon]));
            %y_length=max([eventp.lat])-min([eventp.lat]);
            eval(strcat('x2=regions.',define_region, '.Lon(2);'));
            eval(strcat('x1=regions.',define_region, '.Lon(1);'));
            eval(strcat('y2=regions.',define_region, '.Lat(2);'));
            eval(strcat('y1=regions.',define_region, '.Lat(1);'));
            eval(strcat('y_length=regions.',define_region, '.Lat(2)-regions.',define_region,'.Lat(1);'));
            eval(strcat('x_length=regions.',define_region, '.Lon(2)-regions.',define_region,'.Lon(1);'));

            xlim([x1-1/10*x_length x2+1/10*x_length]);
            ylim([y1-1/10*y_length y2+1/10*y_length]);
            scatter([Felixp.lon], [Felixp.lat], 5, [Felixp.depth], 'filled');
            colormap('summer');
            hold on;
            % Assuming x and y are column vectors of the same length
            % Initialize arrays to store indices of x and y that have been used
            ratiox=(130.10-129.89)/x_length;
            ratioy=-(45.875-46.02)/y_length;
            %disp(ratiox);
            %disp(ratioy);
            ratioxy=ratiox/ratioy;
            %disp(ratioxy);
            scale=1.0;
            
            % if ratioxy>1
            %     ratio=ratiox;
            % else
            %     ratio=ratioy;
            % end
            %  if ratioxy>1.5
            %       ylim([min([eventp.lat])-1/10*y_length max([eventp.lat])+1/10*y_length]);
            %  elseif ratioxy<0.7
            %       xlim([min([eventp.lon])-1/10*x_length max([eventp.lon])+1/10*x_length]);
            % end
            for i = 1:length(eventp)
                event_color = event_colors(i, :);
                hold on;
                h = plot_balloon(eventp(i).avfnorm, eventp(i).avslip, eventp(i).lon, eventp(i).lat, 1.5*radius/ratiox, scale, eventp(i).color);
            end
            % Ensure consistent color scale across figures
            colorbarHandle = colorbar;  % Creates a colorbar and returns the handle to it
            caxis([minDepthGlobal maxDepthGlobal]);  % Sets the color axis scaling limits
            ylabel(colorbarHandle, 'Depth/km');


            title([define_region ': ' projects{kp} ' 2015 Eruption,' num2str(depth_lower_bound) ...
                ' to ' num2str(depth_upper_bound) ' km, Num:', num2str(length(depth_range_events)) '/' num2str(length(Felixp))]);
            xlabel('Longitude');
            ylabel('Latitude');
            grid on;
            hold off;
            set(gca,'FontSize',18);
            exportgraphics(gcf, pdf_file, 'Append', true);
            close;
        end
    end
    close all;
end