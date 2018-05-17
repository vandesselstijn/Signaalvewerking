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