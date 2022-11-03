function out=interweave(input,is_decoding,block_size)
    % 输入input为0-1码流 1 x len
    % 如果编码前进行交织，则第二个参数为0；如果是编码后进行交织，则第二个参数为1
    % block_size为每块的长度，默认为1
    % 前面的(floor(sqrt(len)))^2进行ZigZag交织，剩余的项（如果有）接在扫描/逆扫描后的尾部
    if nargin<3
        block_size=1;
    end
    len=size(input,2);
    padding=mod(block_size-len,block_size);
    % 如果分块后有余下的项，则补0
    if padding~=0
        input=[input,zeros(1,padding)];
    end
    % 先将编码分块，直接将各个块的码流化为string，从而构成string数组
    % 每个数组元素为单个block的代码（string格式）
    unit="NULL";
    num_block=size(input,2)/block_size;
    blocked=repmat(unit,[1,num_block]);
    for i=1:num_block
        blocked(i)=string(char(input(1,block_size*(i-1)+1:block_size*i)+'0'));
    end
    % 得到ZigZag扫描的方阵尺寸
    N=floor(sqrt(num_block));
    % 生成ZigZag扫描表
    row=1;col=1;idx=1;
    Zig_LUT=zeros([N^2,1]);
    out=repmat(unit,[1,num_block]);
    out(idx)=blocked(N*(col-1)+row);Zig_LUT(idx)=N*(col-1)+row;idx=idx+1;
    
    % flag = mod(N,2);    % 奇偶数扫描方式不大一样
    while row<N||col<N
        if row==1
            if col==N     % 抵达奇数模式左下角
                row=row+1;
            else
                col=col+1;
            end
            out(idx)=blocked(N*(col-1)+row);Zig_LUT(idx)=N*(col-1)+row;idx=idx+1;
            while col~=1&&row~=N % 第一次抵达奇数模式右侧
                col=col-1;row=row+1;
                out(idx)=blocked(N*(col-1)+row);Zig_LUT(idx)=N*(col-1)+row;idx=idx+1;
            end
        elseif row==N
            col=col+1;
            out(idx)=blocked(N*(col-1)+row);Zig_LUT(idx)=N*(col-1)+row;idx=idx+1;
            while col~=N
                col=col+1;row=row-1;
                out(idx)=blocked(N*(col-1)+row);Zig_LUT(idx)=N*(col-1)+row;idx=idx+1;
            end
        elseif col==1
            row=row+1;
            out(idx)=blocked(N*(col-1)+row);Zig_LUT(idx)=N*(col-1)+row;idx=idx+1;
            while row~=1
                col=col+1;row=row-1;
                out(idx)=blocked(N*(col-1)+row);Zig_LUT(idx)=N*(col-1)+row;idx=idx+1;
            end
        elseif col==N
            row=row+1;
            out(idx)=blocked(N*(col-1)+row);Zig_LUT(idx)=N*(col-1)+row;idx=idx+1;
            while row~=N
                col=col-1;row=row+1;
                out(idx)=blocked(N*(col-1)+row);Zig_LUT(idx)=N*(col-1)+row;idx=idx+1;
            end
        end
    end
    % 对于编码的情况，上述扫描过程已经经过了各个格，得到了输出；
    % 但对于解码的情况，需要按照ZigZag的查找表进行逆查找
    if is_decoding==1
%         Zig_idx = find(Zig_LUT);
%         Zig_LUT((Zig_idx(end)+1):end)=[];
%         out(Zig_LUT)=blocked(1:size(Zig_LUT,1));%N^2;
        out(Zig_LUT)=blocked(1:N^2);
    end
    % 查找/逆查找完毕后，将ZigZag扫描/逆扫描的剩余项（如果有）接在尾部
    if num_block>N^2
        out=[out(1:N^2),blocked(N^2+1:num_block)];
    end
    % 然后将string数组恢复为0-1序列的double值数组
    % 首先将1 x num_block的string数组变为1 x block_size x num_block的0-1 double数组
    out=double(char(out)-'0');
    % 再利用reshape化为1 x len的0-1 double数组，且顺序正确
    out=reshape(out,[1,num_block*block_size]);
    % 最后把padding去掉即可
    % 因为最后一个block绝对处于最后一个位置（无论是ZigZag结果还是有剩余项在尾部）
    % 所以直接去掉就可以
    if padding~=0
        out=out(1:len);
end

