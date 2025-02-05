clear; close all;
path='/Users/mczhang/Documents/GitHub/FM3/02-data/';
groups = {'E1','E2','W1','W2','S1','E3','E4'};
project={'BF','DR','AF'};
projects={'Before','During','After'};
date_BF = datenum(2015, 4, 24, 8, 0, 0);
date_DR = datenum(2015, 5, 19);
date_AF = datenum(2021, 12, 31);
% % % load([path,'G_FM/G_2015_SKHASH_v2.mat']);
 load([path, 'F_Cl/F_2015Erp_Final_Mw_Mo_simple.mat']);
load(['/Users/mczhang/Documents/GitHub/FM3/FMs_Composite_Single_SK_HASH_Final.mat']);
eventall=eventSKHASH;
% for i=1:length(event)
%     ind=find([Po_Clu.Cluster]==event(i).id);%% SKHASH no need to -99
%     event(i).lat=mean([Po_Clu(ind).lat]);
%     event(i).lon=mean([Po_Clu(ind).lon]);
%     event(i).depth=mean([Po_Clu(ind).depth]);
%     event(i).on= mean([Po_Clu(ind).on]);
% end
% [c1,ia1,ic1]=unique([event.id]);clear event1;
% eventall=event(ia1);
% %save('/Users/mczhang/Documents/GitHub/FM3/G_2015_SKHASH.mat', 'event1');
pdf_file = ['/Users/mczhang/Documents/GitHub/FM3/03-output-graphics/XX_compare1D_3D_all_SKHASH_Final.pdf'];
if exist(pdf_file, 'file') == 2
    delete(pdf_file);
end
for kp=1:length(projects)
    %load([path,'G_FM/G_2015Erp_V1V2V3_Po_SP_polished.mat']);
    %load([path,'G_FM/G_2015_SKHASH_AZ_TOA_V8_final_polish.mat']);
    %
    %load('FMs_Composite_Single_SK_HASH.mat');
    event1=eventall;
    if kp==1
        indEv=find([event1.on]<date_BF);
    elseif kp==2
        indEv=find([event1.on]>=date_BF & [event1.on]< date_DR);
    else
        indEv=find([event1.on]>=date_DR);
    end
    eventp=event1(indEv);
    %if kp==1;indEv=find([event1.id]<2310+99);elseif kp==2;indEv=find([event1.id]>=2310+99 & [event1.id]<2721+99);else indEv=find([event1.id]>=2721+99);end;
    clear event;
    event=eventp;
    %event([event.depth]<0.5)=[];
    event([event.mechqual]=='C' | [event.mechqual]=='D')=[];
    event([event.faultType]=='U')=[];
    % event([event.faultType]=='U' | [event.faultType]=='N' | [event.faultType]=='R')=[];

    nmec = length(event);
    figure;
    orient tall; clf; basemap_2015( [-130.05  -129.95],[45.90 46.00]);
    hold on;
    %grid on
    iflbl = 'y';
    radius = 0.0005;
    scale = 1.3;
    colorMatrix = zeros(length(event), 3); % Preallocate matrix
    for i = 1:length(event)
        colorMatrix(i, :) = event(i).color2;
    end
    %scatter3([event.lon], [event.lat], -[event.depth], 1, colorMatrix);
    for i = 1:nmec
        if ~isempty(event(i).avfnorm)
            h = plot_balloon(event(i).avfnorm, event(i).avslip, event(i).lon, event(i).lat, radius, scale,event(i).color2);
            hold on;
        end
    end
    xlabel('Longitude', 'fontsize', 14, 'fontangle', 'italic');
    ylabel('Latitude', 'fontsize', 14, 'fontangle', 'italic');
    orient('landscape');
    grid on;
    title([num2str(length(event)) ' FMs ' projects{kp} ' 2015 Eruption']);
    set(gca,'fontsize',20);
    set(gcf,'Position',[ 1000         554         560         684]);
    exportgraphics(gcf, pdf_file, 'Append', true);
    close;
end


