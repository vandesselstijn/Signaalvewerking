%Voorbeeld Butterworth filter
%Specificaties
fc = 1000; %hz
fs = 3100; %hz
K  = 2;
As = 40; %db
Ap = 3;  %db

[n,Wn] = buttord(fc*2*pi,fs*2*pi,Ap,As,'s')
fn = Wn/(2*pi)

[T,N] = butter(n,Wn,'s')

filter = tf(T,N)

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

zeta_1ste_orde  = zeta(3)
zeta_2de_orde_1 = zeta(1)
zeta_2de_orde_2 = zeta(5)

wn_1ste_orde  = wn(3)
wn_2de_orde_1 = wn(1)
wn_2de_orde_2 = wn(5)

q_1ste_orde  = 1/(2*zeta_1ste_orde)
q_2de_orde_1 = 1/(2*zeta_2de_orde_1)
q_2de_orde_2 = 1/(2*zeta_2de_orde_2)

% Bode Diagram
%      s^2     s^1        s^0
H_N_1 = 1                                      % numerator
H_D_1 = [(1/wn_1ste_orde) 1]        % denomerator

%      s^2     s^1        s^0
H_N_2 = K*[0 0 1]                     % numerator
H_D_2 = [(1/wn_2de_orde_1)^2 ((1/q_2de_orde_1)*(1/wn_2de_orde_1)) 1]        % denomerator

%      s^2     s^1        s^0
H_N_3 = K*[0 0 1]                     % numerator
H_D_3 = [(1/wn_2de_orde_2)^2 ((1/q_2de_orde_2)*(1/wn_2de_orde_2)) 1]        % denomerator


H_1 = tf(H_N_1,H_D_1)
H_2 = tf(H_N_2,H_D_2)
H_3 = tf(H_N_3,H_D_3)

figure(4)
hold on;
bode(H_1,opts);
bode(H_2,opts);
bode(H_3,opts);
bode(filter);