%clc;clear;
load('/Users/mczhang/Documents/GitHub/FM3/02-data/F_Cl/F_2015Erp_Final_Mw_Mo_simple.mat');
load('/Users/mczhang/Documents/GitHub/FM3/G_2015_SKHASH.mat');
clear event2 event3;
for i=1:length(event1)
    ind=find([Po_Clu.Cluster]==event1(i).id);
    for j=1:length(ind)
    Po_Clu(ind(j)).avfnorm=event1(i).avfnorm;
    Po_Clu(ind(j)).avslip= event1(i).avslip;
    Po_Clu(ind(j)).avslip= event1(i).avslip;
    Po_Clu(ind(j)).avmech= event1(i).avmech;
    Po_Clu(ind(j)).mechqual= event1(i).mechqual;
    Po_Clu(ind(j)).color= event1(i).color;
    Po_Clu(ind(j)).color2= event1(i).color2;
    Po_Clu(ind(j)).faultType= event1(i).faultType;
    Po_Clu(ind(j)).max_azimgap= event1(i).max_azimgap;
    Po_Clu(ind(j)).max_takeoff= event1(i).max_takeoff;
    end
end

[B,I]=sort([Po_Clu.on],'ascend');
Po_Clu=Po_Clu(I);
Po_Clu([Po_Clu.max_azimgap]>240)=[];
Po_Clu([Po_Clu.max_takeoff]>60)=[];


% Po_Clu = rmfield(Po_Clu, 'SP_AS1');
% Po_Clu = rmfield(Po_Clu, 'SP_AS2');
% Po_Clu = rmfield(Po_Clu, 'SP_CC1');
% Po_Clu = rmfield(Po_Clu, 'SP_EC1');
% Po_Clu = rmfield(Po_Clu, 'SP_EC2');
% Po_Clu = rmfield(Po_Clu, 'SP_ID1');
% Po_Clu = rmfield(Po_Clu, 'SP_EC3');
% 
% Po_Clu = rmfield(Po_Clu, 'DDt_AS1');
% Po_Clu = rmfield(Po_Clu, 'DDt_AS2');
% Po_Clu = rmfield(Po_Clu, 'DDt_CC1');
% Po_Clu = rmfield(Po_Clu, 'DDt_EC1');
% Po_Clu = rmfield(Po_Clu, 'DDt_EC2');
% Po_Clu = rmfield(Po_Clu, 'DDt_ID1');
% Po_Clu = rmfield(Po_Clu, 'DDt_EC3');
% 
% Po_Clu = rmfield(Po_Clu, 'NSP_AS1');
% Po_Clu = rmfield(Po_Clu, 'NSP_AS2');
% Po_Clu = rmfield(Po_Clu, 'NSP_CC1');
% Po_Clu = rmfield(Po_Clu, 'NSP_EC1');
% Po_Clu = rmfield(Po_Clu, 'NSP_EC2');
% Po_Clu = rmfield(Po_Clu, 'NSP_ID1');
% Po_Clu = rmfield(Po_Clu, 'NSP_EC3');
% 
% Po_Clu = rmfield(Po_Clu, 'Po_AS1');
% Po_Clu = rmfield(Po_Clu, 'Po_AS2');
% Po_Clu = rmfield(Po_Clu, 'Po_CC1');
% Po_Clu = rmfield(Po_Clu, 'Po_EC1');
% Po_Clu = rmfield(Po_Clu, 'Po_EC2');
% Po_Clu = rmfield(Po_Clu, 'Po_ID1');
% Po_Clu = rmfield(Po_Clu, 'Po_EC3');