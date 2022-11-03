function out=viterbi(input,conv_mat,tail,decision_mode,M)
% input为编码输入，若为软判决则为2xlength的double矢量，若为硬判决则为1xlength的0-1序列
% conv_mat为卷积码编码卷积系数，维度为 深度+1 x 1/效率
% tail为是否收尾，输入true为收尾，false为不收尾，默认不收尾
% decision_mode为判决方式，"soft"为软判决，"hard"为硬判决，默认硬判决
% M为软判决时使用的复数值-01序列映射矩阵，维度为 2^每符号bit数 x 2
% 例如，对于2bit每符号的情况，M矩阵每行分别为：
%   00对应的实部和虚部；01对应的实部和虚部；10对应的实部和虚部；11对应的实部和虚部
% 此外，请设置效率的倒数为每符号bit数的整数倍
    if (nargin>=4&&decision_mode=="soft")||size(input,1)==2
        decision_func=@soft_decision;
        nbit=log2(size(M,1));
    else
        decision_func=@hard_decision;
        M=[];
        nbit=1;
    end
    if nargin<3
        tail=0;
    end
    % 形成状态转移阵state_trans
    % 其左面的eff排对应输入0时卷积编码应有输出，右面的eff排对应输入1时卷积编码应有输出
    depth=size(conv_mat,1)-1;
    eff=size(conv_mat,2);
    unit_len=eff/nbit;
    state_trans=[zeros(2^depth,eff*2)];
    state_base=dec2bin([0:2^depth-1]',depth);
    state_base=state_base-'0';
    % 注意：在Viterbi算法中，最新的状态在右侧
    % 但在卷积码编码中，最新的状态应该与卷积系数矩阵第一行相乘，故这里需要将state翻转
    state_coeff1=fliplr([state_base,zeros(2^depth,1)]);
    state_trans(:,1:eff)=mod(state_coeff1*conv_mat,2);
    state_coeff2=fliplr([state_base,ones(2^depth,1)]);
    state_trans(:,eff+1:2*eff)=mod(state_coeff2*conv_mat,2);
    % 开始维特比算法
    prob_value=inf*ones(2^depth,size(input,2)/unit_len);
    prob_value(1,1)=0;
    % prob_value指示概率的数值，越小则代表概率越大，inf代表此时刻不可能处于该状态
    last_state=zeros(2^depth,size(input,2)/unit_len);
    % last_state记录取得最概然情况下的上一个状态
    for k=1:size(input,2)/unit_len
        real_code=input(:,(k-1)*unit_len+1:k*unit_len); 
        % 对于状态i，若其为偶数，则仅可能是由上一时序i/2或(gi+N)/2转移而来
        % 否则，则其为上一时序(i-1)/2或(i+N-1)/2转移而来
        % i取值是从0开始，下面的m序号取值从1开始，以便进行索引
        for m=1:2^(depth-1)
            if k>1
                prob_now=[decision_func(real_code,state_trans(m,1:eff),M),...
                        decision_func(real_code,state_trans(m+2^(depth-1),1:eff),M)];
                total_prob=prob_now+[prob_value(m,k-1),prob_value(m+2^(depth-1),k-1)];
                if total_prob(1)>total_prob(2)% 取概率指标小的那个
                    prob_value(2*m-1,k)=total_prob(2);
                    last_state(2*m-1,k)=m+2^(depth-1);
                else
                    prob_value(2*m-1,k)=total_prob(1);
                    last_state(2*m-1,k)=m;
                end

                prob_now=[decision_func(real_code,state_trans(m,eff+1:2*eff),M),...
                    decision_func(real_code,state_trans(m+2^(depth-1),eff+1:2*eff),M)];
                total_prob=prob_now+[prob_value(m,k-1),prob_value(m+2^(depth-1),k-1)];
                if total_prob(1)>total_prob(2)
                    prob_value(2*m,k)=total_prob(2);
                    last_state(2*m,k)=m+2^(depth-1);
                else
                    prob_value(2*m,k)=total_prob(1);
                    last_state(2*m,k)=m;
                end
            else 
                if m==1
                    prob_value(2*m-1,1)=decision_func(real_code,state_trans(m,1:eff),M);
                    last_state(2*m-1,1)=1;
                    prob_value(2*m,1)=decision_func(real_code,state_trans(m,eff+1:2*eff),M);
                    last_state(2*m,1)=1;
                else
                    prob_value(2*m-1,1)=inf;
                    last_state(2*m-1,1)=1;
                    prob_value(2*m,1)=inf;
                    last_state(2*m,1)=1;
                end
            end
        end
    end
    % 开始回溯求解
    if tail
        out=zeros(1,size(input,2)/unit_len);
        next_state=1;
        for k=size(input,2)/unit_len:-1:1
            out(1,k)=1-mod(next_state,2);
            % 如果下一状态i为双数状态，说明当前输入卷积码的是0
            % i对应的序号i+1模2为1，则输出为0，对应进入卷积码编码的输入；反之亦正确
            next_state=last_state(next_state,k);
        end
        out=out(1,1:end-depth);
    else
        out=zeros(1,size(input,2)/unit_len);
        [~,next_state]=min(prob_value(:,end));% 最后一个状态设为最终最概然（概率指标最小的）对应的状态序号
        for k=size(input,2)/unit_len:-1:1
            out(1,k)=1-mod(next_state,2);
            next_state=last_state(next_state,k);
        end
    end
end
function out=hard_decision(code,standard,~)
    out=sum(abs(code-standard));
end
function out=soft_decision(code,standard,M)
    bit=log2(size(M,1));
    standard_vec=zeros(2,size(code,2));
    % 求出标准0-1序列对应的复数序列
    for idx=1:size(code,2)
        index=bin2dec(char(standard(bit*(idx-1)+1:bit*idx)+'0'))+1;
        standard_vec(:,idx)=M(index,:)';
    end
    % 求点积
    out=sum(code.*standard_vec,"all");
    % 由于将概率指标最小化作为优化指标，而向量最似然本应以点乘值最大化为原则，故将out取反
    out=-out;
end