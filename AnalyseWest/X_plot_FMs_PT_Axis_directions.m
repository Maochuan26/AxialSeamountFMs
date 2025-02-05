addpath '/Users/mczhang/Documents/GitHub/Before2023/Maochuan_ana'
clear;% close all;
path='/Users/mczhang/Documents/GitHub/FM3/02-data/';
groups = {'E1','E2','E3','E4','W1','W2','S1'};
min_Po_num=4;
min_SP_num=5;
average_num=15;

figure;set(gcf,"Position",[972 394 594 781]);
%load([path,'G_FM/G_FM_oldW_old_man_po.mat']);
load('/Users/mczhang/Documents/GitHub/FM3/02-data/G_FM/G_FM_All.mat');
nmec = length(event);
%figure(22); orient tall; clf; basemap_2015( [-130.05  -129.95],[45.90 46.00]);
hold on;
%grid on
iflbl = 'y';
radius = 0.06;
scale = 1.25;

for i=1:length(event)
    [xxx, yyy] = latlon2xy([event(i).lat], [event(i).lon]);
    scatter3(xxx, yyy, -[event(i).depth], 1,  event(i).color2);
    hold on;
    quiver3(xxx, yyy, -event(i).depth, ...
        event(i).p_axis(1), ...
        event(i).p_axis(2), ...
        event(i).p_axis(3), ...
        0.2,  event(i).color); % Using blue color for differentiation
    hold on;
end
hold on;

% Plot caldera rim
axial_calderaRim;
[calderaRim(:,2), calderaRim(:,1)] = latlon2xy(calderaRim(:,2), calderaRim(:,1));
plot(calderaRim(:,2), calderaRim(:,1), 'k', 'LineWidth', 3);
hold on;
hold on;
axis equal;
ylim([-5 4.5]);
xlim([-3 3]);
% Add a colorbar
hold on;
hold on;
sta=axial_stationsNewOrder;
sta=sta(1:7); 
for i=1:length(sta)
[sta(i).x, sta(i).y] = latlon2xy([sta(i).lat], [sta(i).lon]);
plot(sta(i).x, sta(i).y,'s','MarkerEdgeColor','k',...
                       'MarkerFaceColor','k',...
                       'MarkerSize',10);
text(sta(i).x+0.1, sta(i).y,sta(i).name(3:end))
hold on;
end

set(gca,'FontSize',16);
