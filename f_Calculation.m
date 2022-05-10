function [ AmplitudeHwave,AmplitudeMwave,AmplitudeBaseline,x1, h,i,destPath] = f_Calculation( EMG,Trig,Stimulus, critvalue,i,destPath)

[m,n] = size (EMG);
x = zeros(1,n);
EMGinv = -1*EMG;
intro = 15;%15
delay = 30;%RV adapted 180 to 45
% MW=60; % length of M-Window
% HW=120; % length of H-Window

% intro = 100;
% delay = 120;
MW = 30;
HW = 40;
time = linspace(0,998,500);

k = 1;
% x(1,k) = find(Trig(:,k) >= 2 ,1,'first'); % Search the First Trigger
x(1,k) = find(Stimulus(:,1)>= 1 ,1,'first'); % Search the First Trigger Point 
% x1(1,k) = Trig(x(1,k),k);                % Amplitude of the Trigger Signal
x1 = Trig;
stimulus = x1(1,k); %RV removed *10

% if x1(1,k) >= critvalue
%     del(1,:) = find(EMG(300:410,k) > 0.1); %RV adapt 400 to 410 and 0.9 to 0.1
%     if del(1,1)+300 - x(1,k) < 90
%         delay = 45;%RV adapted 85 to 45
%     end
% end

%% Baseline EMG
[Maxima,MaxIdx] = findpeaks(EMG(((x(1,k)-intro):(x(1,k)-1)),k),'SortStr','descend');
maxB(1,k) = Maxima(1,1); % Maximum im Fenster in Intro bis Ankunft von Trigger
maxBIdx (1,k) = MaxIdx(1,1);
[Minima,MinIdx] = findpeaks(EMGinv(((x(1,k)-intro):(x(1,k)-1)),k),'SortStr','descend'); % Minimum im Fenster in Intro bis Ankunft von Trigger
minB(1,k) = -1*Minima(1,1);
minBIdx (1,k) = MinIdx(1,1);
AmplitudeBaseline(1,k) = maxB(1,k) - minB(1,k); % maximale Amplitude im Fenster

%% M-Wave
[Maxima,MaxIdx] = findpeaks(EMG(x(1,k)+delay:(x(1,k)+MW+delay),k),'SortStr','descend'); 
maxM(1,k) = Maxima(1,1); % Maximum im Fenster von Ankunft Trigger bis 45Frames später (15ms)
maxMIdx (1,k) = MaxIdx(1,1);
[Minima,MinIdx] = findpeaks(EMGinv(x(1,k)+delay:(x(1,k)+delay+MW),k),'SortStr','descend'); %Minimum im Fenster von Ankunft Trigger bis 45Frames später(15ms)
minM(1,k) = -1*Minima(1,1);
minMIdx (1,k) = MinIdx(1,1);
AmplitudeMwave(1,k) = maxM(1,k) - minM(1,k); % maximale Amplitude im Fenster

%% H-Reflex
[Maxima,MaxIdx] = findpeaks(EMG((x(1,k)+(MW+delay)):(x(1,k)+MW+HW+delay),k),'SortStr','descend');
maxH(1,k) = Maxima(1,1);
maxHIdx (1,k) = MaxIdx(1,1);
[Minima,MinIdx] = findpeaks(EMGinv((x(1,k)+MW+delay):(x(1,k)+MW+HW+delay),k),'SortStr','descend');
minH(1,k) = -1*Minima(1,1);
minHIdx (1,k) = MinIdx(1,1);
AmplitudeHwave(1,k) = maxH(1,k) - minH(1,k);

h = figure('units','normalized','outerposition',[0 0 0.65 1]); % plot of EMG Signal with Windows and Amplitudes
plot(EMG(x(1,k)-intro:m,k),'LineWidth',1);
hold on

%% Baseline EMG
plot(maxBIdx(1,k),maxB(1,k),'Marker','*','Color','red');
hold on
plot(minBIdx(1,k),minB(1,k),'Marker','*','Color','red');
hold on
rectangle('Position',[0 (minB(1,k)-0.1) intro (AmplitudeBaseline(1,k)+0.2)],'EdgeColor','b','LineWidth',1);

%% M-Wave
plot(maxMIdx(1,k)+intro+delay,maxM(1,k),'Marker','*','Color','red');
hold on
plot(minMIdx(1,k)+intro+delay,minM(1,k),'Marker','*','Color','red');
hold on
rectangle('Position',[intro+delay (minM(1,k)-0.1) MW (AmplitudeMwave(1,k)+0.2)],'EdgeColor','r','LineWidth',1);

%% H-reflex
hold on
plot(maxHIdx(1,k)+intro+MW+delay , maxH(1,k),'Marker','*','Color','red');
hold on
plot(minHIdx(1,k)+intro+MW+delay , minH(1,k),'Marker','*','Color','red');
hold on
height(1,k) = AmplitudeHwave(1,k)+0.2;
rectangle('Position',[intro + MW + delay (minH(1,k)-0.1) HW (AmplitudeHwave(1,k)+0.2)],'EdgeColor','r','LineWidth',1);

%% Beschriftung Baseline
strmin = ['Minimum =', num2str(minB(1,k))];
text(minBIdx(1,k),minB(1,k),strmin,'HorizontalAlignment','right');
strmax = ['Maximum =', num2str(maxB(1,k))];
text(maxBIdx(1,k),maxB(1,k),strmax,'HorizontalAlignment','left');
text(0,maxB(1,k)+0.11,'Baseline EMG - Window')

%% Beschriftung M-Wave
strmin = ['Minimum =', num2str(minM(1,k))];
text(minMIdx(1,k) + intro + delay,minM(1,k),strmin,'HorizontalAlignment','right');
strmax = ['Maximum =', num2str(maxM(1,k))];
text(maxMIdx(1,k) + intro + delay,maxM(1,k),strmax,'HorizontalAlignment','left');
text(intro + delay,maxM(1,k)+0.11,'M-Wave-Window')

%% Beschriftung H-Wave
strmin = ['Minimum =', num2str(minH(1,k))];
text(minHIdx(1,k) + intro + MW + delay,minH(1,k),strmin,'HorizontalAlignment','right');
strmax = ['Maximum =', num2str(maxH(1,k))];
text(maxHIdx(1,k) + intro + MW + delay,maxH(1,k),strmax,'HorizontalAlignment','left');
text(intro + delay+ MW,maxH(1,k)+0.11,'H-Wave-Window')

if x1(1,k) > critvalue
    title ([' Soleus EMG Mmax vs Stimulus Intensity=', num2str(stimulus),'mA'])
else
    title(['Soleus EMG H-Reflex vs Stimulus Intensity =', num2str(stimulus),'mA'])
end

xlabel('\fontsize{14} Data Points');
ylabel('\fontsize{14} EMG Amplitude [mV]');

%% Figure Save
savename = sprintf('Figure %d',i);
savefig(h, fullfile(destPath, savename), 'compact');
clear Maxima
clear n
