% Define parameters
clc;clear;close all;
addpath '/Users/mczhang/Documents/GitHub/FM/01-scripts/matlab_ww'
path='/Users/mczhang/Documents/GitHub/FM3/02-data/';
path_FM= '/Users/mczhang/Documents/GitHub/SKHASH/SKHASH';
fields={'AS1','AS2','CC1','EC1','EC2','EC3','ID1'};
%% input and output
load('/Users/mczhang/Documents/GitHub/FM3/02-data/F_Cl/F_final_AZ_TOF_1D_3D2.mat');
Po=Po_Clu;clear Po_Clu;
tic;
   n=1;m=1;
for i=1:length(unique([Po.Cluster])) 
    ind_Cl=find([Po.Cluster]==i);
    if length(ind_Cl)>=100;continue;end
    %if sum([Po(ind_Cl).ALL])<7;continue;end
    timenum(m)=mean([Po(ind_Cl).on]);
    longitude(m)=mean([Po(ind_Cl).lon]);
    latitude(m)=mean([Po(ind_Cl).lat]);
    depth(m)=mean([Po(ind_Cl).depth]);
    horz_uncertain_km(m)=0.3;
    vert_uncertain_km(m)=0.2;
    mag(m)=0;
    event_id2(m)=i;
    m=m+1;
    for j=1:length(ind_Cl)
        for k=1:length(fields) % Noise, Pamp, Samp;
            if mean(Po(ind_Cl(j)).(['NSP_',fields{k}]))==1
                continue;
            end
            event_id(n)=i;
            letter = char(64 + j);
            station{n}=strcat(fields{k},letter);
            network{n}='XX';
            location{n}='--';
            channel{n}='EHZ';
            if eval(strcat('Po(ind_Cl(j)).Po_',fields{k},'>0')) %&& eval(strcat('~isempty(Po(ind_Cl(j)).R',fields{k},')')) %if we don't picks, how can we know the polarity
                %p_polarity(n)=1;
                p_polarity(n)=Po(ind_Cl(j)).(['Po_', fields{k}]);
            elseif eval(strcat('Po(ind_Cl(j)).Po_',fields{k},'<0'))% && eval(strcat('~isempty(Po(ind_Cl(j)).R',fields{k},')'))
                %p_polarity(n)=-1;
                p_polarity(n)=Po(ind_Cl(j)).(['Po_', fields{k}]);
            else
                continue;
            end
            if length(Po(ind_Cl(j)).(['NSP_',fields{k}]))>3
            eval(strcat('Nos=Po(ind_Cl(j)).NSP_',fields{k},'(1);'));%s noise
            eval(strcat('Nop=Po(ind_Cl(j)).NSP_',fields{k},'(2);'));%p noise
            eval(strcat('Pam=Po(ind_Cl(j)).NSP_',fields{k},'(4);'));%p amp
            eval(strcat('Sam=Po(ind_Cl(j)).NSP_',fields{k},'(3);'));%s amp
            else
            eval(strcat('Nos=Po(ind_Cl(j)).NSP_',fields{k},'(1);'));%s noise
            eval(strcat('Nop=Po(ind_Cl(j)).NSP_',fields{k},'(1);'));%p noise
            eval(strcat('Pam=Po(ind_Cl(j)).NSP_',fields{k},'(3);'));%p amp
            eval(strcat('Sam=Po(ind_Cl(j)).NSP_',fields{k},'(2);'));%s amp
            end 
            %sp_ratio(n)=log10(Sam/Pam);
            sp_ratio(n)=Sam/Pam;
           if isfield(Po(ind_Cl(j)).event, ['TOA', fields{k}]) 

              eval(strcat('takeoff(n)=Po(ind_Cl(j)).event.TOA',fields{k},'(2);'));
              eval(strcat('azimuth(n)=Po(ind_Cl(j)).event.AZ',fields{k},'(2);'));
            end
            takeoff_uncertainty(n)=10;
            azimuth_uncertainty(n)=5;
            n=n+1;

        end
    end
end

% Create a table
T = table(event_id', station', network', location', channel', sp_ratio', takeoff', takeoff_uncertainty', azimuth', azimuth_uncertainty', ...
    'VariableNames', {'event_id', 'station', 'network', 'location', 'channel', 'sp_ratio', 'takeoff', 'takeoff_uncertainty', 'azimuth', 'azimuth_uncertainty'});
% Write the table to a CSV file
writetable(T, '/Users/mczhang/Documents/GitHub/SKHASH/SKHASH/examples/smile/IN/amp.csv');

% Create a table
T1 = table(event_id', station', network', location', channel', p_polarity', takeoff', takeoff_uncertainty', azimuth', azimuth_uncertainty', ...
    'VariableNames', {'event_id', 'station', 'network', 'location', 'channel', 'p_polarity', 'takeoff', 'takeoff_uncertainty', 'azimuth', 'azimuth_uncertainty'});
% Write the table to a CSV file
writetable(T1, '/Users/mczhang/Documents/GitHub/SKHASH/SKHASH/examples/smile/IN/pol.csv');

clear event_id;
event_id=event_id2;
    time= datetime(timenum, 'ConvertFrom', 'datenum', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS');


% Create a table
T2 = table( string(time)', latitude', longitude', depth', horz_uncertain_km', vert_uncertain_km', mag',event_id', ...
    'VariableNames', {'time', 'latitude', 'longitude', 'depth', 'horz_uncertain_km', 'vert_uncertain_km', 'mag','event_id'});

% Write the table to a CSV file
writetable(T2, '/Users/mczhang/Documents/GitHub/SKHASH/SKHASH/examples/smile/IN/eq_catalog.csv');

