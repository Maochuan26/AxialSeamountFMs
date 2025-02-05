clear;clc;close all;
load('/Users/mczhang/Documents/GitHub/FM3/02-data/G_FM/G_2015Erp_polished_Mw_Mo.mat');
data = readmatrix('/Users/mczhang/Documents/GitHub/SKHASH/SKHASH/examples/smile/IN/pol.csv');
[C,IA,IC] = unique(data(:,1));
event3D=data(IA,:);
for i=1:length(C)
    
end