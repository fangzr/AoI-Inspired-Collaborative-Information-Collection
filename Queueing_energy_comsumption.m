%% �Ŷ�ģʽ�£�AUV���ܺ�
%���룺
%�Ŷ�ʱ������� W
%C-AUV�ϸ����� V_U
%C-AUV��Ǳ���� V_D
%C-AUV��� H_A
%N-AUV�Ŷӹ��� P_W


%�����
%AUV+ROV�ܺ� E_sum_q


%% ��������
function [E_W,E_C] = Queueing_energy_comsumption(W,V_U,V_D,H_A,P_W,P_U,P_D)
E_C = UD_energy_comsumption(H_A,V_U,V_D,P_U,P_D);%C_AUVÿ���ϸ��ܺ�
%�ȴ��ܺ�
E_W = P_W * W;
