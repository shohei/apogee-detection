clear; close all;
% A=1;b=1;c=1;
T=0.02; %20ms;
A=[1 T T^2/2
   0 1 T
   0 0 1];
C=[1 0 0
   0 0 1];
!Q = 1; % System noise
R1 = 2; %Sensor noise
Qk=[0 0 0;
    0 0 0
    0 0 Q];
Rk=[R 0 0 
    0 0 0 
    0 0 R];
N=300;
v=randn(N,3)*sqrtm(Q);
w=randn(N,2)*sqrtm(R);

x=zeros(N,3); y=zeros(N,2);
% y(1)=c'*x(1,:)'+w(1);
% for k=2:N
%    x(k,:)=A*x(k-1,:)'+b*v(k-1);
%    y(k)=c'*x(k,:)'+w(k);
% end



xhat=zeros(N,1);
P=0;xhat(1,:)=0;
for k=2:N
   [xhat(k,:),P,G] = kf(A,0,0,C,Q,R,0,y(k),xhat(k-1,:),P); 
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





