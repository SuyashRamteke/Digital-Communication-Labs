 clear all; close all; clc;
 L=1000;                           
 snrdb=1:1:10;                      
 snr=10.^(snrdb/10); 
 
 data=round(rand(1,L));       %Generating random digital seq
 data=2*data-1;
 NRZ_out=[];
 
%Encoding input bitstream as Bipolar NRZ
for index=1:length(data)
 NRZ_out=[NRZ_out ones(1,100)*data(index)];
end

%Modulation
t= 0.01:0.01:1000;
t1 = linspace(0,1,L);
f=5;
Modulated=NRZ_out.*cos(2*pi*f*t);
 
 BER_sim=zeros(1,10);
 for i=1:length(snr)              
         error=0;                              
         noise=1/(sqrt(2*snr(i)))*randn(1,L*100);  %Noise
         Sig=Modulated+noise;             %Received Signal
         
         
        %Demodulation
        y=[];
        demodulated=Sig.*cos(2*pi*f*t);
        for j=1:100:size(demodulated,2)
        y=[y trapz(t(j:j+99),demodulated(j:j+99))];
        end
         
        
         for k=1:L               %Decision making
             if ((y(k)>0 && data(k)==-1)||(y(k)<0 && data(k)==1))
                 error=error+1;
             end
         end
         
     BER_sim(i)=error/L;   %BER Simulation Calculation
 end                                      
 BER_th=0.5*erfc(sqrt(snr));         %Theoretical BER Calculation
%  Constellation Diagram
scatterplot(2*y)
scatterplot(data)
%stem(y)
title('Constellation Diagram with noise');

 