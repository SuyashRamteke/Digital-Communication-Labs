clear all
close all
n = 9800;
data = randi([0 1],1, n);

gen = [1 0 0 0 1 0 1 1 1];

gen_mtx = [gen zeros(1,6)];

%BCH Encoding
for i = 1:5
    gen_mtx = [gen_mtx; [zeros(1,i) gen zeros(1,6-i)]];
end
gen_mtx = [gen_mtx; zeros(1,6) gen];
%Making Generator Matrix Systematic
 gen_mtx(1,:) = gen_mtx(1,:) + gen_mtx(5,:);
 gen_mtx(2,:) = gen_mtx(2,:) + gen_mtx(6,:);
 gen_mtx(1,:) = gen_mtx(1,:) + gen_mtx(7,:);
 gen_mtx(3,:) = gen_mtx(3,:) + gen_mtx(7,:);
 gen_mtx = mod(gen_mtx,2);
data_ecc = [];
for i=7:7:n
    %BCH Encoding
   data_ecc = [data_ecc mod(data(i-6:i)*gen_mtx,2)]; 
end

%BPSK Modulation
data_ecc_mod = [];
for i = 1:length(data_ecc)
    if data_ecc(i) == 0
        data_ecc_mod = [data_ecc_mod -1];
    else
        data_ecc_mod = [data_ecc_mod 1];
    end
        
end

%Adding noise to modulated signal
BER = [];
BER1 = [];
for SNR=0:1:40
    
    
     N0 = 1/10^(SNR/10);
        
        % Rayleigh channel fading
        h = 1/sqrt(2)*[randn(1,length(data_ecc_mod)) + j*randn(1,length(data_ecc_mod))]; 

        % Send over Gaussian Link to the receiver
        data_ecc_mod_noise = h.*data_ecc_mod + sqrt(N0/2)*(randn(1,length(data_ecc_mod))+i*randn(1,length(data_ecc_mod)));
        data_ecc_mod_noise = data_ecc_mod_noise./h;
   
    %scatterplot(data_mod_noise);
    data_ecc_demod = [];
    for l=1:length(data_ecc)
        if data_ecc_mod_noise(l) < 0
            data_ecc_demod = [data_ecc_demod 0];
        else
            data_ecc_demod = [data_ecc_demod 1];
        end
       
    end
  BER1 = [BER1 sum(abs(data_ecc_demod - data_ecc))/length(data_ecc_demod)];

alpha_matrix = [[1 0 0 0]; [0 1 0 0]; [0 0 1 0]; [0 0 0 1]; [1 1 0 0]; [0 1 1 0]; [ 0 0 1 1]; [1 1 0 1]; [1 0 1 0]; [0 1 0 1]; [1 1 1 0]; [0 1 1 1]; [1 1 1 1]; [1 0 1 1]; [1 0 0 1]];
alpha3_matrix = [[1 0 0 0]; [ 0 0 0 1]; [0 0 1 1]; [0 1 0 1]; [1 1 1 1]];
alpha3_matrix = [alpha3_matrix;alpha3_matrix;alpha3_matrix];
data_demod = [];
for k = 1:15:length(data_ecc_demod)
    %data_ecc_demod(1:15)
    %data_ecc_demod(2) = 1;
    %data_ecc_demod(5) = 1;
    %data_ecc_demod(7) = 1;
    data_temp = data_ecc_demod(k:k+14);
    s1 = mod(data_temp*alpha_matrix,2);
    s3 = mod(data_temp*alpha3_matrix,2);
    p1 = -1;
    p3 = -1;
    for i = 1:15
        if s1 == alpha_matrix(i,:)
            p1 = i - 1;
        end
        if s3 == alpha_matrix(i,:)
            p3 = i-1;
        end
    end
    error1 = -1;
    error2 = -1;
    %p1,p3 are the powers of alpha, of s1 and s3
    if p1==-1 && p3==-1
    %implies no error. Pass along decoded vector as is.

    elseif p1==-1
            %Error detected but can not be corrected. 
    else
        %Error detected.
        c1 = s1;
        IMP = mod(p1*3,15);
        IMS = mod(s3 + alpha_matrix(IMP+1,:),2);
        temp = 0;
        if IMS == [0 0 0 0]
            %Only single error, at location p1+1
            error1 = p1+1;
            temp = 0;
            c2 = IMS;
        else
            %More than one error. Must be found by using for loop, and putting
            %in values for A(x)
            for i = 1:15
             if IMS == alpha_matrix(i,:)
                temp = i - 1;
              end
            end
            c2 = alpha_matrix(mod(temp - p1,15)+1,:);
            %FOR loop to iterate over x in A(x)
            for i = 1:15

                x2 = alpha_matrix(mod((i-1).*2,15)+1,:);
                x1 = alpha_matrix(mod(p1+i-1,15)+1,:);
                x0 = c2;
                Xeq = mod(x2 + x1 + c2,2);
                if Xeq == [0 0 0 0]
                    if error1 == -1
                        error1 = i;
                    elseif error2 == -1
                        error2 =i;
                    else
                        break;
                    end
                end

            end
            %At end of for loop, error1 and error2 will have locations of error. 
            %Simply add 1 mod 2, to that location, and we will have the
            %ECC version of the demodulated data
            

        end
    end
    if error1 ~= -1
        data_temp(error1) = mod(data_temp(error1)+1,2);
    end
    if error2 ~= -1
        data_temp(error2) = mod(data_temp(error2)+1,2);
    end
    data_demod = [data_demod data_temp(1:7)];
end
SNR;
BER = [BER sum(abs(data_demod - data))/length(data)];
end


bit_count = 10000;

%Range of SNR over which to simulate
SNR = 0: 1: 40;

% Start the main calculation loop
for aa = 1: 1: length(SNR)
    
    % Initiate variables
    T_Errors = 0;
    T_bits = 0;
    
    % Keep going until you get 100 errors
    while T_Errors < 100
    
        % Generate some random bits
        uncoded_bits  = round(rand(1,bit_count));

        % BPSK modulator
        tx = -2*(uncoded_bits-0.5);
    
        % Noise variance
        N0 = 1/10^(SNR(aa)/10);
        
        % Rayleigh channel fading
        h = 1/sqrt(2)*[randn(1,length(tx)) + j*randn(1,length(tx))]; 

        % Send over Gaussian Link to the receiver
        rx = h.*tx + sqrt(N0/2)*(randn(1,length(tx))+i*randn(1,length(tx)));
        
%---------------------------------------------------------------

        % Equalization to remove fading effects. Ideal Equalization
        % Considered
        rx = rx./h;
        
        % BPSK demodulator at the Receiver
        rx2 = rx < 0;
    
        % Calculate Bit Errors
        diff = uncoded_bits - rx2;
        T_Errors = T_Errors + sum(abs(diff));
        T_bits = T_bits + length(uncoded_bits);
        
    end
    % Calculate Bit Error Rate
    BER2(aa) = T_Errors / T_bits;
    disp(sprintf('bit error probability = %f',BER2(aa)));

end

SNR = 0:1:40
figure;
semilogy(SNR,BER,'--')
hold on;
xlabel('SNR (dB)');
ylabel('BER');
title('SNR Vs BER plot for BPSK Modualtion in Rayleigh Channel');
semilogy(SNR,BER2,'or','LineWidth',2);
legend('BCH Encoded','Unencoded');

