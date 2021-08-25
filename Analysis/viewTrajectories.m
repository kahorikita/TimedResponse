function viewTrajectories(data,rng)
% load TimedResponse_compact.mat
% plot trajectories (one-by-one) for data stored in 'data' for trials
% specified by 'rng'
% plots all data if 'rng' is not supplied
% example: viewTrajectories(d{5,1},1:10)

if(nargin<2)
    rng = 1:length(data.initDir);
end

fhandle = figure(1); clf; hold
set(fhandle,'Position',[200 200 800 800]);
set(fhandle,'Color','w');

subplot(3,2,4); cla; hold on
plot(data.RT(rng),data.initDir(rng),'.','Color',.7*[1 1 1],'MarkerSize',15);

for i=1:length(rng)
    subplot(3,2,[1 3 5]); cla; hold on
    title(['Trial ',num2str(rng(i))])
    axis equal
    
    X = data.Cr{rng(i)}(:,1);
    Y = data.Cr{rng(i)}(:,2);
    
    % target
    plot(0,.08,'y.','MarkerSize',100)
    
    plot(X,Y,'b','linewidth',2) % trajectory
    
    XiDir = X(data.iDir(rng(i)));
    YiDir = Y(data.iDir(rng(i)));
    plot(XiDir,YiDir,'k.','MarkerSize',14) % point where movement direction is calculated
    
    Xinit = X(data.init(rng(i)));
    Yinit = Y(data.init(rng(i)));
    plot(Xinit,Yinit,'ro') % point of movement initiation
    
    plot(X(data.ivel(rng(i))),Y(data.ivel(rng(i))),'g.','MarkerSize',14)
    
    % plot tangential velocity vector
    l = .2;
    dir_vector = l*[-sin(data.initDir(rng(i))*pi/180) cos(data.initDir(rng(i))*pi/180)];
    plot(XiDir + l*[0 dir_vector(1)],YiDir + l*[0 dir_vector(2)],'k','linewidth',2)
    
    
   
    subplot(3,2,2); cla; hold on
    plot(data.tanVel{rng(i)})
    plot(data.init(rng(i)),data.tanVel{rng(i)}(data.init(rng(i))),'ro')
    plot(data.iDir(rng(i)),data.tanVel{rng(i)}(data.iDir(rng(i))),'k.','MarkerSize',14)
    plot(data.ivel(rng(i)),data.tanVel{rng(i)}(data.ivel(rng(i))),'g.','MarkerSize',14)
    
    
    subplot(3,2,4); hold on
    if (i>1)
        plot(data.RT(rng(i-1)),data.initDir(rng(i-1)),'k.','MarkerSize',15)
    end
    plot(data.RT(rng(i)),data.initDir(rng(i)),'r.','MarkerSize',15)
    
    pause

end
