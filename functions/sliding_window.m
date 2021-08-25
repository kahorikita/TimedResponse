function f = sliding_window(x, y, xplot,w)
% computes sliding window
%
% f = sliding_window(x, y, xplot, w)
% x - x value of all datapoints
% y - y value of all datapoints
% xplot - x values to perform sliding window over
% w - window size

for i = 1:length(xplot)
    igood = x > xplot(i)-w/2 & x <= xplot(i) + w/2;
    f(i) = mean(y(igood));
end