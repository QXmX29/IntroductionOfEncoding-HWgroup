function [output] = CRC(input, k, g)
    % g: g(x) 1×m, 0/1
    if(nargin<3)
        g = [1 1 0 0, 0 0 0 0, 0 0 0 1, 0 0 0 1];
        if(nargin<2)
            k = 200;
        end
    end
    m = size(g, 2)-1;
    output = [];
    sys = zeros(1, k+m);
    msg = [];
    crc = [];
    for i=1:k:size(input, 2)
        % k|size(input, 2)
        msg = repmat([input(i:min(i+k-1, end)) zeros(1, m)], [1 1]);
        [~, crc] = deconv(msg, g);
        crc = mod(crc((end-m+1):end), 2);
        sys = [msg(1:k) crc];
        output = repmat([output sys], [1 1]);
    end
end