% The following code generates a double exponent waveform and determines
% the points that are used for the calculation of the waveform parameters
% Created by Behzad Kordi 30 Jan 2014.

clc
clear
close all

% alpha1 and alpha2 for a 1.2/5 us waveform
a1=1/(3.48e-6);
a2=1/(0.8e-6);

% delta t and start and end times
dt=0.001e-6;
tstart=-1e-6;
tend=7e-6;

% the waveform is 0 for negative time
t_neg=tstart:dt:-dt;
x_neg=zeros(size(t_neg));


% definition of the time vector and x(t) = e^(-alpha1.t)- e^(-alpha2.t)
t=0:dt:tend;
x=exp(-a1*t)-exp(-a2*t);
x100=max(x);

% 30%, 90%, and 50% values of the waveform
x90=x100*.9;
x30=x100*.3;
x50=x100*.5;

% times at which the waveform is 30%, 90% and 50% of its maximum
t30=fzero(@(t) (exp(-a1*t)-exp(-a2*t)-x30), 0.1e-6);
t90=fzero(@(t) (exp(-a1*t)-exp(-a2*t)-x90), 0.1e-6);
t50=fzero(@(t) (exp(-a1*t)-exp(-a2*t)-x50), 3e-6);

% the slope of the line
m=(x90-x30)/(t90-t30);

% virtual origin
t0=-x90/m+t90;

% time at which the line reaches the maximu of x(t)
t100=(x100-x90)/m+t90;

disp (['T1 = ' num2str(t100-t0)])
disp (['T2 = ' num2str(t50-t0)])

figure(1)
plot(t_neg,x_neg,'r',t,x,'r',t30,x30,'o',t50,x50,'o',t90,x90,'o',t0,[0],'o',t100,x100,'o')
hold on
line([t0 t30 t90 t100],[0 x30 x90 x100]);
axis([tstart tend -.1 x100*1.1])
grid

