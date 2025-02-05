clear; close all;
path='/Users/mczhang/Documents/GitHub/FM3/02-data/';
groups = {'E1','E2','W1','W2','S1','E3','E4'};
project={'BF','DR','AF'};
projects={'Before','During','After'};
load('/Users/mczhang/Documents/GitHub/FM3/02-data/E_Po/E_BF_DR_AF.mat')
region={'West','East','South','North','All'};
date_BF = datenum(2015, 4, 24, 8, 0, 0);
date_DR = datenum(2015, 5, 19);
date_AF = datenum(2021, 12, 31);
pdf_file = ['/Users/mczhang/Documents/GitHub/FM3/03-output-graphics/' ...
    'G_HASH_Many_FMs_SOunth_North.pdf'];
if exist(pdf_file, 'file') == 2
    delete(pdf_file);
end
regions = struct(...
    'West', struct('Lat', [45.925, 45.955], 'Lon', [-130.03, -130.006]), ...
    'East', struct('Lat', [45.93, 45.96], 'Lon', [-130.00, -129.975]), ...
    'South', struct('Lat', [45.916, 45.929], 'Lon', [-130.004, -129.965]), ...
    'North', struct('Lat', [45.956, 45.985], 'Lon', [-130.015, -129.99]),...
    'All', struct('Lat', [45.9, 46.01], 'Lon', [-130.00, -129.9]));

