% Load your data
close all; clear;
load('/Users/mczhang/Documents/GitHub/FM3/02-data/G_FM/G_2015Erp_polished_Mw_Mo.mat')

% --- First figure: max_azimgap ---
figure('Position',[2352 290 560 638]);
axial_calderaRim;
plot(calderaRim(:,2), calderaRim(:,1), 'k', 'LineWidth', 3);
hold on;
scatter3([event1.lat], [event1.lon], [event1.depth], 5, [event1.max_azimgap]);
colorbar;
view(90,-90);
title('Max Azimuthal Gap');

% --- Second figure: max_takeoff ---
figure('Position',[1352 290 560 638]);
plot(calderaRim(:,2), calderaRim(:,1), 'k', 'LineWidth', 3);
hold on;
scatter3([event1.lat], [event1.lon], [event1.depth], 5, [event1.max_takeoff]);
colorbar;
view(90,-90);
title('Max Takeoff Angle');

% --- Third figure: subset with max_azimgap < 240 & max_takeoff < 60 ---
% Create a logical index to filter the events
idx_subset = [event1.max_azimgap] < 240 & [event1.max_takeoff] < 60;

% Extract the subset of events
event_subset = event1(idx_subset);

% Extract the excluded events
event_excluded = event1(~idx_subset);

% Plot the subset AND excluded in a new figure
figure('Position',[752 290 560 638]);
plot(calderaRim(:,2), calderaRim(:,1), 'k', 'LineWidth', 3);
hold on;

% Plot the subset events with color mapped to max_azimgap (adjust as desired)
s1 = scatter3([event_subset.lat], [event_subset.lon], [event_subset.depth], ...
              30, [event_subset.max_azimgap], 'filled');

% Plot the excluded events in another color or style (e.g., black)
s2 = scatter3([event_excluded.lat], [event_excluded.lon], [event_excluded.depth], ...
              10, 'k', 'filled');

% Format
colorbar;
view(90, -90);
title('Subset (max\_azimgap < 240 & max\_takeoff < 60) vs. Excluded');
