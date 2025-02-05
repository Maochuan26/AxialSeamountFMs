clear; close all;
path = '/Users/mczhang/Documents/GitHub/FM3/02-data/';
project = {'BF','DR','AF'};
projects = {'Before','During','After'};
region = {'West','East','All'};
date_BF = datenum(2015, 4, 24, 8, 0, 0);
date_DR = datenum(2015, 5, 19);
date_AF = datenum(2021, 12, 31);
pdf_file = ['/Users/mczhang/Documents/GitHub/FM3/03-output-graphics/' 'G_HASH_Many_FMs_verticalV6_rotateV2.pdf'];

if exist(pdf_file, 'file') == 2
    delete(pdf_file);
end

regions = struct(...
    'West', struct('Lat', [45.93, 45.96], 'Lon', [-130.03, -130.006]), ...
    'East', struct('Lat', [45.93, 45.96], 'Lon', [-130.00, -129.975]));

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
        %event([event.faultType]=='S')=[];
        %event=event(1:100);

        % Common settings for region limits
        x1 = define_region.Lon(1);
        x2 = define_region.Lon(2);
        y1 = define_region.Lat(1);
        y2 = define_region.Lat(2);
        y_length = y2 - y1;
        x_length = x2 - x1;
        radius = 0.0002;

        validFelix = Felix([Felix.lat] >= y1 & [Felix.lat] <= y2 & [Felix.lon] >= x1 & [Felix.lon] <= x2);
        Felix2=validFelix;clear Felix;
        Felix=Felix2;

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
        colorbar;  % Add colorbar
        caxis([0 2]);  % Set color axis limits
        grid on;

        %% insect rose1
        x =[-130.0308
            -130.0056];
        y =[45.9444
            45.9444];
        hold on;
        plot([x(1); x(2)], [y(1); y(2)], 'r-.', 'LineWidth', 2); % Red line connecting points
        inset_ax = axes('Position', [0.6, 0.7, 0.2, 0.2]); % Adjust position [x, y, width, height] as needed7
        axes(inset_ax); % Set current axes to the inset axes
        eventup=event([event.lat] > y(1));
        eventp=eventup;
        eventp([eventp.faultType]=='S')=[];
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
        set(gca,'FontSize',12);clear strike;
        %% Rose 2
        inset_ax = axes('Position', [0.6, 0.1, 0.2, 0.2]); % Adjust position [x, y, width, height] as needed7
        axes(inset_ax); % Set current axes to the inset axes
        eventdw=event([event.lat] < y(1));
        clear eventp;
        eventp=eventdw;
        eventp([eventp.faultType]=='S')=[];
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

        hold on;
        %% insect the density
        inset_ax = axes('Position', [0.15, 0.08, 0.2, 0.2]); % Adjust position [x, y, width, height] as needed7
        axes(inset_ax); % Set current axes to the inset axes
        axial_calderaRim;
        [calderaRim(:,2), calderaRim(:,1)] = latlon2xy_no_rotate(calderaRim(:,2), calderaRim(:,1));
       

        xlim([-1.75 0.5]);
        ylim([-2.5 -0.5]);
        %plot(calderaRim(:,2), calderaRim(:,1), 'g', 'LineWidth', 3);
        hold on;
        [x, y] = latlon2xy_no_rotate([Felix.lat], [Felix.lon]);
        xEdges = -1.75:0.05:0.5;
        yEdges = -2.5:0.05:-0.5;
        N = histcounts2(x, y, xEdges, yEdges);
        imagesc(xEdges, yEdges, N');
        
        
        colormap(inset_ax, 'hot');  % Set different colormap for the inset
        inset_cb = colorbar(inset_ax);  % Add colorbar for inset plot
        inset_cb.Position = [0.36, 0.1, 0.02, 0.1];  % Adjust position of the inset colorbar
        hold on;
         plot(calderaRim(:,2), calderaRim(:,1), 'g', 'LineWidth', 3);
        % Add caldera rim to the plot
        set(gca, 'XTick', [], 'YTick', [])

        set(gca,'FontSize',12);
        
        hold off;

        % Export figure to PDF
        exportgraphics(gcf, pdf_file, 'Append', true);
        close;

        %% Plot 2: Latitude vs Depth
        figure;
        set(gcf, 'Position', [2828 378 952 935]);
        scatter([Felix.depth], [Felix.lat], 10, [Felix.depth], 'filled');
        colormap(flipud(colormap('summer')));
        hold on;
        % Set x and y limits for depth and latitude
        xlim([0 2]);  % Depth in km on x-axis
        ylim([y1 - 1/10 * y_length, y2 + 1/10 * y_length]);


        % Calculate the aspect ratio based on the y-axis and x-axis limits
        y_range = (y2 + 1/10*y_length) - (y1 - 1/10*y_length);
        x_range = 2;  % Depth range from 0 to 2 km
        aspect_ratio = y_range / x_range;

        % Scale the radius (rr) of the balloons to maintain the aspect ratio
        scale = 1 / aspect_ratio;  % This ensures the balloons are round

        for i = 1:length(event)
            if isempty(event(i).Mw)
                event(i).Mw = 0.1;
            end
            % Plot balloons
            plot_balloon(event(i).avfnorm, event(i).avslip, event(i).depth, event(i).lat, event(i).Mw *radius,scale, event(i).color);
        end

        % Title and labels
        title([region{reg} ' ' project{kp} ' Latitude vs Depth']);
        xlabel('Depth (km)');
        ylabel('Latitude');
        colorbar;  % Add colorbar
        caxis([0 2]);  % Set color axis limits
        grid on;
        hold off;

        % Export figure to PDF
        exportgraphics(gcf, pdf_file, 'Append', true);
        close;
    end
end




