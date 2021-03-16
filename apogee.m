clear; close all;
warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames');

% data generation (raw data from Nakka's page)
% https://www.nakka-rocketry.net/A-100M.html 
% A-100M KNDX
% Extracted around apogee time (6s~9s)
% Interpolated using MATLAB polyfit function,
% so that sampling rate becomes 20ms

dat = readtable('flight_log.csv');
t = dat.Time_s_;
acc = dat.Acceleration_m_s2_;
p = dat.Pressure_Pa_;
altitude = dat.Altitude_m_;
dt=0.02; %20ms;
tn=t(1):dt:t(end);
%N=3 for accelerometer
pcoeff=polyfit(t,acc,3);
accn=polyval(pcoeff,tn);
%N=2 for pressure
pcoeff=polyfit(t,p,2);
pn=polyval(pcoeff,tn);
%N=2 for altitude
pcoeff=polyfit(t,altitude,2);
altituden=polyval(pcoeff,tn);

% System model definition
% Described in Application of the Kalman Filter to Rocket Apogee Detection
% by David W. Schultz, https://forum.arduino.cc/index.php?action=dlattach;topic=717425.0;attach=392768
N=length(tn); % data length for the interpolated data

A=[1 dt dt^2/2
   0 1 dt
   0 0 1];
C=[1 0 0
   0 0 1];
q = 1; % System noise
r1 = 2; %sensor noise (pressure sensor)
r2 = 1; %Sensor noise (accelerometer)
v=rand(N,3)*sqrtm(q);
w=randn(N,2)*sqrtm(diag([r1,r2]));
Qk = cov(v);
Rk = cov(w);

x=horzcat(altituden',accn');
y=horzcat(altituden'+w(:,1),accn'+w(:,2));
xhat=zeros(N,3); %xhat(:,1)=y(:,1); xhat(:,3)=y(:,2);
gamma=100; P=gamma*eye(3);
xhat(1,:)=[0,0,0];
for k=2:N
   [xhat(k,:),P,G] = kf(A,0,0,C,Qk,Rk,0,y(k,:),xhat(k-1,:),P); 
end

figure(1); clf;
Ni=10;
plot(Ni:N,y(Ni:N,1),'k:',Ni:N,x(Ni:N,1),'r--',Ni:N,xhat(Ni:N,1),'b-');
xlabel('No. of samples');
legend('measured','true','estimate');
title('Altitude estimation by Kalman Filter');
big;

% figure(2); clf;
% plot(1:N,y(:,1),'k:',1:N,x(:,1),'r--');
% xlabel('No. of samples');
% legend('measured','true');
% title('altitude');
% big;

% figure(3); clf;
% plot(1:N,y(:,2),'k:',1:N,x(:,2),'b--');
% xlabel('No. of samples');
% legend('measured','true');
% title('accelerometer');
% big;

function [xhat_new,P_new,G] = kf(A,B,Bu,C,Q,R,u,y,xhat,P)
  xhat = xhat(:); u=u(:); y=y(:);
  xhatm = A*xhat + Bu*u;
  Pm = A*P*A' + B*Q*B';
  G = Pm*C'*inv(C*Pm*C'+R);
  xhat_new = xhatm+G*(y-C*xhatm);
  P_new = (eye(size(A))-G*C)*Pm;
end

