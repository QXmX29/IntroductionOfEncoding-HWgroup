close all
clear all
clc

snr=zeros(99);
err=zeros(99);
for a=1:100
A=a/10;
L=10000;

input=round(rand(L,1));
u=zeros(L/2,2);
for ii=1:L/2
    u(ii,1)=2*A*input(2*ii-1)-A;
    u(ii,2)=2*A*input(2*ii)-A;
end

v = channel(u',100,L/2)';

output=zeros(L,1);
for ii=1:L/2
    if(v(ii,1)>0)
        output(2*ii-1)=1;
    else
        output(2*ii-1)=0;
    end
    
    if(v(ii,2)>0)
        output(2*ii)=1;
    else
        output(2*ii)=0;
    end

end

snr(a)=10*log10(2*A*A);
err(a)=sum(abs(output-input))/L;
% S=0;
% N=0;
% for ii=1:L/2
%    S=u(ii,1)*u(ii,1)+u(ii,2) *u(ii,2)+S;
%    N=(v(ii,1)-u(ii,1))*(v(ii,1)-u(ii,1))+(v(ii,2)-u(ii,2))*(v(ii,2)-u(ii,2))+N;
% end
% 
% snr(a)=S/N;

end

plot(snr,err);