%regionBounds = [
%     45.925, 45.955, -130.03, -130.006;  % MJ03B
%     45.93, 45.955, -130.00, -129.975;   % MJ03E
%     45.916, 45.929, -130.004, -129.975; % MJ03D
%     45.956, 45.985, -130.015, -129.99   % MJ03F
% ];
%[-130.10 -129.89], [45.875 46.02]);
for reg=2
    define_region=region{reg};
    % Define overall depth range and colormap for all plots
    minDepthGlobal = 0; % Global minimum depth, adjust as needed
    maxDepthGlobal = 2; % Global maximum depth, adjust as needed
    colormap("summer"); % You can choose any colormap you prefer
    cmap = colormap;
    numColors = size(cmap, 1);
    for kp=3:length(project)
        %load([path,'G_FM/G_2015Erp_polished.mat']);
        load([path,'G_FM/G_2015_HASH_Po_Clu_FM.mat']);
        event=Po_Clu;
        maxmum=length(event);
        eval(strcat('Felix=Felix_',project{kp},';'));
        %Felix=[Felix_BF,Felix_DR,Felix_AF];
        % Filtering event data as required
        if kp==1;indEv=find([event.on]<date_BF);elseif kp==2;indEv=find([event.on]>=date_BF ...
                & [event.on]< date_DR);else indEv=find([event.on]>=date_DR);end
        event=event(indEv);
        event([event.mechqual]=='C' | [event.mechqual]=='D')=[];
        event([event.faultType]=='U')=[];
        % event([event.faultType]=='N')=[];
        % event([event.faultType]=='R')=[];
        event([event.depth]<0.8)=[];



        if strcmp(define_region, 'West')
            % Filtering for the West region using struct bounds
            event([event.lat] < regions.West.Lat(1) | [event.lat] > regions.West.Lat(2)) = [];
            event([event.lon] < regions.West.Lon(1) | [event.lon] > regions.West.Lon(2)) = [];
            %event([event.faultType] == 'U') = [];

        elseif strcmp(define_region, 'East')
            % Filtering for the MiddleEast region using struct bounds
            event([event.lat] < regions.East.Lat(1) | [event.lat] > regions.East.Lat(2)) = [];
            event([event.lon] < regions.East.Lon(1) | [event.lon] > regions.East.Lon(2)) = [];
            %event([event.faultType] == 'U') = [];

            elseif strcmp(define_region, 'North')
            % Filtering for the MiddleEast region using struct bounds
            event([event.lat] < regions.North.Lat(1) | [event.lat] > regions.North.Lat(2)) = [];
            event([event.lon] < regions.North.Lon(1) | [event.lon] > regions.North.Lon(2)) = [];
            %event([event.faultType] == 'U') = [];

            elseif strcmp(define_region, 'South')
            % Filtering for the MiddleSouth region using struct bounds
            event([event.lat] < regions.South.Lat(1) | [event.lat] > regions.South.Lat(2)) = [];
            event([event.lon] < regions.South.Lon(1) | [event.lon] > regions.South.Lon(2)) = [];
            %event([event.faultType] == 'U') = [];

        end

        %% out put the file for stressinversion

        % Define the output file name
        output_file = '/Users/mczhang/Documents/GitHub/stressinverse_1.1.3/Data/West_Bohemia_mechanisms.dat';
        % Open the file for writing
        fileID = fopen(output_file, 'w');
        % Write the header line (comment)
        fprintf(fileID, '%% West mechanisms\n');
        fprintf(fileID, '%%  strike          dip             rake  \n');

        % Write the data
        for i = 1:size(event, 2)
            fprintf(fileID, '%14.7e %14.7e %14.7e\n', event(i).avmech(1), event(i).avmech(2), event(i).avmech(3));
        end

        % Close the file
        fclose(fileID);
        cd /Users/mczhang/Documents/GitHub/stressinverse_1.1.3/Programs_MATLAB
        StressInverse;
        %%

        %if reg==1
            depth_bins=0:2:2;
        % elseif reg>=2
        %     depth_bins=0:0.4:2;
        % end
        radius = 0.002;
        scale = 1.45;

        % plot zoom in plot;
        for j = 1:length(depth_bins) - 1
            %load('/Users/mczhang/Documents/GitHub/FM/02-data/G_circle_calderal_point_generateV3.mat');
            depth_lower_bound = depth_bins(j);
            depth_upper_bound = depth_bins(j + 1);
            depth_range_events = event([event.depth] >= depth_lower_bound & [event.depth] < depth_upper_bound);
            depth_range_Felix = Felix([Felix.depth] >= depth_lower_bound & [Felix.depth] < depth_upper_bound);

            eventp=depth_range_events;
            %[B,I]=sort([eventp.faultType],'ascend');
            [B,I]=sort([eventp.depth],'ascend');
            eventp=eventp(I);
            %[~, I] = sortrows([[eventp.faultType].' [eventp.p_l].'], [1 -2],'descend');

            % Apply the sorting index
            %eventp = eventp(I);
            if length(eventp)<2
                continue;
            end
            Felixp= depth_range_Felix;
            %event_colors = cmap(ceil(max(0.1, [eventp.depth])  / max([Felixp.depth]) * numColors), :);
            event_colors = cmap(ceil(max(1, [eventp.depth] / 2) * numColors), :);
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
            %scatter([Felixp.lon], [Felixp.lat], 10, [Felixp.depth], 'filled');
            colormap(flipud(colormap('summer')));
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

            for i = 1:length(eventp)
                event_color = event_colors(i, :);
                hold on;
                if isempty(eventp(i).Mw)
                    eventp(i).Mw=0.1;
                end

                h = plot_balloon(eventp(i).avfnorm, eventp(i).avslip, eventp(i).lon, eventp(i).lat, eventp(i).Mw*radius/ratiox, scale, eventp(i).color);

                %h = plot_balloon(eventp(i).avfnorm, eventp(i).avslip, eventp(i).lon, eventp(i).lat, eventp(i).Mo*1.5*radius/ratiox, scale, eventp(i).color);
            end
            % Ensure consistent color scale across figures
            colorbarHandle = colorbar;  % Creates a colorbar and returns the handle to it
            caxis([minDepthGlobal maxDepthGlobal]);  % Sets the color axis scaling limits
            ylabel(colorbarHandle, 'Depth/km');

            title([region{reg} ' ' project{kp} ' ' num2str(depth_lower_bound) ...
                ' to ' num2str(depth_upper_bound) ' km, Num:', num2str(length(depth_range_events)) '/' num2str(length(Felixp))]);
            %title([define_region ': ' projects{kp} ' 2015 Eruption, FMs/EQs Num:', num2str(length(depth_range_events)) '/' num2str(length(Felixp))]);
            xlabel('Longitude');
            ylabel('Latitude');
            grid on;
            hold off;
            set(gca,'FontSize',24);
            exportgraphics(gcf, pdf_file, 'Append', true);
            close;
        end
    end
    close all;
end