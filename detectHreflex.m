function [AmplitudeHwave,AmplitudeMwave,AmplitudeBaseline,x1,i,destPath] =...
    detectHreflex(Length,Data,V_Value,destPath,filename)


calculate = @Calculation;
AmplitudeHwave= zeros(1,1);
AmplitudeMwave = zeros(1,1);
AmplitudeBaseline = zeros(1,1);

i = 1; % initial for plotwnf
N = 1000; % number of frames
z = zeros(N, 1);
y = zeros(N, 1);
EMG(:,i) = zeros(N,1);
Trig(:,i) = zeros(N,1);
tr = zeros(N, 1);
x1 = zeros(1,i);

u = figure ('Name','HReflex');
plotAmplitudeH = plot(x1,AmplitudeHwave,'Color', 'green', 'Marker', 'o');
set(plotAmplitudeH, 'XDataSource','x1*10');
set(plotAmplitudeH, 'YDataSource','AmplitudeHwave');
title ('H-Reflex Recruitment Curve RAW');
xlabel('Stimulus Intensity [mA]');
ylabel('EMG Amplitude [mV]');
hold on
plotAmplitudeM = plot(x1,AmplitudeMwave,'Marker', 'o');
set(plotAmplitudeM, 'XDataSource','x1*10');
set(plotAmplitudeM, 'YDataSource','AmplitudeMwave');
legend('H-Reflex','M-Wave','Location','northwest');

Counter = 1;
ts  = 1000;
for f = 1:Length
    
    drawnow;
    Counter = Counter + 1;
    ts = ts + 1;
    
    Output_GetDeviceOutputValue_TRIGGER = Data.Electric_Current_Trigger_Output(f,1);
    Output_GetDeviceOutputValue_Stimulus = Data.Electric_Current_Stimulus_Intensity(f,1);
    tr(1:N-1) = tr(2:N);
    tr(N,:) = Output_GetDeviceOutputValue_TRIGGER;
    y(1:N-1) = y(2:N);
    y(N, :) = Output_GetDeviceOutputValue_Stimulus;
    
    %% Trigger point for Detection
    if tr(N,:) >= 1.00 && tr(N-1,:) <= 1.00
        ts = 1;
        fprintf('DETECTED %d\n', Counter);
    end
    
    Output_GetDeviceOutputValue = V_Value(f,1);
    z(1:N-1) = z(2:N);
    z(N,:) = Output_GetDeviceOutputValue;
    
    if ts == 700  % Number of data captured
        
        EMG(:,i) = z;
        Trig(:,i) = y * 100;
        Stimulus = tr*10;
        try
        [AmplitudeHwave(1,i),AmplitudeMwave(1,i),AmplitudeBaseline(1,i),x1(1,i),i,destPath] = calculate(EMG(:,i),Trig(:,i), Stimulus,20,i,destPath,filename); %calculate = Function for Calculation of Amplitudes and windows
        catch
            fprintf("Please check the data %d of %s\n",Counter,filename)
        end
        %% Recruitment Curve Update
        
%         refreshdata(plotAmplitudeH);
%         refreshdata(plotAmplitudeM);
%         drawnow;
        
        i = i + 1;
        ts = 1000;
%         close p
    end
end

plotAmplitudeH;
plotAmplitudeM;

savefig(u, fullfile(destPath,filename), 'compact');
close;
