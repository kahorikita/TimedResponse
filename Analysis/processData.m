function data = processData(data)
% analyze cursor data for path length, RT, etc smooth trajectories


cutoffdeg = 15; % 40, 15 in NCM 
timeth = 6; % 6:50msec, 13:100msec

errorcount = 1;
errortr = 0;
mcount = 1;
res = [];

for i = 1:data.Ntrials
    
    % smooth trajectories
    data.Cr{i} = savgolayFilt(data.Cr{i}', 3, 7)';
        
    data.go(i) = find(data.state{i} == 3, 1); % time of waitogo (wait sounds come)
    data.init(i) = find(data.state{i} == 4, 1 ); % time of movement initiation
    data.end(i) = find(data.state{i} == 4, 1, 'last'); % time of movement end
    
    % compute preparation time and movement time   
    data.movtime(i) = data.time{i}(data.end(i)) - data.time{i}(data.init(i)); % movement time
    
    % compute velocities
    vel = diff(data.Cr{i});
    data.Vel{i} = vel;
    data.tanVel{i} = sqrt(sum(vel.^2,2));
       
    % compute peak tangent velocities
    data.smoothVel{i} = abs(smooth(data.tanVel{i}));
    [pks, lock] = findpeaks(data.smoothVel{i});
    minpks = find(pks > 0.0004);
    % if there is no vel peaks over threshold
    if isempty(minpks) == 1 
        errortr(errorcount,1) = i;
        minpks = 1;
        errorcount = errorcount + 1;
    end
    % if first vel peak happens before go que 
    minlocks = find(lock(minpks) > data.go(i), 1 );
    if isempty(minlocks)==1
        minlocks = 1;
        flag = 1;
    else
        flag = 0;
    end
    data.pkVel(i) = data.tanVel{i}(lock(minpks(minlocks)),1); % first peak vel after go que
    data.ipkVel(i) = lock(minpks(minlocks));
       
    % find the point just before across the threshold
    if flag == 0
        j = data.ipkVel(i);
        while abs(data.tanVel{i}(j,:)) > 2.0e-04
            j = j-1;
        end
        data.ivel(i) = j;
    else
        data.ivel(i) = data.ipkVel(i);
    end
    
     data.iDir(i) = data.ivel(i) + timeth; % 50 or 100 ms after initiation, data.initvel=time, data.iDir=time
     if data.iDir(i) < data.end(i)
        data.initDir(i) = rad2deg(atan2(vel(data.iDir(i),2),vel(data.iDir(i),1))); %data.initDir=angle[deg]
     elseif data.iDir(i) >= data.end(i)
        data.initDir(i) = NaN;
     end
     % rotated direction
     data.initDir(i) = data.initDir(i) - 90;
     if data.initDir(i) < -225
         data.initDir(i) = data.initDir(i) + 360;
     end     
%      % data.response = vector of responses, 1:correct response, 2:error
%      if data.initDir(i) > -22.5 && data.initDir(i) < 22.5 % correct
%          res(i) = 1;
%      else % error
%          res(i) = 2;
%      end
     
    % compute preparation time, initvel time - time when target is appeared
    data.RT(i) = (data.time{1,i}(data.ivel(1,i),1) - data.time{1,i}(data.go(1,i),1)) - data.tFile(i,5);
     
    % if RT is less than -200, it is replaced with 0
    if data.RT(i) < -200
        data.RT(i) = 0;
    end
          
    % find too curved trajectory at movement onset
    judgep = data.ivel(i) + timeth; % ivel+50msec 
    icount = 1;
    for j = judgep : judgep + timeth % onset+50msec~100msec
        % get initial angle change (arctan2)
        initDir1 = rad2deg(atan2(data.Vel{i}(j-1,2),data.Vel{i}(j-1,1))); %data.initDir=angle[deg]
        initDir2 = rad2deg(atan2(data.Vel{i}(j-2,2),data.Vel{i}(j-2,1))); %data.initDir=angle[deg]
        diffDir1Dir2(icount) = power((initDir1-initDir2)/2,2);
        icount = icount + 1;
    end
    data.diffDirs(i) = mean(diffDir1Dir2);
    
    % correct-select, correct-reject or error trials
    if data.initDir(i) > -22.5 && data.initDir(i) < 22.5 
        if data.diffDirs(i) > cutoffdeg || data.RT(i) == 0 || max(data.Cr{i}(:,2)) < 0.05
            data.response(i) = 2; % correct-reject
        elseif data.RT(i) ~= 0
            data.response(i) = 1; % correct-select
        end
    else
        data.response(i) = 2; % error
    end
    
    % find max y vel
    if data.response(i) == 1
        maxyvel(mcount) = maxk(abs(data.Vel{i}(data.ivel(i):data.ivel(i)+65,2)),1); % y-velocity   
        mcount = mcount + 1;
    end
    
end

% sort response & RT for model fitting and compacify data
[dsorted,I] = sort(data.response);
data.response = dsorted;
data.RT = data.RT(I);
data.initDir = data.initDir(I);
data.pkVel = data.pkVel(I);
data.tanVel = data.tanVel(I);
data.Vel = data.Vel(I);
data.Cr = data.Cr(I);
data.iDir = data.iDir(I);
data.init = data.init(I);
data.ivel = data.ivel(I);

% exlude catch trials
data.response(find(data.RT==0))=[];
data.initDir(find(data.RT==0)) = [];
data.pkVel(find(data.RT==0)) = [];
data.tanVel(find(data.RT==0)) = [];
data.Vel(find(data.RT==0)) = [];
data.Cr(find(data.RT==0)) = [];
data.iDir(find(data.RT==0)) = [];
data.init(find(data.RT==0)) = [];
data.ivel(find(data.RT==0)) = [];
data.RT(find(data.RT==0))=[];

% model fit
[data.model, data.pr_fitted, data.phit_sliding] = fit_model(data.RT,data.response);

% max y velocity 
data.maxyVel = nanmean(maxyvel);



