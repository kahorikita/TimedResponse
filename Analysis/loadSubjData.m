function [data] = loadSubjData(subjname,blocknames)
% load a single subject's timed response target jump data
% data = loadSubjData('Data/S01',{'B1','B2','B3','B4','B5'});

START_X = .6;
START_Y = .25;

Nblocks = length(blocknames);
trial = 1;
tFileFull = [];
for blk=1:Nblocks
    disp(['Subject ',subjname,', ','Block: ',blocknames(blk)]);
    path = [subjname,'/',blocknames{blk}];
    disp(path);
    tFile = dlmread([path,'/tFile.tgt'],' ',0,0);
    fnames = dir(path);
    Ntrials = size(tFile,1);
    if(strcmp(fnames(3).name,'.DS_Store'))
        istart = 3;
    else
        istart = 2;
    end
    
    for j=1:Ntrials

        d = dlmread([path,'/',fnames(j+istart).name],' ',6,0);

        L{trial} = d(:,1:2); % left hand X and Y
        R{trial} = d(:,3:4); % right hand X and Y
        C{trial} = d(:,5:6);% cursor X and Y

        % absolute target location
        targetAbs(trial,1) = tFile(j,2)+START_X;
        targetAbs(trial,2) = tFile(j,3)+START_Y;
        
        % determine relative target location
        start(trial,:) = [START_X START_Y];
        targetRel(trial,:) = targetAbs(trial,:)-start(trial,:);
   
        state{trial} = d(:,7); % trial 'state' at each time point
        time{trial} = d(:,9); % time during trial
        
        trial = trial+1;
        
    end
    
    tFileFull = [tFileFull; tFile(:,1:6)]; % copy of trial table
    
end

% compute target angle
data.targAng = atan2(targetRel(:,2),targetRel(:,1));
data.targAng = rad2deg(data.targAng');
data.targDist = sqrt(sum(targetRel(:,1:2)'.^2));

% store all info in data structure 'data'
data.L = L;
data.R = R;
data.C = C;

data.Ntrials = size(targetRel,1);
data.tFile = tFileFull;

data.state = state;
data.time = time;

data.subjname = subjname;
data.blocknames = blocknames;

% placeholders - these will be computed later
d0 = 0;
data.RT = d0;
data.response = d0;
data.initDir = d0;

data.targetAbs = targetAbs;
data.targetRel = targetRel;
data.start = start;

% rotate data into common coordinate frame - start at (0,0), target at
% (0,.12)
for j=1:data.Ntrials % iterate through all trials
    theta(j) = atan2(data.targetRel(j,2),data.targetRel(j,1))-pi/2;
    R = [cos(theta(j)) sin(theta(j)); -sin(theta(j)) cos(theta(j))];
    data.Cr{j} = (R*(data.C{j}'-repmat(start(j,:),size(data.C{j},1),1)'))';
end


