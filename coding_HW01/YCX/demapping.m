function v = demapping(u,bit,efficiency)
%电平解映射
%u为传入电平
%bit==1,2ASK;bit==2,PAM;bit==3,PSK

    if(bit == 1)
        v = real(u)<0;
    elseif(bit == 2)
        if(efficiency == 1/2)
            v = debit2(u);
        else
            v = debit3(u);
        end
    else
        v = dePSK(u ,efficiency);
    end
end