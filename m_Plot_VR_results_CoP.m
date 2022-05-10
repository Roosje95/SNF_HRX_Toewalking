%% m_Plot_VR_CoP
% to plot outcomes of affected and unaffected leg for participants VR study
% funded by SNF
% Involved: Rebecca Winter, Regine Lossh (UKBB/DBE), Elke Viehweger(UKBB)

% required_VR_Results struct, resulted from running first m_Calculate_CoP_TwoForcePlates.m and
% m_Order_VR_results_CoP

% Oct 2021, Rosa Visscher

%% Foot length in mm
% load Tpose file

dataPath = uigetdir([], 'Select folder with c3d-files'); % User choose location of c3d
addpath('P:\Projects\NCM_CP\read_only\Codes\Codes_Basics\btk'); %adds btk to path!
addpath('C:\Users\rosav\Desktop\HRX_UKBB\Calculate_COP\func_COP'); 
cd(dataPath); %Enter folder in which c3d file is saved - to be capable of loading it afterwards

files = dir('*.c3d');

 c3dfiletoLoad = files(end).name;
 acq = btkReadAcquisition(c3dfiletoLoad); % load c3d file
 Markers = btkGetMarkers(acq);% read out marker locations
 
 % Use marker locations to estimate length of foot (between toe and heel
 % marker
Foot_L = sqrt((Markers.LHEE(10,1) - Markers.LTOE(10,1))^2 + (Markers.LHEE(10,2) - Markers.LTOE(10,2))^2);
Foot_R = sqrt((Markers.RHEE(10,1) - Markers.RTOE(10,1))^2 + (Markers.RHEE(10,2) - Markers.RTOE(10,2))^2);

Ankle_L = sqrt((Markers.RMMA(10,1) - Markers.RANK(10,1))^2 + (Markers.RMMA(10,2) - Markers.RANK(10,2))^2);
Ankle_R = sqrt((Markers.LMMA(10,1) - Markers.LANK(10,1))^2 + (Markers.LMMA(10,2) - Markers.RMMA(10,2))^2);

Diff_Foot = abs(Foot_L-Foot_R);
if Diff_Foot>10
    disp('!!Feet different Length!!')
end

Foot = (Foot_L+Foot_R)/2;
Ankle = (Ankle_L+Ankle_R)/2;
Lim_FootLength = Foot/2+5;
Lim_Footwidth = Ankle/2+2;
 
%% Settings
% Load VR_Results struct

Fig = figure;

% VR0001   
subplot(1,2,1);
hold on
title('CoP path Aff VR001')
ylabel('Displacement AP (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR001.a04st_stab1_mit_0m.raw.copx_1_GO,VR_Results.VR001.a04st_stab1_mit_0m.raw.copy_1_GO,'--r')
plot(VR_Results.VR001.a02st_stab1_mit_10m.raw.copx_1_GO,VR_Results.VR001.a02st_stab1_mit_10m.raw.copy_1_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_L/2),'k'); yline((Foot_L/2),'k') 
xline(-(Ankle_L/2),'k'); xline((Ankle_L/2),'k') 
hold off
subplot(1,2,2);
hold on
title('CoP path Unaff VR001')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR001.a04st_stab1_mit_0m.raw.copx_2_GO,VR_Results.VR001.a04st_stab1_mit_0m.raw.copy_2_GO,'--r')
plot(VR_Results.VR001.a02st_stab1_mit_10m.raw.copx_2_GO,VR_Results.VR001.a02st_stab1_mit_10m.raw.copy_2_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_R/2),'k'); yline((Foot_R/2),'k') 
xline(-(Ankle_R/2),'k'); xline((Ankle_R/2),'k') 

