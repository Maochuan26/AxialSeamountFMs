clear; close all;
path = '/Users/mczhang/Documents/GitHub/FM3/02-data/';
project = {'BF','DR','AF'};
projects = {'Before','During','After'};
region = {'West','East','All'};
date_BF = datenum(2015, 4, 24, 8, 0, 0);
date_DR = datenum(2015, 5, 19);
date_AF = datenum(2021, 12, 31);
pdf_file = ['/Users/mczhang/Documents/GitHub/FM3/03-output-graphics/' 'G_HASH_Many_FMs_verticalV6_rotatev2.pdf'];

if exist(pdf_file, 'file') == 2
    delete(pdf_file);
end

regions = struct(...
    'West', struct('Lat', [45.93, 45.96], 'Lon', [-130.03, -130.006]), ...
    'East', struct('Lat', [45.93, 45.96], 'Lon', [-130.00, -129.975]));
radius=0.0002;

for reg = 1:1
    define_region = regions.(region{reg});
    x1 = define_region.Lon(1);
    x2 = define_region.Lon(2);
    y1 = define_region.Lat(1);
    y2 = define_region.Lat(2);
    y_length = y2 - y1;
    x_length = x2 - x1;

    for kp = 1:length(project)
        load('/Users/mczhang/Documents/GitHub/FM3/02-data/X_WestFM.mat');
        eval(strcat('Felix = Felix_', project{kp}, ';'));

        % Filter event data based on the project time periods
        if kp == 1
            indEv = find([event.on] < date_BF);
        elseif kp == 2
            indEv = find([event.on] >= date_BF & [event.on] < date_DR);
        else
            indEv = find([event.on] >= date_DR);
        end

        event = event(indEv);

        % Sort events by 'event.on'
        [~, I] = sort([event.on], 'ascend');
        event = event(I);

        % Divide the events into 5 groups based on ascending 'event.on'
        numEvents = length(event);
        groupSize = ceil(numEvents / 5); % Determine the size of each group

        for group = 1:5
            % Calculate the indices for each group
            startIdx = (group - 1) * groupSize + 1;
            endIdx = min(group * groupSize, numEvents);

            % Select events for this group
            eventGroup = event(startIdx:endIdx);
             % Convert the event.on times to readable dates
             startTime = datestr(datenum(eventGroup(1).on), 'yyyy-mm-dd');
             endTime = datestr(datenum(eventGroup(end).on), 'yyyy-mm-dd');
            % Proceed with plotting for each group
            figure;
            h=basemap_2015([-130.10 -129.89], [45.875 46.02]);
            set(gcf, 'Position', [2828 378  952         935]);
            axis equal;
            %scatter([eventGroup.lon], [eventGroup.lat], 10, [eventGroup.depth], 'filled');
            %colormap(flipud(colormap('summer')));
            
            hold on;

            % Plot balloons for the current group
            for i = 1:length(eventGroup)
                if isempty(eventGroup(i).Mw)
                    eventGroup(i).Mw = 0.1;
                end
                plot_balloon(eventGroup(i).avfnorm, eventGroup(i).avslip, eventGroup(i).lon, eventGroup(i).lat, eventGroup(i).Mw * radius, 1.0, eventGroup(i).color);
            end

            % Title and labels for each group plot
            %title([region{reg} ' ' project{kp} ' Group ' num2str(group) ' Latitude vs Longitude']);
             title([region{reg} ' ' project{kp} ' Group ' num2str(group) ' (' startTime ' to ' endTime ')']);

            xlabel('Longitude');
            ylabel('Latitude');
            colorbar;
            caxis([0 2]);
            grid on;

            % Set x and y limits for latitude and longitude
            xlim([x1 - 1/10 * x_length, x2 + 1/10 * x_length]);
            ylim([y1 - 1/10 * y_length, y2 + 1/10 * y_length]);
            hold on;
                 %% insect rose1
        x =[-130.0308
            -130.0056];
        y =[45.9444
            45.9444];
        hold on;
        plot([x(1); x(2)], [y(1); y(2)], 'r-.', 'LineWidth', 2); % Red line connecting points
        inset_ax = axes('Position', [0.6, 0.7, 0.2, 0.2]); % Adjust position [x, y, width, height] as needed7
        axes(inset_ax); % Set current axes to the inset axes
        eventup=eventGroup([eventGroup.lat] > y(1));
        eventp=eventup;
        for i=1:length(eventp)
            strike(i)=eventp(i).avmech(1);
        end
        binSize = 30; % degrees
        data = deg2rad(strike);  % Convert degrees to radians if needed
        polarhistogram(data, binSize);
        ax = gca;
        ax.ThetaZeroLocation = 'top';  % 0 degrees at the top (North)
        ax.ThetaDir = 'clockwise';     % Angle increases in a clockwise direction
        %set(h, 'LineWidth', 2);
        set(gca,'FontSize',12);clear strike eventp;
        %% Rose 2
        inset_ax = axes('Position', [0.6, 0.1, 0.2, 0.2]); % Adjust position [x, y, width, height] as needed7
        axes(inset_ax); % Set current axes to the inset axes
        eventdw=eventGroup([eventGroup.lat] < y(1));
        clear eventp;
        eventp=eventdw;
        for i=1:length(eventp)
            strike(i)=eventp(i).avmech(1);
        end
        binSize = 30; % degrees
        data = deg2rad(strike);  % Convert degrees to radians if needed
        polarhistogram(data, binSize);
        ax = gca;
        ax.ThetaZeroLocation = 'top';  % 0 degrees at the top (North)
        ax.ThetaDir = 'clockwise';     % Angle increases in a clockwise direction
        %set(h, 'LineWidth', 2);
        set(gca,'FontSize',12);
        clear  eventp eventup eventdw strike eventGroup;


            % Export figure to PDF
            exportgraphics(gcf, pdf_file, 'Append', true);
            close;
        end

    end
end
