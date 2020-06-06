function [pnseq] = pnsq(G, m)
S = [1 zeros(1, m-1)];
N = 2^m-1;
pnseq = [];
for i=1:N
    pnseq = [pnseq S(1)];
    k = mod(sum(S.*G(1:m)), 2);
    S = circshift(S', -1)';
    S(m) = k;
end
pnseq = 2*pnseq-1;
end


