clear; close all; clc;

dat = readtable('../flight_log.csv');
t = dat.Time_s_;
acc = dat.Acceleration_m_s2_;
p = dat.Pressure_Pa_;
altitude = dat.Altitude_m_;

dt=0.02; %20ms;

%N=3 for accelerometer
pcoeff=polyfit(t,acc,3);
tn=t(1):dt:t(end);
accn=polyval(pcoeff,tn);

%N=2 for pressure
pcoeff=polyfit(t,p,2);
tn=t(1):dt:t(end);
pn=polyval(pcoeff,tn);

%N=2 for altitude
pcoeff=polyfit(t,altitude,2);
tn=t(1):dt:t(end);
altituden=polyval(pcoeff,tn);


plot(tn,accn,'o');
hold on; 
yyaxis right;
plot(tn,pn,'o');
legend('acceleration','pressure');
big;



