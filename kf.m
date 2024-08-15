function [xhat_new,P_new,G] = kf(A,C,Q,R,y,xhat,P)
xhat = xhat(:);y=y(:);
xhatm = A*xhat;
Pm = A*P*A' + Q;
G = Pm*C'*inv(C*Pm*C'+R);
xhat_new = xhatm+G*(y-C*xhatm);
P_new = (eye(size(A))-G*C)*Pm;
end
