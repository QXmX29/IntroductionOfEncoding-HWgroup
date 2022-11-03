function bit2 = bit2(a)
%2 bits格雷映射表

b = num2str(a);
switch b
    case'1  0'
        bit2 = 1;
    case'1  1'
        bit2 = 3;
    case'0  1'
        bit2 = -3;
    case'0  0'
        bit2 = -1;
end
    bit2 = bit2 /sqrt(5);%功率归一化
end