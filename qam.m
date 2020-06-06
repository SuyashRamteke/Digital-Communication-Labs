clear all 
close all
n = 9999;
data = randi([0 1],1,n);
%Modulation
data_mod = [];
mod_matrix = [ 1 1+i i -1+i -1 -1-i -i 1-i];
demod_matrix = [ 0 0 0 ; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
for i= 1:3:n
    temp = data(i+2) + 2.*data(i+1) + 4.*data(i);
    data_mod = [ data_mod mod_matrix(temp+1) ];
end;
SER = [];
BER = [];
s_error = 0;
b_error = 0;
for i = 0:2:14
    data_mod_noise =  awgn(data_mod,i); %Addition of noise
    scatterplot(data_mod_noise);
    title('Received Signals Constellation of Rectangular QAM');
    grid on;

%Demodulation

data_demod = [];
d_temp = 0+ 0j;
for q = 1:length(data_mod_noise)
    t = data_mod_noise(q);
    d_temp = 0+0i;
    %imag part
    if imag(t)>0.5 
        d_temp = d_temp + j;
    end;
    if imag(t)<-0.5
        d_temp = d_temp - j;
    end
    
    %real part        
    if real(t)>0.5
        d_temp = d_temp +1;
    end
    if real(t)<-0.5
        d_temp = d_temp -1;
    end
    if d_temp == 0 
        if imag(t)>0
            d_temp = d_temp + j;
        end
        if imag(t)<0
            d_temp = d_temp - j;
        end
    end
    
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
s_error = 0;
b_error = 0;
for q = 1:length(data_final)
    if error_b(q) ~= 0
        b_error = b_error +1;
    end
end
for q = 1:length(data_demod)
    if error_s(q) ~= 0
        s_error = s_error + 1;
    end
end

SER = [ SER s_error/length(data_mod)];
BER = [ BER b_error/length(data)];

end;

SNR = 0:2:14;
semilogy(SNR, BER);
hold on;
BERT = 2*erfc(sqrt((9/14)*SNR));
semilogy(SNR, BERT, 'r*');
legend('Measured', 'Theoretical');
xlabel('Eb/No in dB');
ylabel('Bit Error Rate');
title('Rectangular QAM');    