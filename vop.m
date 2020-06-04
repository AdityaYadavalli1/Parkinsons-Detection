clc;
close all;
clear all;

%calculating various parameters of the audio input
[b, Fs]=audioread('control_rosita.wav'); %Audio File, Fs is sampling rate
% sound(b,Fs);
len=length(b)/Fs; %We get time of audio in seconds
sam_len = floor(((len*1000)- 10)/(10));
max = zeros(10);
getans=zeros(sam_len,1);

%calculating the spectral peaks corresponding to a signal with interval of
%20 ms.
for i=2:sam_len
      b_test=b(Fs*(i-1)*0.01 : Fs*(i+1)*0.01);
      b_test_fft = fft(b_test,256);
      b_test_fft2=b_test_fft(1:128);
      [sortedX,sortingIndices] = sort(b_test_fft2,'descend');
      maxValues = sortedX(1:10);
      for temp=1:10
        getans(i,1)=getans(i)+abs(maxValues(temp));
      end
end

%Enhancing the signal by using the normalisation technique
k=length(getans);
reference = getans(2);
reference_index = 2;
getans=smooth(getans);
f1=smooth(getans);

x_axis=0:1/Fs:len;
if(length(x_axis)~=length(b))
    q=length(x_axis)-length(b);
    if(q>0)
        x_axis=0:1/Fs:len-q/Fs;
    else
        x_axis=0:1/Fs:len+q/Fs;
    end
end

x_axis2=0:len/length(f1):len;
if(length(x_axis2)~=length(f1))
    q=length(x_axis2)-length(f1);
    if(q>0)
        x_axis2=0:len/length(f1):len-(q*len/length(f1));
    else
        x_axis2=0:len/length(f1):len+(q*len/length(f1));
    end
end



%Plots-

% subplot(2,1,1);
% plot(x_axis,b);
% title('Time Domain Signal');
subplot(1,1,1);
plot(x_axis2, f1);
title('VOP Evidence');
