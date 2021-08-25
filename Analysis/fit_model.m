function [model, pr_fitted, sliding] = fit_model(RT,response)

% Initial values of parameters
sigma = .1; % slope .1
mu = .4; % middle of slope .4
AE = .95; % asymptotic error [upper, lower];
alpha = 0.2; % 0.1, regularization parameter % 500, 1000 %%%%%%% changed from original code from Adrian = 5
slope0 = 0.0002; % 0.0001, slope prior %%%%%%% changed from original code from Adrian = .05

% parameters for visualization
xplot = [.001:.001:1.2]; % x values to compute the sliding window over
w = 0.05; % 0.03, 0.075

RT = (RT-100)/1000; % msec-->sec
hit = response;
hit(hit~=1) = 0; % error->0

pInit = [mu sigma AE];
    
%- log-likelihood of all data
phit = @(params,t) 1/8 + (params(3) - 1/8)*normcdf(t,params(1),params(2)); %%%%%%%%%%%%% 4 = num of targets
% LL = @(params) -sum(hit.*log(phit(params,RT)) + (1-hit).*log(1-phit(params,RT))) + alpha*abs(params(2)); % delete slope
LL = @(params) -sum(hit.*log(phit(params,RT)) + (1-hit).*log(1-phit(params,RT))) + alpha*(params(2)-slope0)^2;
LL([mu sigma AE]);

pOpt = [mu sigma AE];
pOpt = fmincon(LL,pInit,[],[],[],[],[0 0.001 0.5],[100 100 1]); % try to find the optimum

LL(pOpt);

pr_original = phit(pOpt,xplot);
pr = phit(pOpt,RT); % correct response
pr(2,:) = 1 - pr(1,:); % add error response
model = pOpt;
pr_fitted = pr_original;

hit(hit==0) = 2;
for i = 1:2 % 1:hit, 2:not hit
    sw(i,:) = sliding_window(RT,hit==i,xplot,w);
end
sliding = sw;
                     