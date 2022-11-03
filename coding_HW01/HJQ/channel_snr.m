function v = channel_snr(u0,T,L,snr,casenum)

if casenum==1
    b=0;rho=0;
elseif casenum==2
    b=1;rho=1;
elseif casenum==3 
    b=0.7;rho=0.996;
elseif casenum==4
    b=0.3;rho=0.9;
end
sigma=sqrt(2/snr);
%scatterplot(u);
u = u0';
temp=zeros(L,2);
for ii=1:L
x=[ones(T,1)*u(ii,1) ones(T,1)*u(ii,2)]/sqrt(T);
y=channel_01(x(:,1)+1j*x(:,2),b,rho,sigma);
temp(ii,:)=[sum(real(y))/sqrt(T),sum(imag(y))/sqrt(T)];
end

%scatterplot(temp);

v=temp';
end