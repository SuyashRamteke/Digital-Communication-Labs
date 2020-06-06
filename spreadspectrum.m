clc;
m = [4 5 6];
G = [1 0 0 1 1 0 0 1 1 0 0 1 0 0;
     1 0 0 1 0 1 0 1 1 1 1 0 1 0;
     1 0 0 0 0 1 1 1 1 0 0 1 1 1;];
 for i=1:3
     c1 = pnsq(G(i, 1:7), m(i));
     c2 = pnsq(G(i, 8:14), m(i));
 figure;
 subplot(211)
 q=cor(c1, c1);
 title(['Auto-correlation of ',num2str(2^m(i)-1),'-sequence']);
 xlabel('Time Index');
 ylabel('Amplitude');
 subplot(212)
 cor(c1, c2);
 title(['Cross-correlation of ',num2str(2^m(i)-1),'-sequence']);
 xlabel('Time Index');
 ylabel('Amplitude');
 end
 goldcodes;
 hadam;
 clear all;
 N = 1024;
 s1 = rand(1, N)>0.5;
 ip1=2*s1-1;
 t=0:0.00001:0.001;
 c1 = sin(2*pi*1*t);
 c=c1/norm(c1);
 ebyn0db=0:14;
 ebyn0 = 10.^(ebyn0db/10);
 PSK1 = ip1'*c;
 
 nBits = 5;
 MLS5 = [];
 weights = [zeros(1, nBits-1) 1];
 for i=1:2^nBits-1
     MLS5(i, :) = weights;
     tapVal=rem((weights(5)+weights(2)), 2);
     weights=circshift(weights, [0, 1]);
     weights(1)=tapVal;
 end
 
 
 nBits = 6;
 MLS6 = [];
 weights = [zeros(1, nBits-1) 1];
 for i=1:2^nBits-1
     MLS6(i, :) = weights;
     tapVal=rem((weights(6)+weights(1)), 2);
     weights=circshift(weights, [0, 1]);
     weights(1)=tapVal;
 end
 
 for n=1:2
     if n==1
         l=31;
         pn = 2*MLS5(:,5)'-1;
     else
         l=63;
         pn = 2*MLS6(:,6)'-1;
     end
     ip=[];
     for i=1:length(s1)
         temp=ip1(i)*pn;
         ip = [ip temp];
     end
     PSK=ip'*c;
     %AWGN Channel
     n1 = randn(length(ip),length(t));
     n11 = randn(length(ip1), length(t));
     BER = []; BERn = [];
     for k = 1:length(ebyn0db)
         n0 = 1/ebyn0(k);
         n01 = 1/ebyn0(k);
         rcv1 = PSK+sqrt(n0/2)*n1;
         rcv1_1 = PSK1+sqrt(n01/2)*n11;
         rcv=rcv1*c';
         rcv=rcv';
         rcv_1=rcv1_1*c';
         rcv_1 = rcv_1';
         rx = [];
         for i=1:length(rcv)/l
             d=sum(rcv(l*(i-1)+1:l*(i-1)+1).*pn)/l;
             rx = [rx d];
         end
         y = rx > 0;
         err = xor(y, s1);
         BER(k)=mean(err);
         y = rcv_1>0;
         err = xor(y, s1);
         BERn(k)=mean(err);
     end
     thber = 0.5*erfc(sqrt(10.^(ebyn0db/10)));
     n2 = randn(length(ip),length(t))+1i*randn(length(ip),length(t));
     n21 = randn(length(ip1), length(t))+1i*randn(length(ip1),length(t));
     BERr=[]; BERrn=[];
     for k=1:length(ebyn0db)
         n0 = 1/ebyn0(k);
         n01 = 1/ebyn0(k);
         rcv11=n2.*PSK+sqrt(n0/2)*n1;
         rcv11_1=n21.*PSK1+sqrt(n01/2)*n11;
         rcv1 = rcv11./n2;
         rcv = rcv1*c';
         rcv = rcv';
         rcv1_1 = rcv11_1./n21;
         rcv_1 = rcv1_1*c';
         rcv_1 = rcv_1';
         rx = [];
         for i = 1:length(rcv)/l
             d=sum(rcv(l*(i-1)+1:l*(i-1)+1).*pn)/l;
             rx = [rx d];
         end
         y=rx>0;
         err = xor(y, s1);
         BERr(k)=mean(err);
         y=rcv_1>0;
         err=xor(y, s1);
         BERrn(k) = mean(err);
     end
     thray = 0.5.*(1-sqrt(ebyn0./(ebyn0+1)));
     figure;
     semilogy(ebyn0db, thber, 'bo-');hold on;
     semilogy(ebyn0db, BER, 'rs-');hold on;
     semilogy(ebyn0db, BERn, 'k.-');hold on;
     semilogy(ebyn0db, thray, 'bo-');hold on;
     semilogy(ebyn0db, BERr, 'rs-');grid on;
     semilogy(ebyn0db, BERrn, 'k.-');grid on;
     legend('Theoretical AWGN', 'AWGN with spreading', 'AWGN without spreading', 'Theoretical Rayleigh', 'Rayleigh with spreading', 'Rayleigh without spreading');
     legend('Location', 'southwest');
     xlabel('SNR in dB');
     ylabel('Bit Error Rate');
     str = sprintf('Bit error probability curve for BPSK modulation for n-sequence of length %d', l);
     title(str);
 end