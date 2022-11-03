T=5;
mbit = 2;
snr=2;
% 映射参数按照snr与mbit进行配置
A=sqrt(snr/2);
Mmap1= [  -sqrt(2)  0;    sqrt(2)  0 ];
Mmap2 = [ -1 -1;    -1  1;    1 -1;    1  1 ];
Mmap3= sqrt(2)*[cos(pi/8*[-5,-7,5,7,-3,-1,3,1]'),sin(pi/8*[-5,-7,5,7,-3,-1,3,1]')];
if mbit==1
    Mmap=A*Mmap1;
elseif mbit==2
    Mmap=A*Mmap2;
else
    Mmap=A*Mmap3;
end