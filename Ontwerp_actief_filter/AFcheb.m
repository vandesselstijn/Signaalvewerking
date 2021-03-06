%Stijn Van Dessel
%Ontwerp Butterworth filter
%Specificaties
fc = 2000; %hz
fs = 6200; %hz
K  = 3;    %3dB
K   = 10^(K/20);    % dec
As = 40;   %db
Ap = 3;    %db

[n,Wn] = cheb1ord(fc*2*pi,fs*2*pi,Ap,As,'s')
fn = Wn/(2*pi)

[T,N] = cheby1(n,Ap,Wn,'s')

filter = tf(T,N)
filter = K*filter

figure(1);
bode(filter);
figure(2);
step(filter);
figure(3);
pzmap(filter);
axis equal  %punten liggen nu mooi op een cirkel

trappen = zpk(filter)
[z, p, k] = zpkdata(trappen, 'v')

[wn, zeta] = damp(filter)

zeta_1ste_orde  = zeta(1)
zeta_2de_orde = zeta(2)

wn_1ste_orde  = wn(1)
wn_2de_orde = wn(2)

q_1ste_orde  = 1/(2*zeta_1ste_orde)
q_2de_orde = 1/(2*zeta_2de_orde)

% Bode Diagram
%      s^2     s^1        s^0
H_N_1 = 1                           % numerator
H_D_1 = [(1/wn_1ste_orde) 1]        % denomerator

%      s^2     s^1        s^0
H_N_2 = K*[0 0 1]                                                           % numerator
H_D_2 = [(1/wn_2de_orde)^2 ((1/q_2de_orde)*(1/wn_2de_orde)) 1]        % denomerator

H_1 = tf(H_N_1,H_D_1)
H_2 = tf(H_N_2,H_D_2)

figure(1)
hold on;
bode(H_1);
bode(H_2);
figure(2)
hold on;
step(H_1);
step(H_2);
figure(3)
hold on;
pzmap(H_1);
pzmap(H_2);

% SYNTHESIS 1ste orde
% =========

% Ontwerpvgl
C = 1;
R = 1/wn_1ste_orde;

% impedance scaling
ISF = 10^8;
C = C/ISF
R = R*ISF

% CHECK1: fn  (specification vs components)
wnc = 1/(R*C)
fnc  = wnc/(2*pi)

% CHECK2: transfer function
H_N1c = [0 1];
H_D1c = [R*C 1];
H_1c = tf(H_N1c, H_D1c);

figure(4);
hold on;
bode(H_1);
bode(H_1c);


% SYNTHESIS 2de orde (Bquad)
% =========

C1 = 1
R1 = 1/(K*wn_2de_orde)
R2 = q_2de_orde/wn_2de_orde
R3 = 1/wn_2de_orde
R4 = R3

%scaling
ISF= 10^8
C1 = C1/ISF
R1 = R1*ISF
R2 = R2*ISF
R3 = R3*ISF
R4 = R4*ISF

% CHECK 1: fn and Qz (specification vs components)

kc   = R3/R1
kcdb = mag2db(kc)
wnc  = 1/R3
fnc  = wnc / (2*pi)
Qzc  = R2/R3

% CHECK2: transfer function (specification vs components)
H_N2c = kc*[0 0 (1/(R3*R4*C1^2))];
H_D2c = [1 1/(R2*C1) 1/(R3*R4*C1^2)];
H_2c = tf(H_N2c, H_D2c);

figure(5);
hold on;
bode(H_2);
bode(H_2c);

H_c = H_1c*H_2c;
figure(6);
hold on;
bode(filter);
bode(H_c);
bode(H_1c);
bode(H_1); 
bode(H_2c);
bode(H_2);

tilefigs;
