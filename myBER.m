clear all;
close all;
message = rand(1, 1024);
message = 2*message - 1;

numSymb = numel(message);

for i=1:numSymb
    if message(i)>0
        message(i)=1;
    else
        message(i)=-1;
    end
end

binary=[];
Vp=1;
T=200;
Rb = 1;
t = 1:1:1024;

f = 5;
trans = message.*cos(2*pi*f*t);

SNRdB = 0:2:14;
SNR = 10.^(SNRdB/10);
BER = zeros(1, numel(SNR));
Eb = Vp^2;
iter_max=10;
f = 5;
y=[];

for count=1:numel(SNR)
    avgError = 0;
    N_max = Eb/SNR(count);

for iter=1:iter_max
    error=0;
    noise = sqrt(N_max/2)*randn(1,numel(trans));
    received = trans + noise;
    demodulated = received.*cos(2*pi*f*t);
    
       
    for i=1:numSymb
        if((message(i)==1 && demodulated(i)<0)||(message(i)==-1&&demodulated(i)>0))
            error = error+1;
        end
    end
    
    error = error/numSymb;
    avgError = avgError + error;
end

BER(count) = avgError/iter_max;

end


scatterplot(demodulated);
scatterplot(message)

BER_theoretical = 0.5*erfc(sqrt(SNR));

figure;
semilogy(SNRdB, BER_theoretical, 'k');
hold on;
semilogy(SNRdB, BER, 'r*');
axis([min(SNRdB), max(SNRdB) 10^(-5) 1]);
hold off;
