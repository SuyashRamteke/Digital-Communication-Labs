function out = BCH_Decoding(in)
%GF(16)
a = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1;1,1,0,0;0,1,1,0;0,0,1,1;1,1,0,1;1,0,1,0;0,1,0,1;1,1,1,0;0,1,1,1;1,1,1,1;1,0,1,1;1,0,0,1];
firstsyn = zeros(1,4);
secondsyn = zeros(1,4);
in=round(in);
% Computing the syndromes S1 and S3
for i=1:15
    firstsyn=mod(firstsyn+a(i,:),2);
    secondsyn=mod(secondsyn+a(mod(3*(i-1),15)+1,:),2);
end       
firstsynindex = indexcheck(firstsyn);
secondsynindex = indexcheck(secondsyn);

%Computing lambda 1,2
rootsum = firstsyn;
if secondsynindex>firstsynindex
rootmult1 = secondsynindex - firstsynindex;
else
rootmult1 = 16-(firstsynindex-secondsynindex);
end
rootmult2 = mod((firstsynindex + firstsynindex),17);
for i=1:4
    rootmult(i) = mod((a(rootmult1,i) + a(rootmult2,i)),2);
end
rootmultindex = indexcheck(rootmult);
rootsumindex = firstsynindex;
%Error polynomial



for i=1:15;
    sum=0;
    p=0;
    for j=1:4        
    temp(j) = mod(a(mod(2*(i-1),15)+1,j) + a(mod(rootsumindex + i-1,15)+1,j) + a(rootmultindex,j),2);
    sum = sum + temp(j);
    end
    %Error Correction
    if(sum==0)
       % errorpos(p) = i;
       if in(i)==0
        in(i) = 1;
       else
        in(i)=0;
       end
        p=p+1;
    end
    if(p==1&&secondsynindex==16)
        
    end
    out=in;
end
end
