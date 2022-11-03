function v = channel(u0,T,L)

%scatterplot(u);
u = u0';
temp=zeros(L,2);
for ii=1:L
=[ones(T,1)*u(ii,1) ones(T,1)*u(ii,2)]/sqrt(T);
y=level_channel(x,T,11);
temp(ii,:)=sum(y)/sqrt(T);
end

%scatterplot(temp);

v=temp';
end