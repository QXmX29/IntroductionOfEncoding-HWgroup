function  v = channel(u, sigma)
%信道发送
%输入u为发送函数生成的复基带电平序列,sigma为高斯噪声标准差
%输出为接收端收到的复基带电平序列
    
    %高斯噪声叠加
    nin = randn(size(u));
    nin = nin/std(nin);
    nin = (nin-mean(nin))*sigma;%均值为0，标准差为sigma的高斯白噪声
    rbn = real(u) + nin;%同相分量
    
    nqn = randn(size(u));
    nqn = nqn/std(nqn);
    nqn = (nqn-mean(nqn))*sigma;%均值为0，标准差为sigma的高斯白噪声
    ibn = imag(u) + nqn;%正交分量
    
    v = rbn + 1i * ibn;
end