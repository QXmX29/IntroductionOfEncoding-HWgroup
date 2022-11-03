function [mat] = Guass(m, n, mu, sigma_2)
    if(nargin<3)
        mu_g = 0;
        sigma_2_g = 1;
    else
        mu_g = mu;
        sigma_2_g = sigma_2;
    end
    mat = sqrt(sigma_2_g)*randn(m, n) + mu_g;
end

