function [msg, rate, idx] = crc_judge(data, k, g)
    if(nargin<3)
        g = [1 1 0 0, 0 0 0 0, 0 0 0 1, 0 0 0 1];
        if(nargin<2)
            k = 200;
        end
    end
    m = size(g, 2)-1;
    n = k+m;
    num = 0;
    idx = [];
    msg = [];
    for i=1:n:size(data, 2)
        r = data(i:min(i+n-1, end));
        msg = repmat([msg r(1:k)], [1 1]);
        [~, s] = deconv(r, g);
        s = mod(s((end-m+1):end), 2);
        if(sum(s, 2)~=0)
            num = num+1;
            fst_idx = ((i-1)/n)*k+1;
            idx = repmat([idx fst_idx:(fst_idx+k-1)], [1 1]);
        end
    end
    rate = num/(size(msg,2)/k);
end

