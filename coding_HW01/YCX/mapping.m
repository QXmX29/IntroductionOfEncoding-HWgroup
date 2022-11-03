function output = mapping(input,efficiency,bit)
%电平映射
%input为传入信号
%efficiency为效率
%bit==1,2ASK;bit==2,PAM;bit==3,PSK
if (efficiency==1/2)
    if (bit == 1)%2ASK
        output = 1 - input * 2;%因为使用ASK，所以进行双极性化处理
    elseif(bit == 2)%4PAM
        for k = 1:2:length(input)
            output((k+1)/2) = bit2(input(k:(k+1)));
        end
    elseif(bit == 3)%QPSK
        input = 2*input -1;%因为使用QPSK，所以进行双极性化处理
        k = 1:2:length(input);
        output((k+1)/2) = input(k)*sqrt(2)/2 + 1i*input(k+1)*sqrt(2)/2;%进行幅度归一化处理
    end
    
else
    if (bit == 1)%2ASK
        output = 1 - input * 2;%因为使用ASK，所以进行双极性化处理
    elseif(bit == 2)%8PAM
        for k = 1:3:length(input)
        output((k+2)/3) = bit3(input(k:(k+2)));
        end
    elseif(bit == 3)%8PSK
        input = 2*input -1;%因为使用QPSK，所以进行双极性化处理
        k = 1:3:length(input);
        output((k+2)/3) = input(k).*cos(pi/4-(input(k+2)*pi/8))+1i*input(k+1).*sin(pi/4-(input(k+2)*pi/8));%进行幅度归一化处理
    end
end