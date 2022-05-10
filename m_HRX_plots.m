%% m_HRX_UKBB_plots %%

%% setup
Soleus_n = 'EMG13_v';   
fs=AnalogCh.analsampfreq;% at ukbb normally 1500Hz 
Stimulation = AnalogCh.Electric_Current_Stimulus_Output;% shows when stimulator was used
Soleus = AnalogCh.(Soleus_n);%channel 1 is most frequently the soleus, if not, ADAPT!

%% Plot EMG H-reflex all trials
Condition = 'with VR at 0m & 10m';
[~,nr_peaks]=findpeaks(Stimulation,'MinPeakProminence',1);
Trigger_length = length(nr_peaks); % get length stimulus output
        
        % Preallocating Spaces
        ts  = 200;% time cut after the stimation due to delay EMG
        Delay_P1 = 8;%amount of frames until you expected first peak
        Delay_P2 = 30;%amount of frames until you expect second peak
        Delay_P3 = 65; %amount of frames until you expect third peak
        
%         h = figure;
%         hold on
        for f = 1:Trigger_length
            
            TRIGGER_Time = nr_peaks(f,1);
            Output_EMG = Soleus(TRIGGER_Time:(TRIGGER_Time+ts),1);
            
            time=(1:length(Output_EMG))';
            time=time./(fs);
            time=time.*(1000);%convert from seconds to ms, easier to interpret
            
            
            plot(time,Output_EMG,'g')
            Output.VR_10m(:,f)= Output_EMG;        
            title(Condition)

        end%for each stimulation

        %% enter mean curves into plot
         Output.means_10m =  mean(Output.VR_10m')';
         Output.means_0m =  mean(Output.VR_0m')';
         
         plot(time,Output.means_0m,'--k','LineWidth',2)
         plot(time,Output.means_10m,'g','LineWidth',2)
         
         xlabel('Time (ms)')
         ylabel('EMG Soleus (mV)')
         
         %% to restart
         clear Output
        