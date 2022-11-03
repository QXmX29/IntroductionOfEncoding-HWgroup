function [bit_error, block_error] = use(begin, CRC_enable, conv_enable, efficiency, tail, bit, sigma, M, decision_mode, starmap, error_pattern)
%use函数可以通用，作为各种编码条件的基本生成函数
% bit_error 译码误比特率
% block_error CRC判决误块率
% begin 最初的数据（如用randi生成的）
% CRC_enable 是否添加CRC（1为添加，0为不添加）
% conv_enable 是否使用卷积（1为使用，0为不使用）
% efficiency 编码效率（1/2或1/3）
% tail 是否收尾（1为收尾，0为不收尾）
% bit 使用1/2/3bit映射方式
% sigma 高斯噪声标准差
% M 映射时不同情况对于的不同矩阵
% decision_mode 译码判决方式（hard或soft）
% starmap 是否画星座图（1为画星座图）
% error_pattern 是否画误码图案（1为画误码图案）

%CRC
if(CRC_enable == 1)
    code = CRC(begin);
else
    code = begin;
end

%卷积
if(conv_enable == 1)
    code_1 = conv_encode(code, efficiency, tail);
else
    code_1 = code;
end

%映射
u = mapping(code_1,efficiency,bit);

%信道
v = channel(u, sigma);

%解映射
code_2 = demapping(v,bit,efficiency);

%译码
if(efficiency == 1/2)
    A = [1 1 0 1          % 1/2效率
     1 1 1 1]';
else 
    A = [1 0 1 1          % 1/3效率
     1 1 0 1
     1 1 1 1]';
end
finnal = viterbi(code_2, A, tail, decision_mode, M);
bit_error = length(finnal);%误比特率


%CRC误块统计
if(CRC_enable == 1)
[msg, block_error, idx] = crc_judge(finnal);
end

%星座图
if(starmap == 1)
    %发端
    figure;
    plot(real(u),imag(u),'b.');
    title('发端复基带星座图');
    xlim([-2,2]);
    ylim([-2,2]);
    %收端
    figure;
    plot(real(v),imag(v),'b.');
    title('收端复基带星座图');
    xlim([-2,2]);
    ylim([-2,2]);
end

%误码图案
if(error_pattern == 1)
    figure;
    stem(abs(begin-finnal));
end
end