% VR0002   
subplot(1,2,1);
hold on
title('CoP path Unaff VR002')
ylabel('Displacement AP (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR002.a02st_stab1_mit_0m.raw.copx_1_GO,VR_Results.VR002.a02st_stab1_mit_0m.raw.copy_1_GO,'--r')
plot(VR_Results.VR002.a04st_stab1_mit_10m.raw.copx_1_GO,VR_Results.VR002.a04st_stab1_mit_10m.raw.copy_1_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_L/2),'k'); yline((Foot_L/2),'k') 
xline(-(Ankle_L/2),'k'); xline((Ankle_L/2),'k') 
hold off
subplot(1,2,2);
hold on
title('CoP path Aff VR002')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR002.a02st_stab1_mit_0m.raw.copx_2_GO,VR_Results.VR002.a02st_stab1_mit_0m.raw.copy_2_GO,'--r')
plot(VR_Results.VR002.a04st_stab1_mit_10m.raw.copx_2_GO,VR_Results.VR002.a04st_stab1_mit_10m.raw.copy_2_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_R/2),'k'); yline((Foot_R/2),'k') 
xline(-(Ankle_R/2),'k'); xline((Ankle_R/2),'k') 

% VR0003   
subplot(1,2,1);
hold on
title('CoP path Unaff VR003')
ylabel('Displacement AP (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR003.a03st_stab1_mit_0m.raw.copx_1_GO,VR_Results.VR003.a03st_stab1_mit_0m.raw.copy_1_GO,'--r')
plot(VR_Results.VR003.a05st_stab1_mit_10m.raw.copx_1_GO,VR_Results.VR003.a05st_stab1_mit_10m.raw.copy_1_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_L/2),'k'); yline((Foot_L/2),'k') 
xline(-(Ankle_L/2),'k'); xline((Ankle_L/2),'k') 
hold off
subplot(1,2,2);
hold on
title('CoP path Aff VR003')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR003.a03st_stab1_mit_0m.raw.copx_2_GO,VR_Results.VR003.a03st_stab1_mit_0m.raw.copy_2_GO,'--r')
plot(VR_Results.VR003.a05st_stab1_mit_10m.raw.copx_2_GO,VR_Results.VR003.a05st_stab1_mit_10m.raw.copy_2_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_R/2),'k'); yline((Foot_R/2),'k') 
xline(-(Ankle_R/2),'k'); xline((Ankle_R/2),'k') 
hold off

% VR0004   
subplot(1,2,1);
hold on
title('CoP path Aff VR004')
ylabel('Displacement AP (mm)')
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR004.a05st_stab1_mit_0m.raw.copx_1_GO,VR_Results.VR004.a05st_stab1_mit_0m.raw.copy_1_GO,'--r')
plot(VR_Results.VR004.a03st_stab1_mit_10m.raw.copx_1_GO,VR_Results.VR004.a03st_stab1_mit_10m.raw.copy_1_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_L/2),'k'); yline((Foot_L/2),'k') 
xline(-(Ankle_L/2),'k'); xline((Ankle_L/2),'k') 
hold off
subplot(1,2,2);
hold on
title('CoP path Unaff VR004')
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR004.a05st_stab1_mit_0m.raw.copx_2_GO,VR_Results.VR004.a05st_stab1_mit_0m.raw.copy_2_GO,'--r')
plot(VR_Results.VR004.a03st_stab1_mit_10m.raw.copx_2_GO,VR_Results.VR004.a03st_stab1_mit_10m.raw.copy_2_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_R/2),'k'); yline((Foot_R/2),'k') 
xline(-(Ankle_R/2),'k'); xline((Ankle_R/2),'k') 
hold off

% VR0005   
subplot(1,2,1);
hold on
title('CoP path Aff VR005')
ylabel('Displacement AP (mm)')
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR005.a05_mit1_0m.raw.copx_1_GO,VR_Results.VR005.a05_mit1_0m.raw.copy_1_GO,'--r')
plot(VR_Results.VR005.a03_mit1_10m.raw.copx_1_GO,VR_Results.VR005.a03_mit1_10m.raw.copy_1_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_L/2),'k'); yline((Foot_L/2),'k') 
xline(-(Ankle_L/2),'k'); xline((Ankle_L/2),'k') 
hold off
subplot(1,2,2);
hold on
title('CoP path Unaff VR005')
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR005.a05_mit1_0m.raw.copx_2_GO,VR_Results.VR005.a05_mit1_0m.raw.copy_2_GO,'--r')
plot(VR_Results.VR005.a03_mit1_10m.raw.copx_2_GO,VR_Results.VR005.a03_mit1_10m.raw.copy_2_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_R/2),'k'); yline((Foot_R/2),'k') 
xline(-(Ankle_R/2),'k'); xline((Ankle_R/2),'k') 
legend('0m','10m')
hold off

