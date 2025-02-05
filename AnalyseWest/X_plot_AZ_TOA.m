clc;clear;close all
load('/Users/mczhang/Documents/GitHub/FM3/02-data/G_FM/G_FM_AZ_TOF_Compare.mat');
fields={'AS1','AS2','CC1','EC1','EC2','EC3','ID1'};

% Initialize arrays to store differences and azi_difference
toa_difference = [];
azi_difference = [];
n=1;

% List of fields to process
fields = {'AS1', 'AS2', 'CC1', 'EC1', 'EC2', 'EC3', 'ID1'};
for k = 1:length(fields)
    for i = 1:length(event1)
        eval(strcat('TOA_values=event1(i).TOA',fields{k},';'));
         eval(strcat('AZ_values=event1(i).AZ',fields{k},';'));
            if TOA_values(1)~=0 && ~isnan(TOA_values(2))
                % Calculate the difference
                toa_difference (n)= TOA_values(2) - TOA_values(1);
                % Calculate the difference
                azi_difference (n)= AZ_values(2) - AZ_values(1);
                n=n+1;
            end
            clear TOA_values AZ_values;
        end
end

% Assuming 'toa_differences' and 'azi_difference' are arrays containing the data
% Calculate the 90th and 80th percentiles
toa_90 = prctile(abs(toa_difference), 90);
toa_80 = prctile(abs(toa_difference), 80);
azi_90 = prctile(abs(azi_difference), 90);
azi_80 = prctile(abs(azi_difference), 80);

% Plotting the distributions
figure;

% Plot TOA differences
subplot(2, 1, 1);
histogram(abs(toa_difference), 100);
title('Distribution of TOA Differences');
xlabel('TOA Difference (degrees)');
ylabel('Counts');
xlim([0 80]);
hold on;
% Add vertical lines for 90th and 80th percentiles
%xline(toa_90, 'r--', 'LineWidth', 2);
xline(toa_80, 'b--', 'LineWidth', 2);
% Add text labels
%text(toa_90, 5, sprintf('90%% = %.2f', toa_90), 'Color', 'r', 'FontSize', 10, 'VerticalAlignment', 'bottom');
text(toa_80, 5, sprintf('80%% = %.2f', toa_80), 'Color', 'b', 'FontSize', 10, 'VerticalAlignment', 'bottom');
hold off;
set(gca,'FontSize',16);

% Plot Azimuth values
subplot(2, 1, 2);
histogram(abs(azi_difference), 100);
title('Distribution of Azimuth difference');
xlabel('Azimuth (degrees)');
ylabel('Counts');
xlim([0 50]);
hold on;
% Add vertical lines for 90th and 80th percentiles
%xline(azi_90, 'r--', 'LineWidth', 2);
xline(azi_80, 'b--', 'LineWidth', 2);
% Add text labels
%text(azi_90, 5, sprintf('90%% = %.2f', azi_90), 'Color', 'r', 'FontSize', 10, 'VerticalAlignment', 'bottom');
text(azi_80, 5, sprintf('80%% = %.2f', azi_80), 'Color', 'b', 'FontSize', 10, 'VerticalAlignment', 'bottom');
hold off;

set(gca,'FontSize',16);
