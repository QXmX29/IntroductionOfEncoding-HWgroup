function [out, wrg_idx, wrg_info] = linear_decode(code)
    % out: org_code(已尽最大可能纠错)
    % wrg_idx: 出错符号(3-bit)首位的序号，如第1~3位表示的符号出错，则记下1
    % wrg_info: 错误信息，size(wrg_idx,2)×9，每行对应各idx下的错误信息: ws(第一列)、e(2:9)
    % code: (8,3,4)-code
    
    % 监督矩阵 (校验矩阵)
    H = [ 0 1 1 1 0 0 0 0
            0 1 0 0 1 1 0 0
            0 0 1 0 1 0 1 0
            0 1 1 0 1 0 0 1
            1 0 0 0 0 0 0 0];
    % 记H=[h1, h2, ..., h8]
    % 观察到hi在5维线性空间中
    % 且h4,h6,h7,h8,h1构成全空间的一组标准正交基
    base_h = [4 6 7 8 1];
    
    org = [];
    wrg_idx = [];
    wrg_info = [];
    for i=1:8:size(code,2)
        r = code(i:(i+7));             % 接收码字
        s = mod(r*H', 2);            % 校正子
        e = zeros(1, size(H,2));     % 错误图案
        ws = sum(s, 2);               % w(s): 校正子的重量
        switch ws
            case 0
                % r为许用码字: e=0 (或e为许用码字)，很可能r是正确的，故在c中找对应
                e = zeros(1, size(H,2));
            case 1
                % 很可能w(e)=1, 即s=h4/6/7/8/1
                e(base_h(find(s~=0))) = 1;
            case 2
                if(s(5)==1)
                % 若含h1，则很可能w(e)=2，s为两个基的线性组合
                    e(base_h(find(s~=0))) = 1;
                else
                % 否则，既可为2个基的组合也可为某个基和h2/h3/h5的组合
                    e(base_h(find(s~=0))) = 1;
                    wrg_idx = repmat([wrg_idx ((i-1)/8)+1], [1 1]);
                    wrg_info = repmat([wrg_info; 2 e], [1 1]);
                end
            case 3
                if(s(4)==1&&s(5)==0)
                % 第4,5位为10: 同h2/h3/h5，很可能w(e)=1
                    if(s(3)==0)
                        e = [0 1 0 0  0 0 0 0];     % h2
                    elseif(s(2)==0)
                        e = [0 0 1 0  0 0 0 0];     % h3
                    else
                        e = [0 0 0 0  1 0 0 0];     % h5
                    end
                else
                % 否则，最小w(e)=3且对应的e不唯一确定：
                % 1) 若含h1(s(5)==1)则既可为h1+另2个基，也可为h1+另1基+h2/h3/h5
                % 2) 若不含h1(s(4:5)=[1 0])则既可为: h4+h6+h7，也可为: (h2/h3/h5) + (h4/h6/h7) + h8
                    e(base_h(find(s~=0))) = 1;
                    wrg_idx = repmat([wrg_idx ((i-1)/8)+1], [1 1]);
                    wrg_info = repmat([wrg_info; 3 e], [1 1]);
                end
            case 4
                % 若s(4:5)=[1 1]，则最小w(e)=2，0在前3位：s(1/2/3)=0与h1+h2/h3/h5一一对应
                if(s(4)==1&&s(5)==1)
                    switch find(s==0)
                        case 1
                            e = [1 1 0 0  0 0 0 0];
                        case 2
                            e = [1 0 1 0  0 0 0 0];
                        case 3
                            e = [1 0 0 0  1 0 0 0];
                    end
                else
                % 若s(4:5)=[1 0]，则最小w(e)=2对应的e不唯一确定：h2+h7 / h3+h6 / h5+h4
                % 若s(4)=0即s=[1 1 1 0 1]则w(e)>2，可证w(e)>=4: 4个基，或非基列+对应基+h8+h1
                    if(s(4)~=0)
                        e = [0 1 0 0  0 0 1 0];     % 默认为h2+h7
                    else
                        e = [1 0 0 1  0 1 1 0];     % 默认为4个基: h4+h6+h7+h1
                    end
                    wrg_idx = repmat([wrg_idx ((i-1)/8)+1], [1 1]);
                    wrg_info = repmat([wrg_info; 4 e], [1 1]);
                end
            case 5
                % h2/h3/h5+对应的2个基：至少有3种可能达到最小w(e)=3
                e = [1 1 0 0  0 0 1 0];             % 默认为h2+h7+h1
                wrg_idx = repmat([wrg_idx ((i-1)/8)+1], [1 1]);
                wrg_info = repmat([wrg_info; 5 e], [1 1]);
        end
        bits = c2bits(mod(r+e,2));
        org = repmat([org, bits], [1 1]);
    end
    out = org;
end

function bits = c2bits(c)
    % 许用码字集 (可通过输入提供——预先encode得到所有许用码字)
    C = [ 0 0 0 0  0 0 0 0
            0 1 0 1  0 1 0 1
            0 0 1 1  0 0 1 1
            0 1 1 0  0 1 1 0
            0 0 0 0  1 1 1 1
            0 1 0 1  1 0 1 0
            0 0 1 1  1 1 0 0
            0 1 1 0  1 0 0 1];
    INP = c*C';                 % 内积 inner product
    [~, idx] = max(INP);
    bits = double(dec2bin(idx-1)) - '0';
    bits = repmat([zeros(1,3-size(bits,2)) bits], [1 1]);
    bits = [bits(3), bits(2), bits(1)];
end
