% Define parameters
clc;clear;close all;
addpath '/Users/mczhang/Documents/GitHub/FM/01-scripts/matlab_ww'
path='/Users/mczhang/Documents/GitHub/FM3/02-data/';
path_FM= '/Users/mczhang/Documents/GitHub/FM/01-scripts/HASH_Manual';
fields={'AS1','AS2','CC1','EC1','EC2','EC3','ID1'};
groups = {'E1','E2','E3','E4','W1','W2','S1'};
min_Po_num=4;
min_SP_num=5;
average_num=15;
for gp=1:length(groups)
    %load([path,'F_Cl/F_',groups{gp},'.mat']);
    %load([path,'F_Cl/F_Po_ALL_top10.mat']);
    filename=[path_FM,'/Axial_',groups{gp},'_cluster.dat'];
    fid=fopen(filename,'w+');
    Po=Po_Clu;
    for i=1:length(unique([Po.Cluster]))
        ind_Cl=find([Po.Cluster]==i);
        if length(ind_Cl)>=100;continue;end
        %if sum([Po(ind_Cl).ALL])<7;continue;end
        fprintf(fid,'#\n');
        Time_Cl=mean([Po(ind_Cl).on]);
        Lon_Cl=mean([Po(ind_Cl).lon]);
        Lat_Cl=mean([Po(ind_Cl).lat]);
        Depth_Cl=mean([Po(ind_Cl).depth]);
        fprintf(fid,'%3d   %14.7f   %9.4f   %7.4f   %4.2f\n',i+99,Time_Cl,Lon_Cl,Lat_Cl,Depth_Cl);
        for j=1:length(ind_Cl)
            fprintf(fid,' %6d     %14.7f  %9.4f    %7.4f    %5.3f\n',Po(ind_Cl(j)).ID,Po(ind_Cl(j)).on,Po(ind_Cl(j)).lon,Po(ind_Cl(j)).lat,Po(ind_Cl(j)).depth);
            for k=1:length(fields) % Noise, Pamp, Samp;
                if eval(strcat('Po(ind_Cl(j)).Po_',fields{k},'>0')) %&& eval(strcat('~isempty(Po(ind_Cl(j)).R',fields{k},')')) %if we don't picks, how can we know the polarity
                    str_P=['U'];
                elseif eval(strcat('Po(ind_Cl(j)).Po_',fields{k},'<0'))% && eval(strcat('~isempty(Po(ind_Cl(j)).R',fields{k},')'))
                    str_P=['D'];
                else
                    continue;
                end
                eval(strcat('Noi=Po(ind_Cl(j)).NSP_',fields{k},'(1);'));
                eval(strcat('Pam=Po(ind_Cl(j)).NSP_',fields{k},'(3);'));
                eval(strcat('Sam=Po(ind_Cl(j)).NSP_',fields{k},'(2);'));
                letter = char(64 + j);
                str=strcat(fields{k},letter);
                fprintf(fid,[str,'  %s      %10.4f    %12.4f     %12.4f\n'],str_P,Noi,Pam,Sam);
            end
        end
    end
    fprintf(fid,'*\n');
    fclose(fid);
    J4_Write_felix_run_HASH3_New(filename,path_FM);
    cd /Users/mczhang/Documents/GitHub/FM3;
    filename1=[path_FM,'/hashout1.dat'];
    filename2=[path_FM,'/hashout2.dat'];
    filename3=[path_FM,'/hashout3.dat'];
    [event1] = read_hd3_output1(filename1);
    nevent = length(event1);
    [event2] = read_hd3_output2(filename2);
    nevent2 = length(event2);
    [event3] = read_hd3_output3(filename3);
    nevent3 = length(event3);
    for i=1:length(event1)
        % Change coordinate systems
        [event1(i).avfnorm,event1(i).avslip] =...
            fp2fnorm(event1(i).avmech(:,1),event1(i).avmech(:,2),event1(i).avmech(:,3));
        event1(i).b_axis=cross(event1(i).avfnorm,event1(i).avslip);
        event1(i).t_axis=(event1(i).avfnorm+event1(i).avslip)/sqrt(2);
        event1(i).p_axis=(event1(i).avfnorm-event1(i).avslip)/sqrt(2);
        event1(i).p_l=asin(norm(event1(i).p_axis(3))/norm(event1(i).p_axis))/pi*180;
        event1(i).t_l=asin(norm(event1(i).t_axis(3))/norm(event1(i).t_axis))/pi*180;
        event1(i).b_l=asin(norm(event1(i).b_axis(3))/norm(event1(i).b_axis))/pi*180;
        event1(i).check=sin(event1(i).b_l).^2+sin(event1(i).t_l).^2+sin(event1(i).p_l).^2;
        if event1(i).p_l>= 52 && event1(i).t_l<= 35
            event1(i).faultType = 'N';event1(i).color='b';event1(i).color2=[0,0,1];
        elseif event1(i).p_l<=35 && event1(i).t_l>= 52
            event1(i).faultType = 'R';event1(i).color='r';event1(i).color2=[1,0,0];
        elseif event1(i).p_l<= 40 && event1(i).b_l>= 45 && event1(i).t_l<=40
            event1(i).faultType = 'S';event1(i).color='g';event1(i).color2=[0,1,0];
        elseif event1(i).p_l<= 20 && event1(i).t_l>=40 && event1(i).t_l<= 52
            % olique reverse
            event1(i).faultType = 'R';event1(i).color='r';event1(i).color2=[1,0,0];
        elseif event1(i).p_l>= 40 && event1(i).p_l<= 52 && event1(i).t_l<=20
            % Oblique normal
            event1(i).faultType = 'N';event1(i).color='b';event1(i).color2=[0,0,1];
        else
            event1(i).faultType = 'U';event1(i).color='k';event1(i).color2=[0,0,0];
        end
    end

            if strcmp(event1(i).mechqual, 'C') || strcmp(event1(i).mechqual, 'D')
                if isequal(event1(i).color2, [0, 1, 0]) % Check if the original color2 is green
                    event1(i).color2 = [0.6, 1, 0.6]; % Set to lighter green
                elseif isequal(event1(i).color2, [1, 0, 0]) % Check if the original color2 is red
                    event1(i).color2 = [1, 0.6, 0.6]; % Set to lighter red
                elseif isequal(event1(i).color2, [0, 0, 1]) % Check if the original color2 is blue
                    event1(i).color2 = [0.6, 0.6, 1]; % Set to lighter blue
                end
            end
    if strcmp(groups{gp}(1),'W')
        Fault_Strike=342;%degree west
        Fault_dip = -40;%degree
        Fault_Rake=90;% reverse fault
    elseif strcmp(groups{gp}(1),'E')
        Fault_Strike=330;%degree east
        Fault_dip = 68;%degree
        Fault_Rake=90;   
    elseif strcmp(groups{gp}(1),'S')
        Fault_Strike=0;%degree east
        Fault_dip = 0;%degree
        Fault_Rake=0; 
    end
    avgFaultNormal=fp2fnorm(Fault_Strike, Fault_dip,Fault_Rake);
    % 2 & 3. Calculate the normal vectors for each event and determine the right plane
    for i = 1:length(event1)
        strike = event1(i).avmech(:,1);
        dip = event1(i).avmech(:,2);
        rake = event1(i).avmech(:,3);

        [n1, ~] = fp2fnorm(strike, dip,rake);
        [n2, ~] = fp2fnorm(strike + 180, 90 - dip,-rake);

        angle1 = acosd(dot(avgFaultNormal, n1));
        angle2 = acosd(dot(avgFaultNormal, n2));

        if angle1 < angle2
            event1(i).rightPlaneNormal = n1;
            event1(i).angle=angle1;

        else
            event1(i).rightPlaneNormal = n2;
            event1(i).angle=angle2;
        end
        % Calculate the strike and dip vectors from the rightPlaneNormal
        strike_vector = cross([0 0 1], event1(i).rightPlaneNormal); % This gives a horizontal vector in the fault plane
        dip_vector = cross(strike_vector, event1(i).rightPlaneNormal); % This gives a vector pointing downwards in the fault plane

        % Compute the slip vector in the fault plane using the rake angle
        slip_vector = cosd(rake) * strike_vector + sind(rake) * dip_vector;
        event1(i).rightSlip = slip_vector;
    end
    save([path,'G_FM/G_FM_',groups{gp},'_no_station_correction.mat'], 'event1', 'event2','event3');
end
toc;
%G_plot_allmech;