%% TD plots
% VR0006  
subplot(1,2,1);
hold on
title('CoP path VR006')
ylabel('Displacement AP (mm)')
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR006.c02_mit1_0m.raw.copx_1_GO,VR_Results.VR006.c02_mit1_0m.raw.copy_1_GO,'--r')
plot(VR_Results.VR006.c04_mit1_10m.raw.copx_1_GO,VR_Results.VR006.c04_mit1_10m.raw.copy_1_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_L/2),'k'); yline((Foot_L/2),'k') 
xline(-(Ankle_L/2),'k'); xline((Ankle_L/2),'k') 
hold off
subplot(1,2,2);
hold on
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR006.c02_mit1_0m.raw.copx_2_GO,VR_Results.VR006.c02_mit1_0m.raw.copy_2_GO,'--r')
plot(VR_Results.VR006.c04_mit1_10m.raw.copx_2_GO,VR_Results.VR006.c04_mit1_10m.raw.copy_2_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_R/2),'k'); yline((Foot_R/2),'k') 
xline(-(Ankle_R/2),'k'); xline((Ankle_R/2),'k') 

% VR0007  
subplot(1,2,1);
hold on
title('VR007')
ylabel('Displacement AP (mm)')
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR007.b03_mit1_0m.raw.copx_1_GO,VR_Results.VR007.b03_mit1_0m.raw.copy_1_GO,'--k')
plot(VR_Results.VR007.b05_mit1_10m.raw.copx_1_GO,VR_Results.VR007.b05_mit1_10m.raw.copy_1_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_L/2),'k'); yline((Foot_L/2),'k') 
xline(-(Ankle_L/2),'k'); xline((Ankle_L/2),'k') 
hold off
subplot(1,2,2);
hold on
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR007.b03_mit1_0m.raw.copx_2_GO,VR_Results.VR007.b03_mit1_0m.raw.copy_2_GO,'--k')
plot(VR_Results.VR007.b05_mit1_10m.raw.copx_2_GO,VR_Results.VR007.b05_mit1_10m.raw.copy_2_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_R/2),'k'); yline((Foot_R/2),'k') 
xline(-(Ankle_R/2),'k'); xline((Ankle_R/2),'k') 

% VR008 
subplot(1,2,1);
hold on
title('VR008')
ylabel('Displacement AP (mm)')
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR008.c02_mit1_0m.raw.copx_1_GO,VR_Results.VR008.c02_mit1_0m.raw.copy_1_GO,'--k')
plot(VR_Results.VR008.c04_mit1_10m.raw.copx_1_GO,VR_Results.VR008.c04_mit1_10m.raw.copy_1_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_L/2),'k'); yline((Foot_L/2),'k') 
xline(-(Ankle_L/2),'k'); xline((Ankle_L/2),'k') 
hold off
subplot(1,2,2);
hold on
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR008.c02_mit1_0m.raw.copx_2_GO,VR_Results.VR008.c02_mit1_0m.raw.copy_2_GO,'--k')
plot(VR_Results.VR008.c04_mit1_10m.raw.copx_2_GO,VR_Results.VR008.c04_mit1_10m.raw.copy_2_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_R/2),'k'); yline((Foot_R/2),'k') 
xline(-(Ankle_R/2),'k'); xline((Ankle_R/2),'k') 

