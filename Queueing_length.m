%% ƽ���ŶӵĶӳ��͵ȴ�ʱ����㺯��
%���룺
%ĸ��������ʽ��ϵ������ Q
%queue length M
%Vacation time T_UD
%AUV arrival rate Lambda_AUV
%�����
%�ӳ�������ֵ E_L���Ŷ�ʱ������W

function [E_L,W] = Queueing_length(Q,M,T_UD,Lambda_AUV)
%��ת˳��
Q1 = flip(Q);
Q2 = Q1';
%��������ʽ����
syms x;
%��Q_M^(2)(1)
y = polyder(polyder(Q2));
Q_M_diff_1 = polyval(y,1);
%��Q_M(1)
Q_M_1 = polyval(Q2,1);
%��ӳ�����
L_Denominator = 1/(2*(M - Lambda_AUV * T_UD));
temp1 = (Lambda_AUV * T_UD)^2 + 2 * Lambda_AUV * T_UD * (M - Lambda_AUV * T_UD) - (Q_M_diff_1 + M * (M-1) * (1-Q_M_1));
E_L = L_Denominator * temp1;
W = E_L/Lambda_AUV + T_UD/2;






