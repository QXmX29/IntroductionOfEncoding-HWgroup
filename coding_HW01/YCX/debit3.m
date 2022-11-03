function debit3 = debit3(a)
 %3 bits格雷解映射

    a = a*sqrt(21);%在bit3函数中进行过功率归一化，此处进行恢复
    thr = 1;%噪声可能的最大值
    debit3 = [];
    for i = 1 : length(a)
        if  (a(i)< 7+thr && a(i)>=7-thr) 
            debit3 = [debit3 0 0 0];
        elseif  (a(i)< 5+thr && a(i)>=5-thr)
            debit3 = [debit3 0 0 1];  
        elseif  (a(i)< 3+thr && a(i)>=3-thr)
            debit3 = [debit3 0 1 1];        
        elseif  (a(i)< 1+thr && a(i)>=1-thr)
            debit3 = [debit3 0 1 0]; 
        elseif  (a(i)< -1+thr && a(i)>=-1-thr)
            debit3 = [debit3 1 1 0]; 
        elseif  (a(i)< -3+thr && a(i)>=-3-thr)
            debit3 = [debit3 1 1 1]; 
        elseif  (a(i)< -5+thr && a(i)>=-5-thr)
            debit3 = [debit3 1 0 1]; 
        else
            debit3 = [debit3 1 0 0];
        end
    end  
end

