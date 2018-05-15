% Bridged T-network
% Analysis & Synthesis
% Author: Stijn Van Dessel
% Date: 25/04/2018
% ================================

clear all;

% SPECIFICATION
% =============

fn  = 1000;      % natural frequency
K   = 2;         % gain (DC)
Hfn = 1/20;      % amplituderesponse @ fn = H(fn)
Qp  = 4;         % Kwaliteitfactor polen

% Natural Pulsation & Quality factor for given specification H(fn)
% ----------------------------------------------------------------

% zero
wnz = 2*pi*fn
Qz = Qp
zetaz = 1 / (2*Qz)

% pole
wnp = wnz
zetap = zetaz

% ANALYSIS BASED ON SYSTEMPARAMETERS (K,wn,Q)
% ===========================================
% Transfer Function H
% -------------------
% H = H_N / H_D

%      s^2     s^1        s^0
H_N = -K*[0 1/(Qz*wnz) 0]          % numerator
H_D = [1/wnp^2 1/(Qp*wnp) 1]       % denomerator

% H_N = [1 2*zetaz*wnz wnz^2]
% H_D = [1 2*zetap*wnp wnp^2]

H = tf(H_N,H_D)

% Pole-zero Plot
% --------------

figure(3)%,clf
hold on;
pzmap(H);
axis equal;  
% data units are the same in every direction
% hold on en no clf: multiple runs with different H(fn) values
% will be ploted in the same figure 
% clear all figures with "close all" in command window!

% Bode Diagram
% ------------

figure(4)%,clf;
hold on;
opts = bodeoptions;
opts.FreqUnits = 'Hz';
bode(H,opts);
% use in figure: right mouse - properties - units - frequency - Hz

% Step & Impuls reponse
% ---------------------

figure(5)%,clf;
hold on;
step(H);

% zoom (sets the simulation horizon explicitly)
figure(6)%,clf;
hold on;
Tfinal = 0.001;
dt = Tfinal /100;
t = 0:dt:Tfinal;
step(H,t);

figure(7)%,clf;
hold on;
impulse(H)


% SYNTHESIS
% =========

% Design Equations --> R1 = R2 = R3 = R4 = R6

C2 = (Qp/K)^2
R  = (1/(C2*wnp^2))^0.5
R5 = K*R
C1 = 1
% Impedance Scaling

ISF= 10^8
C1 = C1/ISF
C2 = C2/ISF
R  = R*ISF
R5 = R5*ISF

R1 = R;
R2 = R;
R3 = R;
R4 = R;
R6 = R;

% CHECK 1: fn and Qz (specification vs components)

kc = R5/R1
wnpc = (R3/(C1*C2*R2*R4*R6))^0.5
fnc = wnpc / (2*pi)
Qzc = (R3*R5)/((C1*R2*R4*R6)*wnpc)

% CHECK 2: transfer function (specification vs components)
%       s^2     s^1           s^0
H_Nc = -(R5/R1)*[0 (C1*R2*R4*R6)/(R3*R5)      0];   % numerator (with components)
H_Dc = [(C1*C2*R2*R4*R6)/R3 (C1*R2*R4*R6)/(R3*R5) 1];   % denomerator (with components)

Hc = tf(H_Nc,H_Dc);  % transferfunction based on components

figure(8) %
clf;
opts = bodeoptions;
opts.FreqUnits = 'Hz';
bode(H,opts);
hold on;
bode(H, '-b');   % H based specification
bode(Hc,':r');   % H based on components

tilefigs