function out=conv_send(input,eff,tail,bit_per_sym)
% 编卷积码并调制的函数
% input：输入原始码流
% eff：效率的倒数
% tail：是否收尾
% bit_per_sym：每符号比特数
    if eff==2
        A= [1 1 0 1          % 1/2效率
         1 1 1 1]';
    else
        A = [1 0 1 1          % 1/3效率
         1 1 0 1
         1 1 1 1]';
    end
    Mmap1= [  -1  0;    1  0 ];
    Mmap2 =1/sqrt(2)*[ -1 -1;    -1  1;    1 -1;    1  1 ];
    Mmap3=[cos(pi/8*[-5,-7,5,7,-3,-1,3,1]'),sin(pi/8*[-5,-7,5,7,-3,-1,3,1]')];
    if bit_per_sym==1
        Mmap=A*Mmap1;
    elseif bit_per_sym==2
        Mmap=A*Mmap2;
    else
        Mmap=A*Mmap3;
    end
    code_conv = conv_encode(input, A, tail);
    u_conv = mapping(code_conv, 0, bit_per_sym, Mmap);
    out = channel(u_conv, T, size(u_conv2, 2));
end