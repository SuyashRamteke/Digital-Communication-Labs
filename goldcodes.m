clc;
m = [5 6];
G = [1 0 0 1 0 1 0 1 1 1 1 0 1 0;
     1 0 0 0 0 1 1 1 1 0 0 1 1 1];
for i=1:length(m)
    c11 = (pnsq(G(i, 1:7), m(i))==1);
    c12 = [];
    k = 3;
    v11 = [c11 c11 c11 c11 c11];
    for j=1:(2^m(i)-1)
        c12 = [c12 v11(k)];
        k = k+5;
    end
    X1 = 2*xor(c11, circshift(c12', 1)')-1;
    X2 = 2*xor(c11, circshift(c12', 2)')-1;
    figure;
    subplot(211);
    cor(X1, X1);
    title(['Auto-correlation of ',num2str(2^m(i)-1),' length goldcode']);
    xlabel('Time Index');
    ylabel('Amplitude');
    subplot(212);
    cor(X1, X2);
    title(['Cross-correlation of ',num2str(2^m(i)-1),' length goldcode']);
    xlabel('Time Index');
    ylabel('Amplitude');
end