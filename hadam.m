function h = hadam(n)
n=log2(n);
h = 1;
for i=1:n
    h = [[h h];[h -h]];
end
