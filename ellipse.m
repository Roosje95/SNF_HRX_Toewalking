function COPea = ellipse(x,y)

for i = 1:length(x)    
   covariance(i) = (1/length(x))*(x(i)*y(i));
end


Sx = std(x);
Sy = std(y);
Sxy = sum(covariance);

% 95% confidence ellipse area
COPea = (2*pi)*3*(Sy^2*Sx^2-Sxy^2)^0.5; % 3 SDs for the F statistic 
                                        % as the sample size is large n>120
                                        % or the amount of data within the time series.
