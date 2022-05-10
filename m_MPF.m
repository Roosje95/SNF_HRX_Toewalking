%% m_HRX_CoP_MPF %%
% Based on Carpenter et al. 2001 calculating SD of COP - AP direction and
% mean power frequency (MPF)

% March 2022, R. Visscher

%% set-up
SF=1500; % measurement at 1500 Hz
load('P:\Projects\NCM_CP\project_only\NCM_CP_HRX\HRX_UKBB\Calculate_COP\Outcomes\VRpilot_Results')

%% extract params of interest
participants = fieldnames(VR_Results);
for i=1:length(participants)
    trials=fieldnames(VR_Results.(participants{i}));
    for j=1:length(trials)
       side = fieldnames(VR_Results.(participants{i}).(trials{j}));

    VR_Results.(participants{i}).(trials{j}).FP1.MPF = meanfreq(VR_Results.(participants{i}).(trials{j}).raw.copy_1_GO,SF);
    VR_Results.(participants{i}).(trials{j}).FP2.MPF = meanfreq(VR_Results.(participants{i}).(trials{j}).raw.copy_2_GO,SF);
    VR_Results.(participants{i}).(trials{j}).FP1.COPap_SD = std(VR_Results.(participants{i}).(trials{j}).raw.copy_1_GO);
    VR_Results.(participants{i}).(trials{j}).FP2.COPap_SD = std(VR_Results.(participants{i}).(trials{j}).raw.copy_2_GO);

    end 
end

%% Order params of interest
participants = fieldnames(VR_Results);
for i=1:length(participants)
    trials = fieldnames(VR_Results.(participants{i}));
    for j=1:length(trials)
        
        T_VR_participant(i,j) = {trials{j}};
        T_VR_Elipse(i,j+1) = VR_Results.(participants{i}).(trials{j}).FP1.ellipseArea;
        T_VR_Elipse(i,j+6) = VR_Results.(participants{i}).(trials{j}).FP2.ellipseArea;
        
        T_VR_COPlength(i,j+1) = VR_Results.(participants{i}).(trials{j}).FP1.meanDist;
        T_VR_COPlength(i,j+6) = VR_Results.(participants{i}).(trials{j}).FP2.meanDist;
        
        T_VR_COPap(i,j+1) = VR_Results.(participants{i}).(trials{j}).FP1.meanDisty;
        T_VR_COPap(i,j+6) = VR_Results.(participants{i}).(trials{j}).FP2.meanDisty;
        
        T_VR_COPml(i,j+1) = VR_Results.(participants{i}).(trials{j}).FP1.meanDistx;
        T_VR_COPml(i,j+6) = VR_Results.(participants{i}).(trials{j}).FP2.meanDistx;
        
        T_VR_MPF(i,j+1) = VR_Results.(participants{i}).(trials{j}).FP1.MPF;
        T_VR_MPF(i,j+6) = VR_Results.(participants{i}).(trials{j}).FP2.MPF;
        
        T_VR_COPap_SD(i,j+1) = VR_Results.(participants{i}).(trials{j}).FP1.COPap_SD;
        T_VR_COPap_SD(i,j+6) = VR_Results.(participants{i}).(trials{j}).FP2.COPap_SD;
    end
end

    