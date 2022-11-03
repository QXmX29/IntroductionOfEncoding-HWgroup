function bit3 = bit3(a)
%3 bits格雷映射表
 b = num2str(a);
 
    switch b
        case '0  0  0'
        bit3 = 7 ;
        case '0  0  1'
        bit3 = 5 ;
        case '0  1  1'
        bit3 = 3 ;
        case '0  1  0'
        bit3 = 1 ;
        case '1  1  0'
        bit3 = -1 ;
        case '1  1  1'
        bit3 = -3 ;
        case '1  0  1'
        bit3 = -5 ;
        case '1  0  0'
        bit3 = -7 ;
    end
     bit3 = bit3 /sqrt(21);%功率归一化
    
end