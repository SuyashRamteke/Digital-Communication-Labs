function out = BCH_Encoding(a)
gen = [1,1,1,0,1,0,0,0,1,0,0,0,0,0,0;0,1,1,1,0,1,0,0,0,1,0,0,0,0,0;0,0,1,1,1,0,1,0,0,0,1,0,0,0,0;0,0,0,1,1,1,0,1,0,0,0,1,0,0,0;1,1,1,0,0,1,1,0,0,0,0,0,1,0,0;0,1,1,1,0,0,1,1,0,0,0,0,0,1,0;1,1,0,1,0,0,0,1,0,0,0,0,0,0,1];
    out = a*gen;
    for i=1:length(out)
       if(mod(out(i),2)==0)
           out(i)=0;
       else
           out(i)=1;
       end
    end

