% loads raw data from all subjects into a series of .mat data files (one
% per subject)
%
clear
clc

addpath ../functions

% shooting
subjnames = {'S01','S02','S03','S04','S05','S06','S07','S08','S09','S10','S11','S12',}; % add more subjects to this list
Nsubj = length(subjnames);
for subj = 1:Nsubj
    clear data
    disp(['Subj ',num2str(subj),'/',num2str(Nsubj),' : ',subjnames{subj}]);
    disp('    Loading Subject Data...');

    data.shooting{:,1} = loadSubjData(['../Data/Shooting/',subjnames{subj}],{'F1','F2','F3'});  % loadSubjData(Subjname, {blocknames}); 
    data.shooting{:,2} = loadSubjData(['../Data/Shooting/',subjnames{subj}],{'M1','M2','M3'}); 
    data.shooting{:,3} = loadSubjData(['../Data/Shooting/',subjnames{subj}],{'S1','S2','S3'}); 

    % process data (smooth etc, rotate, get RT, etc.)
    disp('    Processing Data...')
    data.shooting{:,1} = processData(data.shooting{:,1});
    data.shooting{:,2} = processData(data.shooting{:,2});
    data.shooting{:,3} = processData(data.shooting{:,3});
        
    % save data from this subject in a separate file
%     fname = fullfile(['ShootingData_S',num2str(subj)]);
%     save(fname,'data')
    
    for i = 1:3
        d_full{subj,i} = data.shooting{:,i};
    end
    
end

% p2p
subjnames = {'S01','S02','S03','S04','S05','S06','S07','S08','S09','S10','S11','S12','S13','S14','S15','S16','S17','S18','S19','S20'}; % add more subjects to this list
Nsubj = length(subjnames);
for subj = 1:Nsubj
    clear data
    disp(['Subj ',num2str(subj),'/',num2str(Nsubj),' : ',subjnames{subj}]);
    disp('    Loading Subject Data...');

    data.p2p{:,1} = loadSubjData(['../Data/P2P/',subjnames{subj}],{'B1','B2','B3'});  % loadSubjData(Subjname, {blocknames}); 
    
    % process data (smooth etc, rotate, get RT, etc.)
    disp('    Processing Data...')
    data.p2p{:,1} = processData(data.p2p{:,1});
        
    % save data from this subject in a separate file
%     fname = fullfile(['P2PData_S',num2str(subj)]);
%     save(fname,'data')
    
    d_full{subj,4} = data.p2p{:,1};
end

d = compactify_data(d_full);
dAll = groupAnalysis(d);

save TimedResponseData d_full
save TimedResponse_compact d
save TimedResponse_dAll dAll

disp('All Done')