% Make all figures
clear
clc
addpath ../functions
load TimedResponse_dAll.mat

Hz = 130; % sampling frequency
bin = 7.7; % msec
sz = 30;

xplot = [.001:.001:1.2]; % x values to compute the sliding window over
w = 0.05;
msxplot = xplot * 1000;

col{1} = '#0b345d';
col{2} = '#318ce7';
col{3} = '#31e7e7';
col{4} = '#ff8c00';

%% Velocity profile
% plot correct trials only

fhandle = figure(1); clf; hold on
set(fhandle, 'Position', [200, 100, 800, 350]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white

fhandle = figure(2); clf; hold on
set(fhandle, 'Position', [200, 100, 500, 350]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white

for cnd = 1:4 % 1:fast, 2:med, 3:slow, 4:p2p
 
    if cnd == 4
        numofsub = 20;
    else 
        numofsub = 12;
    end
    
    figure(1); subplot(1,4,cnd); hold on;
    meanvel = nanmean(dAll{cnd}.Vel,1)*Hz;
    stdvel = nanstd(dAll{cnd}.Vel)*Hz;
    shadedErrorBar(bin*(1:length(meanvel)),meanvel,stdvel/numofsub,'lineprops',{'color',col{cnd}}) % plot time/velocity 
    if cnd == 1
        title('Fast');
        xlabel('Time (ms)');
        ylabel('Velocity (m/s)')
    elseif cnd == 2
        title('Medium');
    elseif cnd == 3
        title('Slow');
    else
        title('Point-to-point');
    end
    set(gca,'FontSize',16);
    axis([0 400 0 1])

    figure(2); hold on;
    shadedErrorBar(bin*(1:length(meanvel)),meanvel,stdvel/numofsub,'lineprops',{'color',col{cnd}}) 
    xlabel('Time (ms)');
    ylabel('Velocity (m/s)')
    set(gca,'FontSize',16);
    axis([0 400 0 1])
 
end


%% Speed-accuracy trade-off

fhandle = figure(3); clf; hold on
set(fhandle, 'Position', [200, 100, 800, 350]);
set(fhandle, 'Color','w')

fhandle = figure(4); clf; hold on
set(fhandle, 'Position', [200, 100, 500, 350]); 
set(fhandle, 'Color','w') 

for cnd = 1:4 % 1:fast, 2:med, 3:slow, 4:p2p
 
    if cnd == 4
        numofsub = 20;
    else 
        numofsub = 12;
    end
    
    figure(3); subplot(1,4,cnd); hold on;
    meanphit = nanmean(dAll{cnd}.phit_sliding,1);
    stdphit = nanstd(dAll{cnd}.phit_sliding);
    shadedErrorBar(msxplot,meanphit,stdphit/numofsub,'lineprops',{'color',col{cnd}}) 
    if cnd == 1
        title('Fast');
        xlabel('Decision-making Time (ms)')
        ylabel('Proportion correct')
    elseif cnd == 2
        title('Medium');
    elseif cnd == 3
        title('Slow');
    else
        title('Point-to-point');
    end
    set(gca,'FontSize',16);
    axis([0 400 0 1])

    figure(4); hold on;
    shadedErrorBar(msxplot,meanphit,stdphit/numofsub,'lineprops',{'color',col{cnd}}) 
    xlabel('Decision-making Time (ms)')
    ylabel('Proportion correct')
    set(gca,'FontSize',16);
    axis([0 400 0 1])
 
end


%% model fitting

fhandle = figure(5); clf; hold on
set(fhandle, 'Position', [200, 100, 500, 350]); 
set(fhandle, 'Color','w') 

for cnd = 1:4 % 1:fast, 2:med, 3:slow, 4:p2p
 
    [model, pr_fitted, phit_sliding] = fit_model(dAll{cnd}.RT, dAll{cnd}.response);
    plot(msxplot,phit_sliding(1,:),'color',col{cnd},'linewidth',.5);  
    plot(msxplot,pr_fitted,'color',col{cnd},'linewidth',2); % fitted curve 
%     plot([model(1)*1000 model(1)*1000],[0 1],'color',col{cnd},'linewidth',2)
    set(gca,'FontSize',16);
    axis([0 400 0 1])
 
end

xlabel('Decision-making Time (ms)')
ylabel('Probability')
legend({'Fast-data','Fast-model','Medium-data','Medium-model','Slow-data','Slow-model','P2P-data','P2P-model'},'Location','best')


%% Velocity and RT 

fhandle = figure(6); clf; hold on
set(fhandle, 'Position', [200, 100, 500, 350]); 
set(fhandle, 'Color','w') 

for cnd = 1:4 % 1:fast, 2:med, 3:slow, 4:p2p
 
    if cnd == 4
        numofsub = 20;
    else 
        numofsub = 12;
    end
    
    % check outliers 
    count = 1; model = []; maxyVel = [];
    MAX_vel = nanmean(dAll{cnd}.maxyVel)*Hz+2*nanstd(dAll{cnd}.maxyVel)*Hz;
    MIN_vel = nanmean(dAll{cnd}.maxyVel)*Hz-2*nanstd(dAll{cnd}.maxyVel)*Hz;
    MAX_mu = nanmean(dAll{cnd}.model)*1000+2*nanstd(dAll{cnd}.model)*1000;
    MIN_mu = nanmean(dAll{cnd}.model)*1000-2*nanstd(dAll{cnd}.model)*1000;
    for i = 1:numofsub     
        if dAll{cnd}.maxyVel(i)*Hz < MAX_vel && dAll{cnd}.maxyVel(i)*Hz > MIN_vel && dAll{cnd}.model(i)*1000 < MAX_mu && dAll{cnd}.model(i)*1000 > MIN_mu          
            model(count) = dAll{cnd}.model(i);
            maxyVel(count) =  dAll{cnd}.maxyVel(i);
            count = count + 1;
        else
%             cnd
%             i
        end
    end   
    
    figure(6); hold on;
%     scatter(maxyVel*Hz,model*1000,sz,'MarkerEdgeColor',col{cnd},'MarkerFaceColor',col{cnd}); 
%     plot([nanmean(maxyVel)*Hz-nanstd(maxyVel)*Hz nanmean(maxyVel)*Hz+nanstd(maxyVel)*Hz],[nanmean(model)*1000 nanmean(model)*1000],'Color',col{cnd},'Linewidth',2);
%     plot([nanmean(maxyVel)*Hz nanmean(maxyVel)*Hz],[nanmean(model)*1000-nanstd(model)*1000 nanmean(model)*1000+nanstd(model)*1000],'Color',col{cnd},'Linewidth',2);
    p(cnd) = scatter(dAll{cnd}.maxyVel*Hz,dAll{cnd}.model*1000,sz,'MarkerEdgeColor',col{cnd},'MarkerFaceColor',col{cnd});
    plot([nanmean(dAll{cnd}.maxyVel)*Hz-nanstd(dAll{cnd}.maxyVel)*Hz nanmean(dAll{cnd}.maxyVel)*Hz+nanstd(dAll{cnd}.maxyVel)*Hz],[nanmean(dAll{cnd}.model)*1000 nanmean(dAll{cnd}.model)*1000],'Color',col{cnd},'Linewidth',2);
    plot([nanmean(dAll{cnd}.maxyVel)*Hz nanmean(dAll{cnd}.maxyVel)*Hz],[nanmean(dAll{cnd}.model)*1000-nanstd(dAll{cnd}.model)*1000 nanmean(dAll{cnd}.model)*1000+nanstd(dAll{cnd}.model)*1000],'Color',col{cnd},'Linewidth',2);
    xlabel('Peak Velocity (m/s)','fontsize',16)
    ylabel('Decision-making Time (ms)','fontsize',16)
    set(gca,'FontSize',16);
    axis([0 1.5 100 300])
 
end

legend([p(1),p(2),p(3),p(4)],{'Fast','Medium','Slow','Point-to-point'})

