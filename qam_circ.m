clear all 
close all
n = 9999;
data = randi([0 1],1,n);
%Modulation
data_mod = [];
mod_matrix = [ 1 (1+i)/sqrt(2) i (-1+i)/sqrt(2) -1 (-1-i)/sqrt(2) -i (1-i)/sqrt(2)];
demod_matrix = [ 0 0 0 ; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
for i= 1:3:n
    temp = data(i+2) + 2.*data(i+1) + 4.*data(i);
    data_mod = [ data_mod mod_matrix(temp+1) ];
end;
scatterplot(data_mod);
grid on;
title('Circular 1 QAM Constellation');
SER1 = [];
BER1 = [];
s_error1 = 0;
b_error1 = 0;
for i = 0:2:14
    data_mod_noise = awgn(data_mod,i); %Addition of noise
    scatterplot(data_mod_noise);
    grid on;
     scatterplot(data_mod_noise);
     title('Received Signals Constellation of Circular 1 QAM');
     grid on;
%Demodulation

data_demod = [];
d_temp = 0+ 0j;
for q = 1:length(data_mod_noise)
    t = data_mod_noise(q);
    d_temp = 0+0i;
    angle = atan2(imag(t),real(t));
    angle = angle*180/pi;
    angle = mod(floor((angle+22.5)/45),8);
    d_temp = mod_matrix(angle+1);
    data_demod = [ data_demod d_temp];
    
end

data_final = [];
for p = 1:length(data_demod)
    for q = 1:length(mod_matrix)
        if data_demod(p) == mod_matrix(q)
            data_final = [ data_final demod_matrix(q,:)];
        end
    end
end
error_s = data_mod - data_demod;
error_b = data - data_final;
s_error1 = 0;
b_error1 = 0;
for q = 1:length(data_final)
    if error_b(q) ~= 0
        b_error1 = b_error1 +1;
    end
end
for q = 1:length(data_demod)
    if error_s(q) ~= 0
        s_error1 = s_error1 + 1;
    end
end

SER1 = [ SER1 s_error1/length(data_mod)];
BER1 = [ BER1 b_error1/length(data)];

end;

SNR = 0:2:14;
semilogy(SNR, BER1);
hold on;
BERT = erfc(sqrt((3*SNR/14)))*sin(pi/8);
semilogy(SNR, BERT, 'k*');
legend('Measured', 'Theoretical');
xlabel('Eb/No in dB');
ylabel('Bit Error Rate');
title('Circular 1 QAM');      