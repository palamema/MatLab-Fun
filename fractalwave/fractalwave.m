%Customizable stuff
%load ../EqualTemp.mat %To use note names (e.g. Aflat5) in place of frequencies
f=1234; %Base Frequency, in Hertz. Shan't exceed 11.025 kHz
duration=5; %Duration of signal, in seconds
stages=4; %Number of stages
filename='fractal.flac'; %Filename to export signal to

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Use caution when editing below here!

fs=44.1e3; %Sampling frequency
T=fs^-1; %Sampling period
n=0:fs*duration-1; %Sample index
t=n*T; %Time index

%The fun part
x=1;
for i=1:stages
  x=1+cos(2*pi*f*t*2^(-stages+i)).*x;
end

%Graphs 'n' stuff:
X=abs(fftshift(fft(x)))/length(x); %Fourier Transform magnitude
findex=(-1/2:1/length(x):1/2-1/length(x))*fs; %Frequency index
plot(findex, X);
title('"Fractal" Signal in Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude (scale factor)');
axis([-2*f 2*f 0 1]); %Scale the plot


y=x./max(abs(x)); %Normalize to within range of -1 and 1
audiowrite(filename,y,fs); %Export audio file