% VR009
subplot(1,2,1);
hold on
title('VR009')
ylabel('Displacement AP (mm)')
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR009.c04_mit1_0m.raw.copx_1_GO,VR_Results.VR009.c04_mit1_0m.raw.copy_1_GO,'--k')
plot(VR_Results.VR009.c02_mit1_10m.raw.copx_1_GO,VR_Results.VR009.c02_mit1_10m.raw.copy_1_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_L/2),'k'); yline((Foot_L/2),'k') 
xline(-(Ankle_L/2),'k'); xline((Ankle_L/2),'k') 
hold off
subplot(1,2,2);
hold on
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR009.c04_mit1_0m.raw.copx_2_GO,VR_Results.VR009.c04_mit1_0m.raw.copy_2_GO,'--k')
plot(VR_Results.VR009.c02_mit1_10m.raw.copx_2_GO,VR_Results.VR009.c02_mit1_10m.raw.copy_2_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_R/2),'k'); yline((Foot_R/2),'k') 
xline(-(Ankle_R/2),'k'); xline((Ankle_R/2),'k') 

% VR010
subplot(1,2,1);
hold on
title('VR010')
ylabel('Displacement AP (mm)')
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR010.c02_mit1_0m.raw.copx_1_GO,VR_Results.VR010.c02_mit1_0m.raw.copy_1_GO,'--k')
plot(VR_Results.VR010.c04_mit1_10m.raw.copx_1_GO,VR_Results.VR010.c04_mit1_10m.raw.copy_1_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_L/2),'k'); yline((Foot_L/2),'k') 
xline(-(Ankle_L/2),'k'); xline((Ankle_L/2),'k') 
hold off
subplot(1,2,2);
hold on
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR010.c02_mit1_0m.raw.copx_2_GO,VR_Results.VR010.c02_mit1_0m.raw.copy_2_GO,'--k')
plot(VR_Results.VR010.c04_mit1_10m.raw.copx_2_GO,VR_Results.VR010.c04_mit1_10m.raw.copy_2_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_R/2),'k'); yline((Foot_R/2),'k') 
xline(-(Ankle_R/2),'k'); xline((Ankle_R/2),'k') 

% VR011
subplot(1,2,1);
hold on
title('VR011')
ylabel('Displacement AP (mm)')
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR011.b03_mit1_0m.raw.copx_1_GO,VR_Results.VR011.b03_mit1_0m.raw.copy_1_GO,'--k')
plot(VR_Results.VR011.b07_mit2_10m.raw.copx_1_GO,VR_Results.VR011.b07_mit2_10m.raw.copy_1_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_L/2),'k'); yline((Foot_L/2),'k') 
xline(-(Ankle_L/2),'k'); xline((Ankle_L/2),'k') 
hold off
subplot(1,2,2);
hold on
xlabel('Displacement ML (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR011.b03_mit1_0m.raw.copx_2_GO,VR_Results.VR011.b03_mit1_0m.raw.copy_2_GO,'--k')
plot(VR_Results.VR011.b07_mit2_10m.raw.copx_2_GO,VR_Results.VR011.b07_mit2_10m.raw.copy_2_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_R/2),'k'); yline((Foot_R/2),'k') 
xline(-(Ankle_R/2),'k'); xline((Ankle_R/2),'k') 


% VR012  
subplot(1,2,1);
hold on

ylabel('Displacement AP (mm)')
xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR012.b02_mit1_0m.raw.copx_1_GO,VR_Results.VR012.b02_mit1_0m.raw.copy_1_GO,'--k')
plot(VR_Results.VR012.b04_mit1_10m.raw.copx_1_GO,VR_Results.VR012.b04_mit1_10m.raw.copy_1_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_L/2),'k'); yline((Foot_L/2),'k') 
xline(-(Ankle_L/2),'k'); xline((Ankle_L/2),'k') 
hold off
subplot(1,2,2);
hold on

xlim([-Lim_Footwidth Lim_Footwidth])
ylim([-Lim_FootLength Lim_FootLength])
plot(VR_Results.VR012.b02_mit1_0m.raw.copx_2_GO,VR_Results.VR012.b02_mit1_0m.raw.copy_2_GO,'--k')
plot(VR_Results.VR012.b04_mit1_10m.raw.copx_2_GO,VR_Results.VR012.b04_mit1_10m.raw.copy_2_GO,'b')
xline(0,'k'); yline(0,'k')
yline(-(Foot_R/2),'k'); yline((Foot_R/2),'k') 
xline(-(Ankle_R/2),'k'); xline((Ankle_R/2),'k') 