clear all 
close all
n = 9999;
data = randi([0 1],1,n);
k = 1:3333
w = 2*exp(j*2*pi*k/3333)

%Modulation
data_mod = [];
mod_matrix = [  (1+i)/sqrt(2)  (-1+i)/sqrt(2)  (-1-i)/sqrt(2)  (1-i)/sqrt(2) 3 3i -3 -3i];
demod_matrix = [ 0 0 0 ; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
for i= 1:3:n
    temp = data(i+2) + 2.*data(i+1) + 4.*data(i);
    data_mod = [ data_mod mod_matrix(temp+1) ];
end;
scatterplot(data_mod);
grid on;
title('Circular 2 QAM Constellation');
figure
SER2 = [];
BER2 = [];
s_error2 = 0;
b_error2 = 0;
for i = 0:2:14
    data_mod_noise =  awgn(data_mod,i); %Addition of noise
    
    scatterplot(data_mod_noise );
    grid on;

    scatterplot(data_mod_noise );
    title('Received Signals Constellation of Circular 2 QAM');
    grid on;
%Demodulation

data_demod = [];
d_temp = 0+ 0j;
for q = 1:length(data_mod_noise)
    t = data_mod_noise(q);
    if abs(t) > 2
        angle = atan2(imag(t),real(t));
        angle = angle*180/pi;
        angle = mod(floor((angle+45)/90),4)+5;
        d_temp = mod_matrix(angle);
        data_demod = [ data_demod d_temp];
    end
    if abs(t)<=2
        angle = atan2(imag(t),real(t));
        angle = angle*180/pi;
        angle = mod(floor((angle)/90),4)+1;
        d_temp = mod_matrix(angle);
        data_demod = [ data_demod d_temp];
    end
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
s_error2 = 0;
b_error2 = 0;
for q = 1:length(data_final)
    if error_b(q) ~= 0
        b_error2 = b_error2 +1;
    end
end
for q = 1:length(data_demod)
    if error_s(q) ~= 0
        s_error2 = s_error2 + 1;
    end
end

SER2 = [ SER2 s_error2/length(data_mod)];
BER2 = [ BER2 b_error2/length(data)];

end;

SNR = 0:2:14;
semilogy(SNR, BER2);
hold on;
BERT = 3.5*erfc(sqrt(SNR));
semilogy(SNR, BERT, 'k*');
legend('Measured', 'Theoretical');
xlabel('Eb/No in dB');
ylabel('Bit Error Rate');
title('Circular 2 QAM');      