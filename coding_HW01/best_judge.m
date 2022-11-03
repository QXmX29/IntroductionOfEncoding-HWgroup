function [bit_code] = best_judge(cplx_code, bit)
    if(bit==1)
        L = size(cplx_code, 1);
        bit_code=zeros(L,1);
        for ii=1:L
            if(cplx_code(ii,1)^2+cplx_code(ii,2)^2>(1-cplx_code(ii,1))^2+(1-cplx_code(ii,2))^2)
                bit_code(ii)=1;
            else
                bit_code(ii)=0;
            end
        end
    elseif bit==2
        L = 2*size(cplx_code, 1);
        bit_code=zeros(L,1);
        for ii=1:L/2
            if(cplx_code(ii,1)>0)
                bit_code(2*ii-1)=1;
            else
                bit_code(2*ii-1)=0;
            end
            if(cplx_code(ii,2)>0)
                bit_code(2*ii)=1;
            else
                bit_code(2*ii)=0;
            end
        end
    else%bit==3
        cplx_code=cplx_code(:,1)+1j*cplx_code(:,2);
        a = angle(cplx_code);
        bit_code = [];
        for i = 1 : length(cplx_code)%8PSK
            if (a(i)<pi/4&&a(i)>=0)
                bit_code =[bit_code;1; 1; 1];
            elseif(a(i)<pi/2&&a(i)>=pi/4)
                bit_code =[bit_code; 1; 1; 0];
            elseif(a(i)>=pi/2&&a(i)<pi*3/4)
                bit_code =[bit_code; 0; 1; 0];
            elseif(a(i)>=pi*3/4&&a(i)<pi)
                bit_code =[bit_code; 0; 1; 1];
            elseif(a(i)<-3*pi/4&&a(i)>=-pi)
                bit_code =[bit_code; 0; 0; 1];
            elseif(a(i)<-pi/2&&a(i)>=-pi*3/4)
                bit_code =[bit_code; 0; 0; 0];
            elseif(a(i)>=-pi/2&&a(i)<-pi/4)
                bit_code =[bit_code; 1; 0; 0];
            else
                bit_code =[bit_code; 1; 0; 1];
            end
        end
    end
end

