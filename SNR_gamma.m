%% 计算具有单位传输功率和单位带宽的信号的标称信噪比gamma
% fc单位是kHz，l是km
function [gamma,gamma_n] = SNR_gamma(l,fc)
k=1.5;
a_f = (0.11*(fc^2)/(1+fc^2)+44*(fc^2)/(4100+(fc^2))+2.75*10^(-4)*(fc^2)+0.003);%单位dB
a_f_n = db_2_normal(a_f);
A_f_n = (l^k) * (a_f_n^l);
A_f = k * 10*log10(l)+l*a_f;


%噪声系数
s=0.5;%船只扰动系数
w=0;%假设海风速度1m/s
N_t = db_2_normal(17-30*log10(fc));
N_s = db_2_normal(40+20*(s-0.5)+26*log10(fc)-60*log10(fc+0.03));
N_w = db_2_normal(50+7.5*sqrt(w)+20*log10(fc)-40*log10(fc+0.4));
N_th = db_2_normal(-15+20*log10(fc));


N_sum=N_t + N_s + N_w + N_th;

%dB转化常数
A_f_n = 10^(0.1*A_f);
gamma_n = 1/(A_f_n*N_sum);
gamma = 10*log10(gamma_n)-44.78;