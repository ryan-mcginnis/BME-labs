%% ECG Lab
% BME083
% Ryan S. McGinnis, PhD - ryan.mcginnis@uvm.edu
% University of Vermont, Biomedical Engineering

%% Identify the myDAQ device

daq.getDevices

%% Create a session

s = daq.createSession('digilent');

%% Add an analog input Voltage channel for the ECG signal

ch = addAnalogInputChannel(s, 'AD1', 1, 'Voltage');

%% Turn on power supply 

s.setPowerSupply('positive','on');
s.setPowerSupply('negative','on');

%% Obtain timestamped ECG data
s.DurationInSeconds = 10;
s.Rate = 400;

[data, timestamps, triggerTime] = startForeground(s);

lpf_obj = ecg_lp_filter;
data_f = filtfilt(lpf_obj.sosMatrix,lpf_obj.ScaleValues,data);

% Filter ECG data and plot
figure;
subplot(211)
plot(timestamps, data_f);
xlabel('Time (s)'); 
ylabel('Filtered Voltage (V)');
title(['Clocked Data Triggered on: ' datestr(triggerTime)])

subplot(212)
plot(timestamps, data);
xlabel('Time (s)'); 
ylabel('Raw Voltage (V)');


s.setPowerSupply('positive','off');
s.setPowerSupply('negative','off');
