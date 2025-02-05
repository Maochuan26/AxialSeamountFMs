%% Clear environment
clc; clear; close all;

%% Load your data
path = '/Users/mczhang/Documents/GitHub/FM3/02-data/G_FM/';
% load([path,'G_2015_SKHASH_AZ_TOA00_V11_sametime.mat']);
% [c1,ia1,ic1]=unique([event1.id]);
% eventall=event1(ia1);clear event1;
% event1=eventall;
% %load([path,'G_2015_SKHASH_V3_BEST.mat']);
% load('/Users/mczhang/Documents/GitHub/FM3/FMs_Composite_Single_SK_HASH.mat')
% event = eventHASH;
% % Remove poor quality events
% event([event.mechqual]=='C' | [event.mechqual]=='D') = [];
% event([event.faultType]=='U' ) = [];
% event1([event1.mechqual]=='C' | [event1.mechqual]=='D') = [];
% event1([event1.faultType]=='U' ) = [];
% 
% %%
% clear eventHASH;
% eventHASH=event;
% clear eventSKHASH
% eventSKHASH=event1;
% [C,IA,IB]=intersect([eventSKHASH.id]+99,[eventHASH.id]);
% eventSKHASH2=eventSKHASH(IA);
% eventHASH2=eventHASH(IB);
load('/Users/mczhang/Documents/GitHub/FM3/FMs_Composite_Single_SK_HASH_Final.mat');
event=eventHASH;
event1=eventSKHASH;

%% Compute Kagan angles
for i = 1:length(event)
    ind = find([event1.id] == event(i).id-99);
    if ~isempty(ind) && ind(1) <= 4090
        [rotangle,theta,phi] = kagan( ...
            [event(i).avmech(1), event(i).avmech(2), event(i).avmech(3)], ...
            [event1(ind(1)).avmech(1), event1(ind(1)).avmech(2), event1(ind(1)).avmech(3)]);
        event(i).kg = rotangle;
        event(i).qual = event1(ind(1)).mechqual;
        clear rotangle;
    end
end

% Remove empty or poor-quality events
emptyIndices = cellfun(@isempty, {event.kg});
event(emptyIndices) = [];

%% Prepare data for histogram
data = real([event.kg]);  % Kagan angle values
value = 20;
percentage = sum(data <= value) / length(data) * 100;

% Calculate desired percentiles
p50 = prctile(data, 50);
p60 = prctile(data, 60);
p70 = prctile(data, 70);
p80 = prctile(data, 80);
p90 = prctile(data, 90);

%% Create one figure with two subplots
figure('Position',[100, 100, 1046         664]);

%% --- Subplot 1: Histogram ---
subplot(1,2,1);
hist(data, 20);
hold on;

title(['Kagan angle difference (1D vs 3D); mean: ' num2str(mean(data),2)]);
xlabel('Angle (°)');
set(gca, 'FontSize', 12);

% Plot vertical reference line at "value"
% yl = ylim;
% plot([value value], yl, 'k--', 'LineWidth', 2);
% text(value, yl(2)*0.95, ...
%      [num2str(value), '° (', num2str(percentage,3), '%)'], ...
%      'FontSize', 12, 'Color', 'k', 'HorizontalAlignment', 'right');

hold off;

%% --- Subplot 2: 3D scatter plot ---
subplot(1,2,2);

% (Make sure you have the function 'axial_calderaRim' in the path)
axial_calderaRim;
plot(calderaRim(:,1), calderaRim(:,2), 'k', 'LineWidth', 3);
hold on;

lat = [event.lat];
lon = [event.lon];
depth = [event.depth];
kg = real([event.kg]);

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
title('Kagan difference between 1D and 3D');
xlabel('Longitude'); ylabel('Latitude'); zlabel('Depth (km)');
grid on;
set(gca, 'FontSize', 12);


%% for test the rake number,

for i=1:length(eventSKHASH)
    rake(i)=eventSKHASH(i).avmech(2);
end
figure;
hist(rake,20)

