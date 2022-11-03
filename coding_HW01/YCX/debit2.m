function debit2 = debit2(a)
%2 bits格雷解映射

    a = a * sqrt(5);%在bit2函数中进行过功率归一化，此处进行恢复
    thr = 1;%噪声可能的最大值
    debit2 = [];
    for i = 1 : length(a)
        if ((a(i)< 1+thr) && (a(i)>=1-thr))
            debit2 = [debit2 1 0];
        elseif ((a(i)< 3+thr) && (a(i)>=3-thr))
            debit2 = [debit2 1 1];
        elseif((a(i)< -3+thr) && (a(i)>=-3-thr))
            debit2 = [debit2 0 1];
        else
            debit2 = [debit2 0 0];
        end
    end
end