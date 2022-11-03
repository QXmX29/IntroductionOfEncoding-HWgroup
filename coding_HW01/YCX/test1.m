clear all;
close all;
clc;

%硬/软判，不同效率的误比特率与复电平信道信噪比的关系
%生成输入的数据
N = 20000;
begin = randi(2, 1, N)-1;
% 将两种效率对应的矩阵列出来方便选择
A_2 = [1 1 0 1          
     1 1 1 1]';
A_3 = [1 0 1 1          
     1 1 0 1
     1 1 1 1]';
snr_dB=-20:4:20;
BER=repmat(snr_dB*0,[4,1]);
for ii=1:length(snr_dB)
    snr=10^(snr_dB(ii)/10);
    T=5;
    bit=1;
    CRC=1;
    tail=1;
    %由于bit=1，据此选择映射时需要的矩阵
    x=sqrt(snr/2);
    M1= [  -sqrt(2)  0;    sqrt(2)  0 ];
    M=x*M1;
    error_pattern = 0;
    [bit_error_1, block_error_1] = use(begin, CRC, A_2, tail, bit, M, T, "hard", error_pattern);
    [bit_error_2, block_error_2] = use(begin, CRC, A_3, tail, bit, M, T, "hard", error_pattern);
    [bit_error_3, block_error_3] = use(begin, CRC, A_2, tail, bit, M, T, "soft", error_pattern);
    [bit_error_4, block_error_4] = use(begin, CRC, A_3, tail, bit, M, T, "soft", error_pattern);
    BER(1,ii)=bit_error_1;
    BER(2,ii)=bit_error_2;
    BER(3,ii)=bit_error_3;
    BER(4,ii)=bit_error_4;
end
figure;
semilogy(snr_dB,BER(1,:),snr_dB,BER(2,:),snr_dB,BER(3,:),snr_dB,BER(4,:));
legend('效率1/2-硬判','效率1/3-硬判','效率1/2-软判','效率1/3-软判')
xlabel('复电平信道信噪比（dB）');
ylabel('误比特率');
title('采用CRC的卷积码');
grid


%硬/软判，不同效率的误块率与复电平信道信噪比的关系
%{
N = 20000;
begin = randi(2, 1, N)-1;
% 将两种效率对应的矩阵列出来方便选择
A_2 = [1 1 0 1          
     1 1 1 1]';
A_3 = [1 0 1 1          
     1 1 0 1
     1 1 1 1]';
snr_dB=-20:4:20;
BER=repmat(snr_dB*0,[2,1]);
for ii=1:length(snr_dB)
    snr=10^(snr_dB(ii)/10);
    T=5;
    bit=1;
    CRC=1;
    tail=1;
    x=sqrt(snr/2);
    M1= [  -sqrt(2)  0;    sqrt(2)  0 ];
    M=x*M1;
    [symbol_error_1, bit_error_1, block_error_1] = use(begin, CRC, A_2, tail, bit, M, T, "hard", star_map, error_pattern)；
    [symbol_error_2, bit_error_2, block_error_2] = use(begin, CRC, A_3, tail, bit, M, T, "hard", star_map, error_pattern)；
    [symbol_error_3, bit_error_3, block_error_3] = use(begin, CRC, A_2, tail, bit, M, T, "soft", star_map, error_pattern)；
    [symbol_error_4, bit_error_4, block_error_4] = use(begin, CRC, A_3, tail, bit, M, T, "soft", star_map, error_pattern)；
    BER(1,ii)=block_error_1;
    BER(2,ii)=block_error_2;
    BER(3,ii)=block_error_3;
    BER(4,ii)=block_error_4;
end
figure;
semilogy(snr_dB,BER(1,:),snr_dB,BER(2,:),snr_dB,BER(3,:),snr_dB,BER(4,:));
legend('效率1/2-硬判','效率1/3-硬判','效率1/2-软判','效率1/3-软判')
xlabel('复电平信道信噪比（dB）');
ylabel('误块率');
title('采用CRC的卷积码');
grid；
%}