function [h_BER, s_BER] = task01(TL, crc_code, n40_0, snr_dB)
    % task01: 前n40_0不编码 后n40_1使用1/2效率不收尾卷积编码 均采用2-bit映射
    % h40: 采用了硬判决译码方式
    % s40: 采用了软判决译码方式
    T = 5;
    N = size(crc_code, 2);
    A_2 = [1 1 0 1; 1 1 1 1]';
    % 映射矩阵
    Mmap2 = [ -1 -1;    -1  1;    1 -1;    1  1 ];
    
    L = TL/5;
    BER = repmat(snr_dB*0, [2 1]);          % 误码率记录: 硬;软
    for i=1:length(snr_dB)
        % 映射参数按照snr与mbit进行配置
        snr = 10^(snr_dB(i)/10);
        Mmap = sqrt(snr/2)*Mmap2;
        if(n40_0==0)
            tl40_c00_m2 = [];
        else                                           % 前n40_0不编码直接采用2-bit映射
            tl40_c00_m2 = mapping(crc_code(1:n40_0), 0, 2, Mmap);
        end
        tl40_c2n_m2 = mapping(conv_encode(crc_code(n40_0+1:end), A_2, 0), 0, 2, Mmap);
                                                        % 后n40_1使用1/2效率不收尾卷积编码并采用2-bit映射
        u40 = [tl40_c00_m2, tl40_c2n_m2];
        v40 = channel(u40, T, L);               % 复电平通过信道
        bit40 = mapping(v40, 1, 2, Mmap);   % 接收得到的复电平映射回比特流
        s40 = [bit40(1:n40_0) viterbi(v40(:, (n40_0/2+1):end), A_2, 0, "soft", Mmap)];
                                                        % 前n40_0直接得出 后面部分软判决译码
        h40 = [bit40(1:n40_0) viterbi(bit40((n40_0+1):end), A_2, 0, "hard", Mmap)];
                                                        % 前n40_0直接得出 后面部分硬判决译码
        BER(1,i)=sum(abs(h40-crc_code))/N;
        BER(2,i)=sum(abs(s40-crc_code))/N;
    end
    h_BER = BER(1, :);
    s_BER = BER(2, :);
end

