clear; close all;
path='/Users/mczhang/Documents/GitHub/FM3/02-data/';
groups = {'E1','E2','W1','W2','S1','E3','E4'};
project={'BF','DR','AF'};
date_BF = datenum(2015, 4, 24, 8, 0, 0);
date_DR = datenum(2015, 5, 19);
date_AF = datenum(2021, 12, 31);
projects={'Before','During','After'};
pdf_file = ['/Users/mczhang/Documents/GitHub/FM3/03-output-graphics/' ...
    'G_HASH_ALL_V2.pdf'];
if exist(pdf_file, 'file') == 2
    delete(pdf_file);
end
for kp=1:length(project)
    load([path,'G_FM/G_2015Erp_polished_Mw_Mo.mat']);
    event=event1;

    if kp==1
        indEv=find([event.time]<date_BF);
    elseif kp==2
        indEv=find([event.time]>=date_BF & [event.time]< date_DR);
    else
        indEv=find([event.time]>=date_DR);
    end
    
    eventp=event(indEv);    
    %if kp==1;indEv=find([event1.id]<2310+99);elseif kp==2;indEv=find([event1.id]>=2310+99 & [event1.id]<2721+99);else indEv=find([event1.id]>=2721+99);end;
    clear event;
    event=eventp;
    %event([event.faultType]=='U')=[];
    %event([event.faultType]=='N')=[];
    %event([event.faultType]=='R')=[];
    eventp([eventp.mechqual]=='C' | [eventp.mechqual]=='D')=[];
    event([event.lat]>45.97)=[];
    
nmec = length(event);
figure; orient tall; clf; basemap_2015( [-130.04  -129.97],[45.92 45.97]);
hold on;
%grid on
iflbl = 'y';
radius = 0.0005;
scale = 1.4;
colorMatrix = zeros(length(event), 3); % Preallocate matrix
for i = 1:length(event)
    colorMatrix(i, :) = event(i).color2;
end
%   scatter3([event.lon], [event.lat], -[event.depth], 1, colorMatrix);
for i = 1:nmec
    if ~isempty(event(i).avfnorm)
        %h = plot_balloon(event(i).avfnorm, event(i).avslip, event(i).lon, event(i).lat, eventp(i).Mo*radius, scale,event(i).color2);
        h = plot_balloon(event(i).avfnorm, event(i).avslip, event(i).lon, event(i).lat, radius, scale,event(i).color2);
        hold on;
    end
end
xlabel('Longitude', 'fontsize', 14, 'fontangle', 'italic');
ylabel('Latitude', 'fontsize', 14, 'fontangle', 'italic');
orient('landscape');
grid on;
title([projects{kp} ' 2015 Eruption, N:' num2str(length(event))])
exportgraphics(gcf, pdf_file, 'Append', true,'Resolution', 400);
savemyfigure;
close;
end