function [dataf] = filterdata(data, samprate)
%% Filter
% LP @ 13 instead of 30Hz

wn = 13/(samprate*0.5);

[b, a] = butter(4, wn);

dataf = filtfilt(b, a, data);
