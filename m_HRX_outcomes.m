%% m_Calculate_HRX
% calculate H/M ration during Balance assessment UKBB

% input: recruitment cruve, Balance trials with H-reflex and VR 0m and 10m
% output: sturct containing COP parameters

% Rosa Visscher, 15.11.2021, Zurich
% HRX-study, SNF funded

clc; clear vars; 

%% TO DEFINE
Soleus_n = 'EMG1_v';          % which channel is Soleus in which HRX was elicted
start_stim = 20; % start recruitment curve at 20mA
int_stim=2; % with how many mA you increase per step for the recruitment curve

%% Set-up
% dataPath = uigetdir([], 'Select folder with c3d-files'); % User choose location of c3d
% destPath = uigetdir([], 'Select folder to save mat-files'); % User defines location for mat-files to be saved
dataPath = 'P:\Projects\NCM_CP\project_only\NCM_CP_HRX\HRX_UKBB\Calculate_HRX\Data\TD\VR012'; % User choose location of c3d
destPath = 'P:\Projects\NCM_CP\project_only\NCM_CP_HRX\HRX_UKBB\Calculate_HRX\Outcomes\TD\VR012'; % User defines location for mat-files to be saved
addpath('P:\Projects\NCM_CP\read_only\Codes\Codes_Basics\btk'); %adds btk to path!
addpath('P:\Projects\NCM_CP\project_only\NCM_CP_HRX\HRX_UKBB\Calculate_HRX\Func_HRX_RecruitemntCurve'); %adds HRX functions written by Yong to path
addpath('P:\Projects\NCM_CP\project_only\NCM_CP_HRX\HRX_UKBB\Calculate_HRX');
cd(dataPath); %Enter folder in which c3d file is saved - to be capable of loading it afterwards

files = dir('*.c3d'); % searches for c3d files in directory

%% Calculate
for i_files = 2:length(files)
    c3dfiletoLoad = files(i_files).name;
    if contains(c3dfiletoLoad,'RC')
        %% Load data - RC
        acq = btkReadAcquisition(c3dfiletoLoad); % load c3d file
        
        AnalogCh = btkGetAnalogs(acq); % get analog measured from c3d (EMG & stimulus variables)
        AnalogCh.ratio = btkGetAnalogSampleNumberPerFrame(acq);
        AnalogCh.analsampfreq = btkGetAnalogFrequency(acq);
        AnalogCh.analchannelNo = btkGetAnalogNumber(acq);
        AnalogCh.analogsVals = btkGetAnalogsValues(acq);
        AnalogCh.analRes = btkGetAnalogResolution(acq);
        AnalogCh.analFirstFrameId = btkGetFirstFrame(acq);
        AnalogCh.analLastFrameId = btkGetLastFrame(acq);
        % save mat-files
        tmpfilenametosave = [files(i_files).name(1:end-4),'.mat'];
        tmpfiletosave = fullfile(destPath, tmpfilenametosave);
        save(tmpfiletosave,'AnalogCh');
        
        %% Select data of interest
        EMG_soleus_HRX = AnalogCh.(Soleus_n);% contains EMG soleus from teh leg at which teh recruitment curve was calculated
        Trigger = AnalogCh.Electric_Current_Stimulus_Output; % synch stimulator with EMG
        Stimulus_length = length(Trigger);
        [~,nr_peaks]=findpeaks(Trigger,'MinPeakProminence',0.2);
        
        Trigger_length = length(nr_peaks); % get length stimulus output
        Name = c3dfiletoLoad(1:(end-4)); % extract file name
        
        Stimulus       = zeros(Trigger_length,1);
        i_stimulus = start_stim;
        for i_count = 1:Trigger_length
            Stimulus(i_count,1)= i_stimulus;
            i_stimulus = i_stimulus+int_stim;
        end
        
        %% Calculate recruitment curve
        [RecruitmentSummary] = f_HRX_RC_UKBB(Stimulus_length,Trigger,EMG_soleus_HRX,Stimulus,destPath);
        
        clearvars -except files dataPath destPath Soleus_n start_stim int_stim i_files
    else
        %% Load data - Balance trial
