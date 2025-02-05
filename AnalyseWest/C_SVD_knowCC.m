clc;clear;close all;
path='/Users/mczhang/Documents/GitHub/FM3/02-data/';
fields={'AS1','AS2','CC1','EC1','EC2','EC3','ID1'};
groups = {'E1','E2','E3','E4','W1','W2','S1'};
groupsload = {
    {'E1', 'E12'},
    {'E2', 'E12', 'E23'},
    {'E3', 'E23', 'E34'},
    {'E4', 'E34'},
    {'W1', 'W12'},
    {'W2', 'W12'},
    {'S1'}
};
for gp=1:length(groupsload)
    for kz=1:length(fields)   
        result=[];
        for gl=1:length(groupsload{gp})  
        load([path,'B_CC/B_',groupsload{gp}{gl},'_',fields{kz},'.mat']);
        result=[result;filteredResultsMatrix];
        end
        clear filteredResultsMatrix;
        filteredResultsMatrix=result;clear result;
            ind=find(filteredResultsMatrix(:,3)>=0);
         disp([groups{gp},'_',fields{kz},': Positve CC ratio: ',num2str(length(ind)/length(filteredResultsMatrix),2)]);
    end
    clear filteredResultsMatrix;
end

%% Calculate the pair numbers
clc;clear;close all;
path='/Users/mczhang/Documents/GitHub/FM3/02-data/';
fields={'AS1','AS2','CC1','EC1','EC2','EC3','ID1'};
groups = {'E1','E2','E3','E4','W1','W2','S1'};
groupsload = {
    {'E1', 'E12'},
    {'E2', 'E12', 'E23'},
    {'E3', 'E23', 'E34'},
    {'E4', 'E34'},
    {'W1', 'W12'},
    {'W2', 'W12'},
    {'S1'}
};
result=[];
for gp=1:length(groupsload)
    for kz=1:length(fields)   
        %result=[];
        for gl=1:length(groupsload{gp})  
        load([path,'B_CC/B_',groupsload{gp}{gl},'_',fields{kz},'.mat']);
        result=[result;filteredResultsMatrix];
        end
    end
end
%         clear filteredResultsMatrix;
%         filteredResultsMatrix=result;clear result;
%             ind=find(filteredResultsMatrix(:,3)>=0);
%          disp([groups{gp},'_',fields{kz},': Positve CC ratio: ',num2str(length(ind)/length(filteredResultsMatrix),2)]);
%     end
%     clear filteredResultsMatrix;
% end