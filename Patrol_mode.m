%% �������ܣ�����AUVѲ����������
%���룺
%����·������ D
%һ��sector�Ĵ������ڵ��� K_n
%AUV���и߶� h
%ˮ�� H_A
%AUV�����ٶ�V_a
%�������ź�����Ƶ��fc��������Ҫ�Լ���
%�������������ݲ������� Lambda_data
%Ѳ����·����ʱ�� T_P
%�Ŷӵ�ʱ�� W
%ÿ��node����һ�����ݰ�����L_n
%���书�� P_T
%AUV��ͣ���� P_w
%AUV�˶����� P_M
%���չ��� P_R
%���� B
%�����
%Ѳ��������ʱ�� T_P �����ò��ɹ���
%Ѳ���������� E
%AUV�����ܹ���,���������ܺ� E_sum
%% ��������
function [T_P,E_tr,E_P,E_sum] = Patrol_mode(D,K_n,eta,h,H_A,V_a,fc,Lambda_data,T_M,W,L_n,P_T,P_w,P_M,P_R,B)
% ��ˮ���ŵ�����cap
[gamma,gamma_n] = SNR_gamma(h,fc);
% P_SL ת��Ϊ P_T
% ˮ��
temp1 = eta * P_T;
temp2 = 6.28 * H_A;
I_T = temp1 / temp2;
P_SL = I_T/(0.67*10^(-18));
cap = Channel_capacity_IoUT(P_SL,B,gamma);

%�󴫵����ݵĶ���ʱ��
temp1 = h * cap + Lambda_data * L_n * 1500 * (T_M + W);
temp2 = 1500 * (cap - Lambda_data * L_n * K_n);
T_tr = (temp1/temp2);%ע�����ǵ����������ڵ�Ĵ���ʱ��

%AUVѲ��+�ɼ���������ʱ��
T_P = K_n * T_tr + T_M;

%n-th sector���ݲɼ�����������
E_tr = K_n * (P_w + P_T + P_R) * T_tr;

%n-th sector AUVѲ������������
E_P = (D/V_a) * P_M;

E_sum = E_tr + E_P;








