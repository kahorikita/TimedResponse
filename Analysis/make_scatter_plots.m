% analyze TR shooting data with speed manipulation

clear
clc
close all

% load TimedResponse_compact.mat
% load ang45_TimedResponse_compact.mat
load time100_TimedResponse_compact.mat

%% look at raw scatter plots

for cnd = 1:3 % 1:fast, 2:med, 3:slow 
    fhandle = figure(cnd); clf; hold on
    set(fhandle,'Position',[100 100 1600 1300]);
    set(fhandle,'Color','w');
    
    for subj = 1:12
        subplot(3,4,subj); hold on
        plot(d{subj,cnd}.RT(d{subj,cnd}.response==1),d{subj,cnd}.initDir(d{subj,cnd}.response==1),'k.','MarkerSize',13);
        plot(d{subj,cnd}.RT(d{subj,cnd}.response==2),d{subj,cnd}.initDir(d{subj,cnd}.response==2),'r.','MarkerSize',13);
        xlim([0 600])
    end
end

%% plot all data together

fhandle = figure(4); clf; hold on
set(fhandle,'Position',[200 200 1000 800]);
set(fhandle,'Color','w')

style = {'r.','m.','b.'};
for cnd = 1:3
    for subj = 1:12
        plot(d{subj,cnd}.RT(d{subj,cnd}.response==1),d{subj,cnd}.initDir(d{subj,cnd}.response==1),style{cnd},'MarkerSize',13);
        plot(d{subj,cnd}.RT(d{subj,cnd}.response==2),d{subj,cnd}.initDir(d{subj,cnd}.response==2),style{cnd},'MarkerSize',13);
    end
end
