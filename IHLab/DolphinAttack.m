%% Cleaning Part
clc;
clear all;
close all;

%% Loading Audio/Creating needed vector

// [y, Fs] = audioread('Chinese48000.wav');
[y, Fs] = audioread('Aorin.wav');
[b,a]=butter(10, 3000/(Fs/2),'low');
y_filtered = filter(b,a,y);


L = max(size(y));
t = (1:L)'/Fs;

%% Parameter of the AM 


% OK GOOOGLE WORKING WITH 20KHz ; 21KHz

f_0 = 25000; %% Frequency of the modulation
a = 1; %% Amplitude
%y_filtered = resample(y_filtered,Fs.*4,Fs);
x_m = a*sin(2*pi*f_0*t);

%% Processing the modulation

% x_hf_1 is a simple stereo AM signal (Not the one from the article), doesn't work in my tests
x_hf_1(:,1) =x_m.*y_filtered(:,1);
%x_hf_1(:,2) =x_m.*y_filtered(:,2);
%soundsc(x_hf_1, Fs) 


% x_hf_2 is the one from the article, works in my tests 

x_hf_2(:,1) =(x_m).*y_filtered(:,1)+x_m;
%x_hf_2(:,2) =(x_m).*y_filtered(:,2)+x_m;
%soundsc(x_hf_2, Fs) 

%% Save the signal in a flat audioformat 
hf_norm = x_hf_2/max(x_hf_2(:));
audiowrite('high_Chinese48000.wav', hf_norm, Fs,'BitsPerSample',24);
// audiowrite('high_Aorin.wav', hf_norm, Fs,'BitsPerSample',24);



%% Visualisation of spectrum
f_axis = [0:L-1]*Fs/L;
Y = abs(fft(y_filtered(:,1)))./L;
YHF = abs(fft(x_hf_1(:,1)))./L;
plot(f_axis(1:L/2), Y(1:L/2),'color','b')
hold on
plot(f_axis(1:L/2), YHF(1:L/2), 'color','r')
