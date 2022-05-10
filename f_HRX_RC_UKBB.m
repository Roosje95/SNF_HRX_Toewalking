function [RecruitmentSummary] = f_HRX_RC_UKBB(Stimulus_length,Trigger,EMG_soleus_HRX,Trig,destPath)
% To calculate recruitment curve during standing 
% Developed for UKBB, based on codes from Yong Kuk Kim NCM HRX walking Study

% R Visscher Nov 2021

%% Preallocating Spaces
i = 1; % initial for plot
N = 8000; % number of frames, RV changed from 1000 to 8000
z = zeros(N, 1);
y = zeros(N, 1);
EMG(:,i) = zeros(N,1);
% Trig(:,i) = zeros(N,1);
tr = zeros(N, 1);
x1 = zeros(1,1);
h = figure;
calculate = @f_Calculation;
linefit = @Linefit;
AmplitudeHwave= zeros(1,1);
AmplitudeMwave = zeros(1,1);
AmplitudeBaseline = zeros(1,1);

%% Recruiment Curve Plot
% basic settings
u = figure ('Name','HReflex');
plotAmplitudeH = plot(x1,AmplitudeHwave,'Color', 'green', 'Marker', 'o');
set(plotAmplitudeH, 'XDataSource','x1');% RV adapted, removed *10
set(plotAmplitudeH, 'YDataSource','AmplitudeHwave');
title ('H-Reflex Recruitment Curve RAW');
xlabel('Stimulus Intensity [mA]');
ylabel('EMG Amplitude [mV]');
hold on
plotAmplitudeM = plot(x1,AmplitudeMwave,'Marker', 'o');
set(plotAmplitudeM, 'XDataSource','x1');% RV adapted, removed *10
set(plotAmplitudeM, 'YDataSource','AmplitudeMwave');
legend('H-Reflex','M-Wave','Location','northwest');

Counter = 1;
ts  = 8000; % RV changed from 1000 to 8000
for f = 1:Stimulus_length
    
    drawnow;
    Counter = Counter + 1;
    ts = ts + 1;
    
    Output_GetDeviceOutputValue_TRIGGER = Trigger(f,1);
    %     Output_GetDeviceOutputValue_Stimulus = matfiletoLoad.AnalogCh.Electric_Current_Stimulus_Intensity(f,1);
    tr(1:N-1) = tr(2:N);
    tr(N,:) = Output_GetDeviceOutputValue_TRIGGER;
    %     y(1:N-1) = y(2:N);
    %     y(N, :) = Output_GetDeviceOutputValue_Stimulus;
    
    %% Trigger point
    if tr(N,:) >= 1.00 && tr(N-1,:) <= 1.00
        % Get the device output value
        ts = 1;
        fprintf('DETECTED %d\n', Counter);
    end
    
    % Number of EMG channel to be determined
    Output_GetDeviceOutputValue = EMG_soleus_HRX(f,1);
    z(1:N-1) = z(2:N);
    z(N,:) = Output_GetDeviceOutputValue;
    
    if ts == 150  % Number of data captured
        set(h,'Visible','off');
        EMG(:,i) = z;
        %         Trig(:,i) = y * 100;
        Stimulus = tr*10;
        [AmplitudeHwave(1,i),AmplitudeMwave(1,i),AmplitudeBaseline(1,i),x1(1,i),h,i,destPath] = calculate(EMG(:,i),Trig(:,i), Stimulus,20,i,destPath); %calculate = Function for Calculation of Amplitudes and windows
        
        %% Recruitment Curve
        refreshdata(plotAmplitudeH);
        refreshdata(plotAmplitudeM);
        drawnow;
        i = i + 1;
        ts = 8000;
    end
end

dispname = sprintf('Fitted curve(Raw)');
savefig(u, fullfile(destPath, dispname), 'compact');
% x1 = x1*10;
[HMALL] = Linefit(AmplitudeHwave,AmplitudeMwave,AmplitudeBaseline,Trig,destPath,filename); %RV Replaced x1 by Trig


%% Creating Structure
RecruitmentSummary.HReflex = AmplitudeHwave';
RecruitmentSummary.Mwave = AmplitudeMwave';
RecruitmentSummary.Stimulus = x1';
RecruitmentSummary.BEMG = AmplitudeBaseline';
RecruitmentSummary.HMALL = HMALL;
RawValues.EMG  = matfiletoLoad.AnalogCh.Voltage_1;
RawValues.Stimulus = matfiletoLoad.AnalogCh.Electric_Current_Stimulus_Intensity;
end