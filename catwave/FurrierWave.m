%{
This is an old script, made for my video "Catwave".
I now realize how terribly written it is.
Shield your eyes!
%}


%Drawing top half with individual points
topcat1=[7 7 7 7 9 14 15.5 17 18 19.25];
topcat2=[20 21.5 23 24 23.75];
topcat3=[21 18.5 17 15.75 16.75];
topcat4=[17.5 17.75 18 17.75 17.5];
topcat5=[16.5 14.5 13 11.75 9.5 11];
topcathalf=horzcat(topcat1, topcat2, topcat3, topcat4, topcat5); %haha "horzcat" has "cat" in it
topcathalflip=fliplr(topcathalf);
topcat=horzcat(topcathalf,8, topcathalflip);

%Drawing bottom half
botcat1=[7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7];
botcat2=[6.5 5.25 4.5 4.25 4 3.75 3.75 4 4.25 4.75 5.25 6];
botcathalf=horzcat(botcat1, botcat2);
botcathalflip=fliplr(botcathalf);
botcat=horzcat(botcathalf, 7, botcathalflip);

%Create two shapes, with top and bottom switched
cat=horzcat(topcat, botcat);
tac=horzcat(botcat, topcat);
n=0:length(cat)-1;

%{
%Test points drawing
plot(n,cat, n,tac);
daspect([1 1 1]);
%}

%Furrier Analysis
furco=fft(cat);
mag=abs(furco);
ang=angle(furco);

ocruf=fft(tac);
gam=abs(ocruf);
gna=angle(ocruf);

%Construct waveform
freq=49.00;
x=0:1/44.1e3:1/freq;
furfun=0;
nufruf=0;
res=64; %64 by default
%{
But, there will be some HIGH frequencies in this, remember:
res < [MaxFreq / (2*pi*freq)] + 1

Handy lil chart, using 20kHz as MaxFreq:

Pitch:  Freq:    Res:

B#/C	32.70    98
C#/Db	34.65    92
D	    36.71    87  
D#/Eb	38.89    82
E/Fb	41.20    78
E#/F	43.65    73
F#/Gb	46.25    69
G	    49.00    65
G#/Ab	51.91    62
A	    55.00    58
A#/Bb	58.27    55
B/Cb	61.74    52

Just, like, multiply or divide by 2 for more octaves
%}

for a = 2:res
    furfun=2*mag(a)*cos(2*pi*freq*(a-1).*x+ang(a))+furfun;
end

for b = 2:res
    nufruf=2*gam(b)*cos(2*pi*freq*(b-1).*x+gna(b))+nufruf;
end

Furrier=(mag(1)+furfun)/1550-1.12;
reirruF=(gam(1)+nufruf)/1550-1.12;

%Check for image quality
figure(2);
plot(x,Furrier,x,reirruF);

%Export as sound
%makesound=transpose([Furrier;reirruF]);
%audiowrite('lowG.flac',makesound,44100);