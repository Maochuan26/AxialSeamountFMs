clc; clear; close all;

% Load the data
load('/Users/mczhang/Documents/GitHub/FM3/FMs_Composite_Single_SK_HASH_Final.mat');

% Calculate the means
mean_eventHASH = mean([eventHASH.mavg]) / 100;
mean_eventSKHASH = mean(abs([eventSKHASH.mavg])) / 100;

% Create the figure
figure;set(gcf,'Position',[744   496   664   454]);

% Plot the first histogram
subplot(1, 2, 1);
histogram([eventHASH_org.mavg] / 100, 20); % Updated to use 'histogram'
title(['1D (Median = ', num2str(mean_eventHASH, '%.2f'), ')']);
xlabel('SP amplitude ratio misfit');
ylabel('Count');
grid on;

% Plot the second histogram
subplot(1, 2, 2);
histogram(abs([eventSKHASH_org.mavg]) / 100, 20); % Updated to use 'histogram'
title(['3D (Median = ', num2str(mean_eventSKHASH, '%.2f'), ')']);
xlabel('SP amplitude ratio misfit');
ylabel('Count');
grid on;

% Add a title for the entire figure
sgtitle('Comparison of SP amplitude ratio misfit of 1D and 3D FM result');


figure('Position',[100, 100, 1046         664]);

%% --- Subplot 2: 3D scatter plot ---
subplot(1,2,1);

% (Make sure you have the function 'axial_calderaRim' in the path)
axial_calderaRim;
plot(calderaRim(:,1), calderaRim(:,2), 'k', 'LineWidth', 3);
hold on;

lat = [eventHASH.lat];
lon = [eventHASH.lon];
depth = [eventHASH.depth];
kg = [eventHASH.mavg]/100;

% 3D scatter plot
scatter3(lon, lat, depth, 20, kg, 'filled');
set(gca, 'ZDir', 'reverse');  % Reverse Z-axis

% Plot stations (adjust if needed)
sta = axial_stationsNewOrder;
sta = sta(1:7);
for ind = 1:7
    plot(sta(ind).lon, sta(ind).lat, 's', ...
         'MarkerEdgeColor','k', 'MarkerFaceColor','k', ...
         'MarkerSize', 10);
end

colormap jet;  % Or any other colormap you prefer
colorbar;
caxis([0 1.6]);
title('1D SP amplitude ratio misfit distribution');
xlabel('Longitude'); ylabel('Latitude'); zlabel('Depth (km)');
grid on;
set(gca, 'FontSize', 12);

subplot(1,2,2);

% (Make sure you have the function 'axial_calderaRim' in the path)
axial_calderaRim;
plot(calderaRim(:,1), calderaRim(:,2), 'k', 'LineWidth', 3);
hold on;

lat = [eventSKHASH.lat];
lon = [eventSKHASH.lon];
depth = [eventSKHASH.depth];
kg = abs([eventSKHASH.mavg])/100;

% 3D scatter plot
scatter3(lon, lat, depth, 20, kg, 'filled');
set(gca, 'ZDir', 'reverse');  % Reverse Z-axis

% Plot stations (adjust if needed)
sta = axial_stationsNewOrder;
sta = sta(1:7);
for ind = 1:7
    plot(sta(ind).lon, sta(ind).lat, 's', ...
         'MarkerEdgeColor','k', 'MarkerFaceColor','k', ...
         'MarkerSize', 10);
end

colormap jet;  % Or any other colormap you prefer
colorbar;
caxis([0 1.6]);
title('3D SP amplitude ratio misfit distribution');
xlabel('Longitude'); ylabel('Latitude'); zlabel('Depth (km)');
grid on;
set(gca, 'FontSize', 12);
