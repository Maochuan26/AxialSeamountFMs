clc; clear; close all;
%load('/Users/mczhang/Documents/GitHub/FM3/02-data/Felix_West.mat');

load('/Users/mczhang/Documents/GitHub/FM3/02-data/X_WestFM.mat');
Felix=event;

% Extract the necessary data
longitude = [Felix.lon];
latitude = [Felix.lat];
depth = -[Felix.depth];

% Define the custom boundary for clustering
boundary_points = [-130.03, 45.945; -130.005, 45.943];

% Classify the data based on the custom boundary
idx = (latitude > interp1(boundary_points(:,1), boundary_points(:,2), longitude, 'linear', 'extrap'));

% Separate the data into two clusters
cluster1 = [longitude(idx); latitude(idx); depth(idx)]';
cluster2 = [longitude(~idx); latitude(~idx); depth(~idx)]';

% Perform robust fitting for each cluster
f1 = fit([cluster1(:,1), cluster1(:,2)], cluster1(:,3), 'poly11', 'Robust', 'Bisquare');
f2 = fit([cluster2(:,1), cluster2(:,2)], cluster2(:,3), 'poly11', 'Robust', 'Bisquare');

% Create a grid of points for plotting the planes
[xgrid, ygrid] = meshgrid(linspace(min(longitude), max(longitude), 20), linspace(min(latitude), max(latitude), 20));

% Plane 1
zgrid1 = f1.p00 + f1.p10 * xgrid + f1.p01 * ygrid;

% Plane 2
zgrid2 = f2.p00 + f2.p10 * xgrid + f2.p01 * ygrid;

% Calculate the normal vectors of the planes
normal1 = [f1.p10, f1.p01, -1];
normal2 = [f2.p10, f2.p01, -1];

% Normalize the normal vectors
normal1 = normal1 / norm(normal1);
normal2 = normal2 / norm(normal2);

% Calculate the angle between the normal vectors
cos_theta = dot(normal1, normal2);
angle_difference = acosd(cos_theta);

% Plot the clustered data
figure;
scatter3(longitude(idx), latitude(idx), depth(idx), 10, 'r', 'filled', 'MarkerEdgeColor', 'none'); % Cluster 1 in red
hold on;
scatter3(longitude(~idx), latitude(~idx), depth(~idx), 10, 'b', 'filled', 'MarkerEdgeColor', 'none'); % Cluster 2 in blue

% Plot the fitted planes
surf(xgrid, ygrid, zgrid1, 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'FaceColor', 'r'); % Plane 1 in red
surf(xgrid, ygrid, zgrid2, 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'FaceColor', 'b'); % Plane 2 in blue

% Set the limits and labels
zlim([-2 0]);
view(84, 30);
grid on;
set(gca, 'FontSize', 20);
xlabel('Longitude');
ylabel('Latitude');
zlabel('Depth');
title(['Custom Clustering of Felix Data with Robust Fitted Planes. Angle Difference: ', num2str(angle_difference, '%.2f'), '°']);
hold off;

% Display the angle difference
disp(['The angle difference between the two planes is ', num2str(angle_difference), ' degrees']);
