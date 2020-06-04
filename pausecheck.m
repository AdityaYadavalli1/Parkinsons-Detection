clc
clear all
close all

[x,Fs]=audioread('control_rosita.wav'); %//input: speech segment
x = resample(x,8000,Fs);
Fs=8000;
% plot(y);
Epoch = [];
frames = buffer(x, 20*Fs/1000, (20*Fs/1000)-1);
E = sum(frames.^2);
th = mean(E);
vuv = zeros(1, size(frames,2));
vuv(E>0.005) = 1;
vind = find(vuv==1);

plot(E)
hold on
plot(vuv)
