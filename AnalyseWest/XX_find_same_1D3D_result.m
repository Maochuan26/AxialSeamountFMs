clc;clear;close all;
load('/Users/mczhang/Documents/GitHub/FM3/02-data/F_Cl/F_2015Erp_Final_Mw_Mo_simple.mat');
load('/Users/mczhang/Documents/GitHub/FM3/FMs_Composite_Single_SK_HASH_Final.mat')
clear event2 event3;
% [c1,ia1,ic1]=unique([event1.id]);
% event=event1(ia1);
% clear event1;
event1=eventHASH;
n=1;
for i=1:length(Po_CluSKHASH)
    if ~isempty(Po_CluSKHASH(i).avfnorm)
        Po_CluSKHASH2(n)=Po_CluSKHASH(i);
        n=n+1;
    end
end
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
% 
 Po_Clu([Po_Clu.max_azimgap]>240)=[];
 Po_Clu([Po_Clu.max_takeoff]>60)=[];

load('/Users/mczhang/Documents/GitHub/FM3/FMs_Composite_Single_HASH.mat')
eventHASH=event1;
Po_CluHASH=Po_Clu;
clear event1 Po_Clu;
load('/Users/mczhang/Documents/GitHub/FM3/FMs_Composite_Single_SKHASH3.mat')
eventSKHASH=event;
Po_CluSKHASH=Po_Clu;
clear event Po_Clu;
[C,IA,IB]=intersect([eventSKHASH.id]+99,[eventHASH.id]);
eventSKHASH2=eventSKHASH(IA);


for i=1:length(eventSKHASH2)
    eventSKHASH2(i).time=eventHASH(IB(i)).on;
    eventSKHASH2(i).lon=eventHASH(IB(i)).lon;
    eventSKHASH2(i).lat=eventHASH(IB(i)).lat;
end

clear C IA IB;
[C,IA,IB]=intersect([Po_CluSKHASH2.ID],[Po_CluHASH.ID]);
Po_CluHASH3=Po_CluHASH(IB);
%Po_CluSKHASH2=Po_CluSKHASH(IA);

Po_CluHASH([Po_CluHASH.faultType]=='U')=[];
Po_CluHASH([Po_CluHASH.mechqual]=='C')=[];Po_CluHASH([Po_CluHASH.mechqual]=='D')=[];
