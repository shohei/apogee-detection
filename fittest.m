clear; close all; clc;

dat = readtable('flight_log.csv');
x = dat.Time_s_;
y = dat.Acceleration_m_s2_;
y2 = dat.Pressure_Pa_;
y3 = dat.Altitude_m_;

% Choose N=3
figure(1);
for i=1:6
subplot(2,3,i);
pcoeff=polyfit(x,y,i);
xn=x(1):0.1:x(end);
yn=polyval(pcoeff,xn);
plot(x,y,'o');
hold on;
plot(xn,yn,'LineWidth',2);
title(sprintf('Polynomial fitting: N=%d',i));
end
title('fitting of accel');

% Choose N=2
figure(2);
for i=1:6
subplot(2,3,i);
pcoeff=polyfit(x,y2,i);
xn=x(1):0.1:x(end);
yn=polyval(pcoeff,xn);
plot(x,y2,'o');
hold on;
plot(xn,yn,'LineWidth',2);
title(sprintf('Polynomial fitting: N=%d',i));
end
title('fitting of pressure');

% Choose N=2
figure(3);
for i=1:6
subplot(2,3,i);
pcoeff=polyfit(x,y3,i);
xn=x(1):0.1:x(end);
yn=polyval(pcoeff,xn);
plot(x,y3,'o');
hold on;
plot(xn,yn,'LineWidth',2);
title(sprintf('Polynomial fitting: N=%d',i));
end
title('fitting of altitude');


