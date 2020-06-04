clc
clear all
close all

[x,Fs]=audioread('cmu_arctic.wav'); %//input: speech segment
x = resample(x,8000,Fs);
Fs=8000;
y = filter(1,[1,-2,1],x);
y = filter(1,[1,-2,1],y);
% mv = movemean(y,15*Fs/1000);
y = y - movavg1(y,Fs);
y = y - movavg1(y,Fs);
y = y - movavg1(y,Fs);
y = y - movavg1(y,Fs);
% plot(y);
Epoch = [];
frames = buffer(x, 20*Fs/1000, (20*Fs/1000)-1);
E = sum(frames.^2);
th = mean(E);
vuv = zeros(1, size(frames,2));
vuv(E>th/4) = 1;
vind = find(vuv==1);
SOE = [];
for i = 1:(length(y)-1)
    if(checkepoch(y(i),y(i+1)) == 1 && vuv(i) == 1)
        Epoch = [Epoch; i]; % contains the index of epochs 
        SOE = [SOE;E(i)];
    end
end

eps=x-x;
eps(Epoch)=1;
plot(x)
hold on
plot(eps*max(x))


function ret = checkepoch(x1, x2)
    ret = 0;
    if((x1 < 0 && x2 >=0)) 
        ret = 1;
    end
end
function ret = movavg1(y,Fs)
    y1 = zeros(floor(length(y)/2),1); 
    z = [y1; y];
    z = [z; y1];
    ret = movmean(z,15*Fs/1000);
    ret = ret((floor(length(y)/2))+1:(length(ret)-floor(length(y)/2)));
end
