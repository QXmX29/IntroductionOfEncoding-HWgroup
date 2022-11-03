function [output] = mapping(input, dir, bit, M)
    % bit_code <=dir=> cplx_code
    % dir: 0-bit2cplx, 1-cplx2bit
    % M: (2^n)×2 (mapping matrix)
    if(nargin<4)
        if(nargin<3 || bit==1)
            bit = 1;
            M = [  -sqrt(2)  0;    sqrt(2)  0 ];
        elseif bit==2
            M = [ -1 -1;    -1  1;    1 -1;    1  1 ];
        else 
            M=[cos(pi/8*[-5,-7,5,7,-3,-1,3,1]'),sin(pi/8*[-5,-7,5,7,-3,-1,3,1]')];
        end
    end
    
    if(dir==0)
        % bit_code: 1×N
        bit_code = input;
        N = size(bit_code, 2);
        b = round(log(size(M, 1))/log(2));
        p = (2.^[(b-1):-1:0])';
        bit_code = reshape(bit_code, [b, N/b])';
        bit_code = bit_code*p+1;
        % cplx_code: 2×N
        cplx_code = M(bit_code, :)';
        output = cplx_code;
    else
        output = best_judge(input', bit)';
    end
end