%         acq = btkReadAcquisition(c3dfiletoLoad); % load c3d file
%         
%         AnalogCh = btkGetAnalogs(acq); % get analog measured from c3d (EMG & stimulus variables)
%         AnalogCh.ratio = btkGetAnalogSampleNumberPerFrame(acq);
%         AnalogCh.analsampfreq = btkGetAnalogFrequency(acq);
%         AnalogCh.analchannelNo = btkGetAnalogNumber(acq);
%         AnalogCh.analogsVals = btkGetAnalogsValues(acq);
%         AnalogCh.analRes = btkGetAnalogResolution(acq);
%         AnalogCh.analFirstFrameId = btkGetFirstFrame(acq);
%         AnalogCh.analLastFrameId = btkGetLastFrame(acq);
load(c3dfiletoLoad)
        
        %% Select data of interest
        Stimulation = AnalogCh.Electric_Current_Stimulus_Output;% shows when stimulator was used
        Soleus = AnalogCh.(Soleus_n);%channel 1 is most frequently the soleus, if not, ADAPT!
        Condition = c3dfiletoLoad(1:end-4);
        Condition = regexprep(Condition, '_', ' ');
        
        [~,nr_peaks]=findpeaks(Stimulation,'MinPeakProminence',1);
        Trigger_length = length(nr_peaks); % get length stimulus output
        
        % Preallocating Spaces
        ts  = 200;% time cut after the stimation
        Delay_P1 = 8;%amount of frames until you expected first peak
        Delay_P2 = 30;%amount of frames until you expect second peak
        Delay_P3 = 65; %amount of frames until you expect third peak
        
        for f = 1:Trigger_length
            
            TRIGGER_Time = nr_peaks(f,1);
            Output_EMG = Soleus(TRIGGER_Time:(TRIGGER_Time+ts),1);
            
            [Outcomes.P1.min, Loc.P1.min] = min(Output_EMG(1:Delay_P1));
            [Outcomes.P1.max, Loc.P1.max] = max(Output_EMG(1:Delay_P1));
            [Outcomes.P2.min, Loc.P2.min] = min(Output_EMG(Delay_P1:Delay_P2));
            [Outcomes.P2.max, Loc.P2.max] = max(Output_EMG(Delay_P1:Delay_P2));
            [Outcomes.P3.min, Loc.P3.min] = min(Output_EMG(Delay_P2:Delay_P3));
            [Outcomes.P3.max, Loc.P3.max] = max(Output_EMG(Delay_P2:Delay_P3));
            
            Outcomes.P1.diff = Outcomes.P1.max-Outcomes.P1.min;
            Outcomes.P2.diff = Outcomes.P2.max-Outcomes.P2.min;
            Outcomes.P3.diff = Outcomes.P3.max-Outcomes.P3.min;
            
            h = figure;
            plot(Output_EMG)
            hold on
            plot((Loc.P1.min),(Outcomes.P1.min), '*k')
            plot(Loc.P1.max,(Outcomes.P1.max), '*k')
            plot(Loc.P2.min+Delay_P1-1,(Outcomes.P2.min),'*b')
            plot(Loc.P2.max+Delay_P1-1,(Outcomes.P2.max), '*b')
            plot(Loc.P3.min+Delay_P2-1,(Outcomes.P3.min), '*r')
            plot(Loc.P3.max+Delay_P2-1,(Outcomes.P3.max),'*r')
            title(Condition)
            dim = [0.3 0.2 0.5 0.5];
            str = {['P1:' num2str(Loc.P1.max),'-', num2str(Outcomes.P1.diff)], ...
                ['P2:' num2str(Loc.P2.max+Delay_P1-1),'-',num2str(Outcomes.P2.diff)], ...
                ['!P3:' num2str(Loc.P3.max+Delay_P2-1),'-',num2str(Outcomes.P3.max)]};
            annotation('textbox',dim,'String',str,'FitBoxToText','on');
        end%for each stimulation
        clearvars -except files dataPath destPath Soleus_n start_stim int_stim i_files
        
    end%if-loop check RC or balance trial
end %for-loop load c3d files
