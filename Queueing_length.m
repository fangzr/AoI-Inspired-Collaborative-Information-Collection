%% 平均排队的队长和等待时间计算函数
%输入：
%母函数多项式的系数向量 Q
%queue length M
%Vacation time T_UD
%AUV arrival rate Lambda_AUV
%输出：
%队长的期望值 E_L，排队时间期望W

function [E_L,W] = Queueing_length(Q,M,T_UD,Lambda_AUV)
%反转顺序
Q1 = flip(Q);
Q2 = Q1';
%构建多项式函数
syms x;
%求Q_M^(2)(1)
y = polyder(polyder(Q2));
Q_M_diff_1 = polyval(y,1);
%求Q_M(1)
Q_M_1 = polyval(Q2,1);
%求队长期望
L_Denominator = 1/(2*(M - Lambda_AUV * T_UD));
temp1 = (Lambda_AUV * T_UD)^2 + 2 * Lambda_AUV * T_UD * (M - Lambda_AUV * T_UD) - (Q_M_diff_1 + M * (M-1) * (1-Q_M_1));
E_L = L_Denominator * temp1;
W = E_L/Lambda_AUV + T_UD/2;






