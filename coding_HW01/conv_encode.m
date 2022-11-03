function [y] = conv_encode(x, A, tail)
    % y: 1×n
    % x: 1×k
    % A = [A0; A1; A2; ...]: (m+1)×(n/k)
    % tail \in {0, 1}
    
    % e.g.(5,7)code:
    % A0=(1,1); A1=(0,1); A2=(1,1);
    % A = [1 1
    %      0 1
    %      1 1];
    % A = [1 0 1    % 05
    %      1 1 1]'  % 07
    
    if(tail)
        T = zeros(1, size(A, 1)-1);
        x = repmat([x T], [1 1]);
    end
    N = size(x, 2);
    xa = zeros(1, size(A, 1));
    y = [];
    for i=1:N
        xa = repmat([x(i) xa(1:(size(A, 1)-1))], [1 1]);
        y = repmat([y xa*A], [1 1]);
    end
    y = mod(y, 2);
end

