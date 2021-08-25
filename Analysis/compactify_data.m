function dAll = compactify_data(d)
% generates a more compact data structure
% [fast med slow p2p] x subject

for cnd = 1:4
    if cnd == 4
        numofsubj = 20;
    else
        numofsubj = 12;
    end
    for subj = 1:numofsubj
        dAll{subj,cnd}.response = d{subj,cnd}.response;
        dAll{subj,cnd}.RT = d{subj,cnd}.RT;
        dAll{subj,cnd}.ivel = d{subj,cnd}.ivel;
        dAll{subj,cnd}.Vel = d{subj,cnd}.Vel;
        dAll{subj,cnd}.maxyVel = d{subj,cnd}.maxyVel;
        dAll{subj,cnd}.initDir = d{subj,cnd}.initDir;
        dAll{subj,cnd}.model = d{subj,cnd}.model;
        dAll{subj,cnd}.phit_sliding = d{subj,cnd}.phit_sliding;
        dAll{subj,cnd}.pr_fitted = d{subj,cnd}.pr_fitted;
    end
end



