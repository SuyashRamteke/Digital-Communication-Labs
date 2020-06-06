 close all;clear all;clc;  
 L=3;                            
 data=round(rand(1,L));       %Generating random digital seq
 data=2*data-1;
 NRZ_out=[];
 
%Encoding input bitstream as Bipolar NRZ
for index=1:length(data)
 NRZ_out=[NRZ_out ones(1,100)*data(index)];
end
 
%Modulation
t= 0.01:0.01:3;
f=5;
Modulated=NRZ_out.*cos(2*pi*f*t);
plot(t,Modulated);