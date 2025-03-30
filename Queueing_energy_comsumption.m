%% 排队模式下，AUV的能耗
%输入：
%排队时间的期望 W
%C-AUV上浮速率 V_U
%C-AUV下潜速率 V_D
%C-AUV深度 H_A
%N-AUV排队功率 P_W


%输出：
%AUV+ROV能耗 E_sum_q


%% 函数定义
function [E_W,E_C] = Queueing_energy_comsumption(W,V_U,V_D,H_A,P_W,P_U,P_D)
E_C = UD_energy_comsumption(H_A,V_U,V_D,P_U,P_D);%C_AUV每次上浮能耗
%等待能耗
E_W = P_W * W;
