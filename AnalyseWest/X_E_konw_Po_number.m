%% need to be improved
clc;clear;close all;
addpath /Users/mczhang/Documents/GitHub/FM/01-scripts/subcode/
path='/Users/mczhang/Documents/GitHub/FM3/02-data/';
fields={'AS1','AS2','CC1','EC1','EC2','EC3','ID1'};
min_Po_num=4;
min_SP_num=5;
average_num=15;
%groups = {'E1','E2','E3','E4','W1','W2','S1','oldW'};
groups = {'E1','E2','S1','W1','E4','E3','W2','All'};
for gp=1:length(groups)
    load([path,'E_Po/E_',groups{gp},'.mat']);
    %load('/Users/mczhang/Documents/GitHub/FM/02-data/D_Po_W.mat')
    Po=Felix;clear Felix;
    fprintf('Group %s:%d\n', groups{gp},length(Po));
    for kz=1:length(fields)
        eval(strcat('Na_', fields{kz} ,'=0;'));
        eval(strcat('Nb_', fields{kz} ,'=0;'));
        for i=1:length(Po)
            eval(strcat('a=Po(i).W_',fields{kz} ,';'));
            eval(strcat('b=Po(i).Po_',fields{kz} ,';'));
            if ~isempty(a)
                eval(strcat('Na_', fields{kz} ,'=Na_', fields{kz} ,'+1;'));
            end
            if b~=0
                eval(strcat('Nb_', fields{kz} ,'=Nb_', fields{kz} ,'+1;'));
            end
        end
        eval(strcat('C=Na_', fields{kz} ,';'));
        eval(strcat('D=Nb_', fields{kz} ,';'));
        % Display the counts for the current field
        fprintf('  Number of non-empty W_%s: %d\n', fields{kz}, C);
        fprintf('  Number of non-empty Po_%s: %d\n', fields{kz}, D);

        clear Na* Nb* C D
    end

end


