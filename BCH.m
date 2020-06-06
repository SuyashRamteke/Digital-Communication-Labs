close all;clear all;clc;
L=1e5;
SNRdb = 0:10;
SNR = 10.^(SNRdb/10);
ber=zeros(1,length(SNRdb));

for i=0:L
encoded = BCH_Encoding(round(rand(1,7)));
noise = randn(1,15)/(sqrt(2*10.^SNRdb(mod(i-1,length(SNRdb))+1)/10));
received = encoded + noise;
decoded = BCH_Decoding(received);

error = decoded - encoded;
for j=1:length(error)
    if abs(error(j))==1
        ber(mod(i-1,length(SNRdb))+1)=ber(mod(i-1,length(SNRdb))+1)+1;
    end
end
end

ber_sim = ber/(15*L);
ber_th=0.5*erfc(sqrt(2*SNR));
figure
semilogy(SNRdb,ber_th);
axis([min(SNRdb) max(SNRdb) 10^(-7) 1]);
hold on;
semilogy(SNRdb,ber_sim,'k*');