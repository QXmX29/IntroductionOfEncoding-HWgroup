function dePSK = dePSK(A ,efficiency)
%PSK解映射
%efficiency为效率

a = angle(A);
dePSK = [];
for i = 1 : length(A)
    if (efficiency == 1/2)%QPSK
        if (a(i)<pi/2&&a(i)>=0)
            dePSK =[dePSK 1 1];
        elseif(a(i)<pi&&a(i)>=pi/2)
            dePSK =[dePSK 0 1];
        elseif(a(i)>=-pi&&a(i)<-pi/2)
            dePSK =[dePSK 0 0];
        else
            dePSK =[dePSK 1 0];
        end
        
    else%即1/3效率对应8PSK
        if (a(i)<pi/4&&a(i)>=0)
            dePSK =[dePSK 1 1 1];
        elseif(a(i)<pi/2&&a(i)>=pi/4)
            dePSK =[dePSK 1 1 0];
        elseif(a(i)>=pi/2&&a(i)<pi*3/4)
            dePSK =[dePSK 0 1 0];
        elseif(a(i)>=pi*3/4&&a(i)<pi)
            dePSK =[dePSK 0 1 1];
        elseif(a(i)<-3*pi/4&&a(i)>=-pi)
            dePSK =[dePSK 0 0 1];
        elseif(a(i)<-pi/2&&a(i)>=-pi*3/4)
            dePSK =[dePSK 0 0 0];
        elseif(a(i)>=-pi/2&&a(i)<-pi/4)
            dePSK =[dePSK 1 0 0];
        else
            dePSK =[dePSK 1 0 1];
        end
    end
end