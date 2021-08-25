% make one matrix which includes velocity profile/speed-accuracy trade off
% of all subjects (only correct trials)
function dAll = groupAnalysis(d)

% load TimedResponse_compact
for cnd = 1:4
    
    if cnd == 4
        numofsub = 20;
    else
        numofsub = 12;
    end
    
    yvelstock = NaN*ones(300*20,100);
    RTstock = [];
    responsestock = [];
    swstock = [];
    maxyvelstock = [];
    optstock = [];
    trcount = 1;
    for subj = 1:numofsub
        
        for tr = 1:length(d{subj,cnd}.ivel)
            if d{subj,cnd}.response(1,tr) == 1 % select correct trials
                
                % for group mean velocity profile (movement onset- )
                yvel = d{subj,cnd}.Vel{tr}(d{subj,cnd}.ivel(tr):end,2)';
                yvelstock(trcount,1:length(yvel)) = yvel;
                           
                % phit sliding for group mean pr
                swstock = [swstock; d{subj,cnd}.phit_sliding(1,:)];
                
                trcount = trcount + 1;
            end
        end
        
        % model fitting for group data
        RTstock = [RTstock d{subj,cnd}.RT];
        responsestock = [responsestock d{subj,cnd}.response];
        
        % max y vel
        maxyvelstock = [maxyvelstock d{subj,cnd}.maxyVel];
        
        % optimized parameters
        optstock = [optstock d{subj,cnd}.model(1)];
        
    end
    
    for tr = 1:length(yvelstock)
        if isnan(yvelstock(tr,1))
            I = tr;
            break;
        end
    end
    yvelstock(I:end,:)=[];
    
    [dsorted,I] = sort(responsestock);
    responsestock = dsorted;
    RTstock = RTstock(I);
    
    dAll{cnd}.Vel = yvelstock;
    dAll{cnd}.RT = RTstock;
    dAll{cnd}.response = responsestock;
    dAll{cnd}.phit_sliding = swstock;
    dAll{cnd}.maxyVel = maxyvelstock;    
    dAll{cnd}.model = optstock;
    
end
