%% m_Calculate_CoP
% in UKBB force plates 1 and 2 are used for the static measurement trial

% input: AnalogCh struct
% output: sturct containing COP parameters

% Rosa Visscher, 17.09.2021, Zurich
% HRX-study, SNF funded

clc; close all

%% Set-up
dataPath = uigetdir([], 'Select folder with c3d-files'); % User choose location of c3d
destPath = uigetdir([], 'Select folder to save mat-files'); % User defines location for mat-files to be saved
% btkPath = uigetdir([], 'Select folder with btk'); % User defines location biomechanical toolkit
addpath('P:\Projects\NCM_CP\read_only\Codes\Codes_Basics\btk'); %adds btk to path!
addpath('C:\Users\rosav\Desktop\HRX_UKBB\Calculate_COP\func_COP'); 
cd(dataPath); %Enter folder in which c3d file is saved - to be capable of loading it afterwards

%% Settings
h=0; % if a foam mat is on-top, please replace 0 by the hight of the foam mat
az0 = -22-2-h; %inlcudes linoleum on top of force plate (-2mm) and h -> thickness of the foamboard
cut=5;% first 5 seconds need to be cut off
cutend=5;% last 5 seconds need to be cut off
Fig=1;%when 1 key outcomes are plotted and saved in png format

