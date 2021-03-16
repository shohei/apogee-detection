clear; close all;
A=1;b=1;c=1;
Q=1;R=2;
N=300;
v=randn(N,1)*sqrtm(Q);
w=randn(N,1)*sqrtm(R);

x=zeros(N,1); y=zeros(N,1);
y(1)=c'*x(1,:)'+w(1);
for k=2:N
   x(k,:)=A*x(k-1,:)'+b*v(k-1);
   y(k)=c'*x(k,:)'+w(k);
end

xhat=zeros(N,1);
P=0;xhat(1,:)=0;
for k=2:N
   [xhat(k,:),P,G] = kf(A,b,0,c,Q,R,0,y(k),xhat(k-1,:),P); 
end

figure(1); clf;
plot(1:N,y,'k:',1:N,x,'r--',1:N,xhat,'b-');
xlabel('No. of samples');
legend('measured','true','estimate');

function [xhat_new,P_new,G] = kf(A,B,Bu,C,Q,R,u,y,xhat,P)
  xhat = xhat(:); u=u(:); y=y(:);
  xhatm = A*xhat + Bu*u;
  Pm = A*P*A' + B*Q*B';
  G = Pm*C/(C'*Pm*C+R);
  xhat_new = xhatm+G*(y-C'*xhatm);
  P_new = (eye(size(A))-G*C')*Pm;  
end





