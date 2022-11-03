function [y] = channel_01(x, b, pho, s_n)
%     b = 0;
%     pho = 1;
    N = size(x,2);
    if(nargin<4)
        sig_n = 4;
    else
        sig_n = s_n;
    end
    
    mu = 0;
    sigma_bz_2 = 0.5;
    sigma_n_2 = (sig_n^2)/2;
    z = Guass(1,N,mu,sigma_bz_2) + 1j*Guass(1,N,mu,sigma_bz_2);
    beta = z*sqrt(1-pho^2);
    beta(1) = beta(1) + Guass(1,1,mu,sigma_bz_2) + 1j*Guass(1,1,mu,sigma_bz_2);
    for i=2:N
        beta(i) = beta(i) + pho*beta(i-1);
    end
    a = sqrt(1-b^2) + b*beta;
    n = Guass(1,N,mu,sigma_n_2) + 1j*Guass(1,N,mu,sigma_n_2);
    y = a.*x+n;
end