%% Get outcomes 
files = dir('*.c3d');
for i = 1:4%length(files)
    %% Load data
    c3dfiletoLoad = files(i).name;
    acq = btkReadAcquisition(c3dfiletoLoad); % load c3d file
    
    AnalogCh = btkGetAnalogs(acq); % get analog measured from c3d (EMG & stimulus variables)
    AnalogCh.ratio = btkGetAnalogSampleNumberPerFrame(acq);
    AnalogCh.analsampfreq = btkGetAnalogFrequency(acq);
    AnalogCh.analchannelNo = btkGetAnalogNumber(acq);
    AnalogCh.analogsVals = btkGetAnalogsValues(acq);
    AnalogCh.analRes = btkGetAnalogResolution(acq);
    AnalogCh.analFirstFrameId = btkGetFirstFrame(acq);
    AnalogCh.analLastFrameId = btkGetLastFrame(acq);
    
    %% Select params of interest
    % identify forces and moments needed to calculate CoP
    % all were calculated according to: http://isbweb.org/software/movanal/vaughan/kistler.pdf
    
    % Data Force Plate 1
    P.fx_1=AnalogCh.Force_Fx1; P.fy_1=AnalogCh.Force_Fy1; P.fz_1=AnalogCh.Force_Fz1;% Forces
    P.mx_1 = AnalogCh.Moment_Mx1; P.my_1 = AnalogCh.Moment_My1; % Moments
    P.mxtop_1 = P.mx_1+P.fy_1*az0; P.mytop_1 = P.my_1-P.fx_1*az0; % correct for hight force plate
    % Data Force Plate 2
    P.fx_2=AnalogCh.Force_Fx2; P.fy_2=AnalogCh.Force_Fy2; P.fz_2=AnalogCh.Force_Fz2;% Forces
    P.mx_2 = AnalogCh.Moment_Mx2; P.my_2 = AnalogCh.Moment_My2;% Moments
    P.mxtop_2 = P.mx_2+P.fy_2*az0; P.mytop_2 = P.my_2-P.fx_2*az0;% correct for hight force plate
    
    % Global
    % -------------INFO force plate needed---------------------
    % Fx = fx_1+fx_2; Fy = fy_1+fy_2; Fz = fz_1+fz_2;
    % daxi and dayi: Offset of center of each plate relative to global coordinate system
    % axi and ayi: Center of pressure coordinates of each plate
    % Mx = (day1+ay1)*fz_1 + (day2+ay2)*fz_2
    % My = -(dax1+ax1)*fz_1 - (dax2+ax2)*fz_2
    % Mxtop = Mx + az01*fy_1 + az02*fy_2;
    % Mytop = My - az01*fx_1 - az02*fx_2;
    
    %% Calculate CoP
    % Force Plate 1
    P.copx_1 = -P.mytop_1./P.fz_1;
    P.copy_1 = P.mxtop_1./P.fz_1;
    % Force Plate 2
    P.copx_2 = -P.mytop_2./P.fz_2;
    P.copy_2 = P.mxtop_2./P.fz_2;
    
    %% filter, crop and detrend data
    SF = AnalogCh.analsampfreq;
    cropBegin = cut*SF; %frames to be croped from start
    name = char(files(i,1).name(1:end-4));
    cropEnd= length(P.fx_1)-((cutend)*SF);%frames to be croped at end
    
    dataType=fieldnames(P);
    % for-loop to filder, crop, and detrend all params within p
    for j = 1:length(dataType)
        PROC.([dataType{j},'_raw'])=...
            P.(dataType{j});
        PROC.([dataType{j},'_filt'])= ...
            filterdata(P.(dataType{j}),SF);
        PROC.([dataType{j},'_crop'])= ...
            PROC.([dataType{j},'_filt'])(1+cropBegin:cropEnd);
        PROC.([dataType{j},'_GO'])= ...
            PROC.([dataType{j},'_crop'])-(mean(PROC.([dataType{j},'_crop'])));
    end
    
    
    %% calcuate parameters COP
    % trial length, absolute& relative sway area, 95%CI elliptical area,
    % RMS distance, mean distance, mean velocity, peak velocity
    
    % length of each trial
    trialLength_1 = (length(PROC.copx_1_GO))/SF;%after cropping
    RESULTS.FP1.trialLength = trialLength_1;
    trialLength_2 = (length(PROC.copx_2_GO))/SF;%after cropping
    RESULTS.FP2.trialLength = trialLength_2;
    
    % absolute sway area (mm)
    RESULTS.FP1.swayArea_abs = swayarea...
        (PROC.copx_1_GO,PROC.copy_1_GO);
    RESULTS.FP2.swayArea_abs = swayarea...
        (PROC.copx_2_GO,PROC.copy_2_GO);
    
    % relative sway area normalised to time of trial (mm2/s)
    RESULTS.FP1.swayArea_rel = swayareaRel...
        (PROC.copx_1_GO,PROC.copy_1_GO,trialLength_1);
    RESULTS.FP2.swayArea_rel = swayareaRel...
        (PROC.copx_2_GO,PROC.copy_2_GO,trialLength_2);
    
    % 95% CI elliptical area (mm2)
    RESULTS.FP1.ellipseArea = ellipse...
        (PROC.copx_1_GO,PROC.copy_1_GO);
    RESULTS.FP2.ellipseArea = ellipse...
        (PROC.copx_2_GO,PROC.copy_2_GO);
    
    % RMS distance (mm)
    [RESULTS.FP1.rmsDist,...
        RESULTS.FP1.rmsDistx,...
        RESULTS.FP1.rmsDisty] = rmsdistance...
        (PROC.copx_1_GO,PROC.copy_1_GO);
    [RESULTS.FP2.rmsDist,...
        RESULTS.FP2.rmsDistx,...
        RESULTS.FP2.rmsDisty] = rmsdistance...
        (PROC.copx_2_GO,PROC.copy_2_GO);
    
    % mean distance (mm)
    [RESULTS.FP1.meanDist,...
        RESULTS.FP1.meanDistx,...
        RESULTS.FP1.meanDisty] = mdistance...
        (PROC.copx_1_GO,PROC.copy_1_GO);
    [RESULTS.FP2.meanDist,...
        RESULTS.FP2.meanDistx,...
        RESULTS.FP2.meanDisty] = mdistance...
        (PROC.copx_2_GO,PROC.copy_2_GO);
    
    % mean velocity (mm/s)
    [RESULTS.FP1.meanVel,...
        RESULTS.FP1.meanVelx,...
        RESULTS.FP1.meanVely] = meanvelocity...
        (PROC.copx_1_GO,PROC.copy_1_GO,trialLength_1);
    [RESULTS.FP2.meanVel,...
        RESULTS.FP2.meanVelx,...
        RESULTS.FP2.meanVely] = meanvelocity...
        (PROC.copx_2_GO,PROC.copy_2_GO,trialLength_2);
    
    % peak velocity (mm/s)
    [RESULTS.FP1.peakVel,...
        RESULTS.FP1.peakVelx,...
        RESULTS.FP1.peakVely] = peakvelocity...
        (PROC.copx_1_GO,PROC.copy_1_GO,SF);
    [RESULTS.FP2.peakVel,...
        RESULTS.FP2.peakVelx,...
        RESULTS.FP2.peakVely] = peakvelocity...
        (PROC.copx_2_GO,PROC.copy_2_GO,SF);
    
    %save raw force, moments, and COP outcomes
    RESULTS.raw=PROC;
    
    MPF_x = meanfreq(PROC.copx_1_GO);
    
    %% plot outcomes
    if Fig==1
       fig_COP=figure;
       % plot FP 1
       subplot(1,2,1);
       hold on
       temp_1=files(i).name(1:end-4);
       temp_1 = regexprep(temp_1, '_', ' ');
       title(['CoP path FP1:',temp_1])
       plot(RESULTS.raw.copx_1_GO,RESULTS.raw.copy_1_GO,'r')
       dim = [.15 .07 .3 .3];
       str = {['Trial length (s):',num2str(RESULTS.FP1.trialLength)],...
           [' Distance AP (mm2):',num2str(RESULTS.FP1.meanDisty)],...
           [' Distance ML (mm2):',num2str(RESULTS.FP1.meanDistx)],...
           [' Ellipse area (mm2):',num2str(RESULTS.FP1.ellipseArea)],...
           [' Mean velocity AP (mm/s):',num2str(RESULTS.FP1.meanVely)],...
           [' Mean velocity ML (mm/s):',num2str(RESULTS.FP1.meanVelx)],...
           [' Peak velocity (mm/s):',num2str(RESULTS.FP1.peakVel)]};
              annotation('textbox',dim,'String',str,'FitBoxToText','on');
       hold off
       % plot FP 2
       subplot(1,2,2);
       hold on
       title(['CoP path FP2:',temp_1])
       plot(RESULTS.raw.copx_2_GO,RESULTS.raw.copy_2_GO,'b')
        dim = [.59 .07 .2 .3];
       str = {['Trial length (s):',num2str(RESULTS.FP2.trialLength)],...
           [' Distance AP (mm2):',num2str(RESULTS.FP2.meanDisty)],...
           [' Distance ML (mm2):',num2str(RESULTS.FP2.meanDistx)],...
           [' Ellipse area (mm2):',num2str(RESULTS.FP2.ellipseArea)],...
           [' Mean velocity AP (mm/s):',num2str(RESULTS.FP2.meanVely)],...
           [' Mean velocity ML (mm/s):',num2str(RESULTS.FP2.meanVelx)],...
           [' Peak velocity (mm/s):',num2str(RESULTS.FP2.peakVel)]};
              annotation('textbox',dim,'String',str,'FitBoxToText','on');
       hold off
%        tmpfigtoname = ['FIG_',files(i).name(1:end-4),'.png'];
%        tmpfigtosave = fullfile(destPath, tmpfigtoname);
%        saveas(fig_COP,tmpfigtosave)
%        close Figure 1 
    end%if-loop plot figures
    
    %% save mat-files
    tmpfiletoname = [files(i).name(1:end-4),'.mat'];
    tmpresulttoname = ['RESULTS_',files(i).name(1:end-4),'.mat'];
    tmpfiletosave = fullfile(destPath, tmpfiletoname);
    tmpresulttosave = fullfile(destPath, tmpresulttoname);
    save(tmpfiletosave,'AnalogCh');
    save(tmpresulttosave,'RESULTS');
    
    VR_COP.(files(i).name(1:5)).(files(i).name(6:end-4))=RESULTS;
    
    clear AnalogCh P PROC RESULTS trialLength_1 trialLength_2 tmpfiletoname tmpresulttoname tmpfiletosave tmpresulttosave
end%for-loop analyse each c3d file
