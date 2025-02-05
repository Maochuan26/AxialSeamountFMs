%% Plot and pick the waveform
clc;clear;close all;
dt=1/200;
P_x=[-0.25 0.25];
P_x1=P_x(1):dt:P_x(2)-dt;
path='/Users/mczhang/Documents/GitHub/FM3/02-data/';
fields={'AS1','AS2','CC1','EC1','EC2','EC3','ID1'};
groups = {'E1','E2','E3','E4','W1','W2','S1'};

for gp = 1:length(groups)
    for kz = 1:length(fields)
        load([path, 'C_SVD/C_', groups{gp}, '_', fields{kz}, '.mat']);
        A = SVD_result;
        minA = min(A(:,2));
        maxA = max(A(:,2));
        
        % Print the min and max values for each combination
        disp(['Group: ', groups{gp}, ', Field: ', fields{kz}, ', Min A: ', num2str(minA), ', Max A: ', num2str(maxA)]);
    end
end
