function [y] = linear_encode(x)
    % 生成矩阵
    G = [ 0 1 0 1  0 1 0 1
            0 0 1 1  0 0 1 1
            0 0 0 0  1 1 1 1];
    
    y = [];
    for i=1:3:size(x,2)
        d = x(i:(i+2));
        c = mod(d*G, 2);
        y = repmat([y c], [1 1]);
    end
end


% x = [0 0 0, 1 0 0, 0 1 0, 1 1 0, 0 0 1, 1 0 1, 0 1 1, 1 1 1];
% y = linear_encode(x);
% y = reshape(y, 8, 8);

% x = [0 1 1 1  0 0 0 0   0 0 0 1  0 0 1 1   0 0 1 1  1 1 1 1];
% [org idx info] = linear_decode(x)