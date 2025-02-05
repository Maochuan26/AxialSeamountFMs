clear; close all;
path = '/Users/mczhang/Documents/GitHub/FM3/02-data/';
project = {'BF','DR','AF'};
projects = {'Before','During','After'};
region = {'West','East','All'};
date_BF = datenum(2015, 4, 24, 8, 0, 0);
date_DR = datenum(2015, 5, 19);
date_AF = datenum(2021, 12, 31);
pdf_file = ['/Users/mczhang/Documents/GitHub/FM3/03-output-graphics/' 'G_HASH_Many_FMs_verticalV6_rotatev4.pdf'];

if exist(pdf_file, 'file') == 2
    delete(pdf_file);
end

regions = struct(...
    'West', struct('Lat', [45.93, 45.96], 'Lon', [-130.03, -130.006]), ...
    'East', struct('Lat', [45.93, 45.96], 'Lon', [-130.00, -129.975]));

lat_splits = [45.955,45.950, 45.945, 45.940, 45.935, 45.930];

for reg = 1:1
    define_region = regions.(region{reg});

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
        % Sort events by depth and plot
        [~, I] = sort([event.depth], 'ascend');
        event = event(I);

        % Common settings for region limits
        x1 = define_region.Lon(1);
        x2 = define_region.Lon(2);
        y1 = define_region.Lat(1);
        y2 = define_region.Lat(2);
        y_length = y2 - y1;
        x_length = x2 - x1;
        radius = 0.0002;

        validFelix = Felix([Felix.lat] >= y1 & [Felix.lat] <= y2 & [Felix.lon] >= x1 & [Felix.lon] <= x2);
        Felix2 = validFelix; clear Felix;
        Felix = Felix2;

        %% Plot 1: Latitude vs Longitude
        figure;
        X_Z_test_fissures;
        set(gcf, 'Position', [2828 378 952 935]);
        axis equal;

        % Set x and y limits for latitude and longitude
        xlim([x1 - 1/10 * x_length, x2 + 1/10 * x_length]);
        ylim([y1 - 1/10 * y_length, y2 + 1/10 * y_length]);

        % Scatter plot of longitude vs latitude
        scatter([Felix.lon], [Felix.lat], 10, [Felix.depth], 'filled');
        colormap(flipud(colormap('summer')));
        hold on;
        for i = 1:length(event)
            if isempty(event(i).Mw)
                event(i).Mw = 0.1;
            end
            % Plot balloons
            plot_balloon(event(i).avfnorm, event(i).avslip, event(i).lon, event(i).lat, event(i).Mw * radius, 1.0, event(i).color);
        end

        % Title and labels
        title([region{reg} ' ' project{kp} ' Latitude vs Longitude']);
        xlabel('Longitude');
        ylabel('Latitude');
        c = colorbar;
        caxis([0 2]);  % Set color axis limits
        c.Position = [0.85, 0.8, 0.03, 0.1];  % [x, y, width, height] for colorbar inside the figure

       grid on;
       hold on;

        %% Insert 5 rose plots on the right
        for j = 1:length(lat_splits)-1
            y_upper = lat_splits(j);
            y_lower = lat_splits(j+1);

            % Filter events for this latitude range
            event_range = event([event.lat] < y_upper & [event.lat] >= y_lower);

            % Extract strike angles
            strike = [];
            for i = 1:length(event_range)
                strike(i) = event_range(i).avmech(1);  % Assuming avmech contains the strike angle
            end

            % Plot rose plot for this latitude range
            inset_ax = axes('Position', [0.75, 0.68 - (j-1)*0.135, 0.1, 0.1]); % Adjust position for each subplot
            axes(inset_ax);
            binSize = 30; % degrees
            data = deg2rad(strike);  % Convert degrees to radians
            polarhistogram(data, binSize);
            ax = gca;
            ax.ThetaZeroLocation = 'top';  % 0 degrees at the top (North)
            ax.ThetaDir = 'clockwise';     % Angle increases in a clockwise direction
            set(gca, 'FontSize', 8);
            title(['Lat: ', num2str(y_lower), ' - ', num2str(y_upper)]);
        end

        hold off;

        % Export figure to PDF
        exportgraphics(gcf, pdf_file, 'Append', true);
        close;

    end
end
