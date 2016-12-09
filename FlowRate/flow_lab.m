%% Respiratory Flowrate Lab
% BME083
% Ryan S. McGinnis, PhD - ryan.mcginnis@uvm.edu
% University of Vermont, Biomedical Engineering

%% Identify the myDAQ device

daq.getDevices

%% Create a session

s = daq.createSession('ni')

%% Add an analog input Voltage channel for the ECG signal

s.addAnalogInputChannel('myDAQ1', 'ai1', 'Voltage')

%% Add analog output Voltage channels to power the ECG circuit

s.addAnalogOutputChannel('myDAQ1', 'ao1', 'Voltage')

%% Set session and channel properties

s.Rate = 100; %sampling frequency in Hz
DurationInSeconds = 20; %duration of the collection in s

%% Define output data and queue for DAQ
output_data = 5*ones(round(s.Rate*DurationInSeconds),1);
s.queueOutputData(output_data);
            
%% Obtain timestamped ECG data

[data, timestamps, triggerTime] = s.startForeground;

%% Plot pressue data
cut_off = 15;
fs = s.Rate;
n=4;
[b,a] = butter(n,cut_off/(fs/2),'low');
data_f = filtfilt(b,a,data);

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
