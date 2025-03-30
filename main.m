clc;
clear all;
close all;




% 仿真参数：(Lambda_data=1/60 s^-1，Lambda_AUV_seq=[0.58:0.04:0.94]./60)
V_U = 1 * 1852 / 3600;%C-AUV上浮速度
V_D = 2 * 1852 / 3600;%C-AUV下潜速度
V_a = 5*1852/3600;%AUV移动速度
H_A = 100;%AUV活动深度
% Lambda_AUV = 1/300;%N-AUV到达频率
Lambda_AUV_seq = [0.56:0.06:1.1]./60;
P_w = 0.2 * 1E3;%等待功率
P_U = 6 * 1E3;%上升功率
P_D = 6 * 1E3;%下潜功率
P_M = 2 * 1E3;%运动功率
T_UD = H_A * (1/V_U + 1/V_D);
T_U = H_A/V_U;
%根据预设路径长度和节点数目，算出AoI、能量损耗
K_n = 19;
h = 10 /1E3;%AUV在节点上方
fc = 25E3 /1E3;%声信号频率
B = 1E3;%3dB带宽为
D = 1000;%行驶距离
eta = 0.2;%转换效率
T_M = D/V_a;%AUV在巡逻路上消耗时间
Lambda_data = 0.6;%数据采集速度一分钟/次
P_T = 30 * 1E-3;%30mW的发射功率
P_R = 10 * 1E-3;%10mW的接收功率
L_n = 1024;%每次更新的包长
E_max_restriction = 1.692596984257934e+06;%平均能耗限制
M_Value = [4,5,0];
M_max = size(M_Value,2);
AUV_rate_max = size(Lambda_AUV_seq,2);
AoI_sum_1 = zeros(AUV_rate_max,M_max+2);
E_total = zeros(AUV_rate_max,M_max+2);
E_W = zeros(AUV_rate_max,M_max);
L_AUV_seq = zeros(AUV_rate_max,M_max);
W_seq = zeros(AUV_rate_max,M_max);
M_optimal_seq = zeros(AUV_rate_max,1);
%% we proposed architecture
% we proposed N-AUV在C-AUV排队模式
for i = 1:AUV_rate_max
Lambda_AUV = Lambda_AUV_seq(i);
M_optimal = min(ceil(3 * Lambda_AUV * T_UD),6);%计算最优M值
M_Value(M_max) = M_optimal;
M_optimal_seq(i) = M_optimal;
    for m=1:M_max
        M = M_Value(m);
        Q = zeros(M,1);
        tic
        if M > (Lambda_AUV * T_UD)
            Q =  Q_M_Cal(M,T_UD,Lambda_AUV);
            t =toc
            [L_AUV,W] = Queueing_length(Q,M,T_UD,Lambda_AUV);
            
            [E_W,E_UD] = Queueing_energy_comsumption(W,V_U,V_D,H_A,P_w,P_U,P_D);
        else
            L_AUV = inf;
            W = inf;
        end
        L_AUV_seq(i,m) = L_AUV;
        W_seq(i,m) = W;
        fprintf('Lambda_AUV_rate=%f ^(-1)；\n 排队容量M=%d；\n AUV排队长度期望%f 个；\n AUV等待时间期望%f s ；\n',1/Lambda_AUV,M,L_AUV,W);
        % we proposed N-AUV巡逻模式

        %巡逻消耗总时间 T_P ，就用泊松过程
        %sector数据采集所消耗能量 E_tr
        % sector AUV巡航所消耗能量 E_P
        %AUV消耗总功率,含传感器能耗 E_sum
        if M > (Lambda_AUV * T_UD)
            [T_P,E_tr,E_P,E_sum] = Patrol_mode(D,K_n,eta,h,H_A,V_a,fc,Lambda_data,T_M,W,L_n,P_T,P_w,P_M,P_R,B);
            fprintf('巡逻消耗总时间=%f s；\n数据采集所消耗能量=%f J；\n AUV巡航所消耗能量=%f J；\n AUV消耗总功率,含传感器能耗=%f J ；\n',T_P,E_tr,E_P,E_sum);
        end
        % we proposed architecture AoI
        A_0_min = D/((K_n+1)*V_a) + W + T_U;
        A_0_max = (D-50)/(V_a) + W + T_U;
        A_0 = 0.5*(A_0_min+A_0_max);
%         AoI_sum_1(i,m) = 0.5 * T_P + W + T_U;
        AoI_sum_1(i,m)=A_0+(K_n/2 * (T_UD + W));
        % we proposed architecture 排队加上浮消耗能量,排队+vacation期间AUV总能量(不含巡航功率)
        E_total(i,m) = E_P + E_W + E_UD/L_AUV;

    end
%% 纯AUV采集数据消耗能量&AoI
E_total(i,(M_max+1)) = E_P + E_UD; %和我们的架构相同条件时间段下，只考虑上浮过程能耗
% AoI_sum_1(i,M_max+1) = 0.5 * T_P + T_U;%没有排队过程% %9.27修改最新aoi定义
T_s = D/V_a + H_A*(1/V_U+1/V_D);
T_i_max = T_s - H_A/V_D - D/(20*V_a);
T_i_min = H_A/V_U + D/(20*V_a);

A_1 = 0.5 *(T_i_max+T_i_min);
 AoI_sum_1(i,M_max+1) = A_1 + 0.5 * (K_n) * T_s;
%% 考虑到AUV能量限制的单AUV的能耗&AoI
E_max_restriction = E_total(i,3)*1.5;
temp_E = E_max_restriction/E_total(i,(M_max+1));
E_total(i,(M_max+2)) = E_max_restriction ;
Nor_V = (temp_E);%E=kvs，和速度成正比
AoI_sum_1(i,M_max+2) = AoI_sum_1(i,M_max+1)/Nor_V;
end

% % 
% %% 讨论数据采样速率对AoI和能耗影响
% V_U = 1 * 1852 / 3600;%C-AUV上浮速度1 knot
% V_D = 2 * 1852 / 3600;%C-AUV下潜速度2 knot
% V_a = 5*1852/3600;%AUV移动速度5 knot
% H_A = 100;%AUV活动深度
% Lambda_AUV_seq = 70^(-1);
% P_w = 0.2 * 1E3;%等待功率是0.2kW
% P_U = 6 * 1E3;%上升功率是4kW
% P_D = 5 * 1E3;%下潜功率是2kW
% P_M = 2 * 1E3;%运动功率是2kW
% T_UD = H_A * (1/V_U + 1/V_D);
% T_U = H_A/V_U;
% %根据预设路径长度和节点数目，算出AoI、能量损耗
% K_n = 20;
% h = 10 /1E3;%AUV在节点上方20m
% fc = 25E3 /1E3;%声信号频率25kHz
% B = 1E3;%3dB带宽为1kHz
% D = 1000;%行驶距离1km
% eta = 0.2;%转换效率
% T_M = D/V_a;%AUV在巡逻路上消耗时间
% Lambda_data_seq = [0.01:0.05:0.51];
% Lambda_data_max = size(Lambda_data_seq,2);
% % Lambda_data = 1/60;%数据采集速度一分钟/次
% P_T = 30 * 1E-3;%30mW的发射功率
% P_R = 10 * 1E-3;%10mW的接收功率
% L_n = 1024;%每次更新的包长 bit
% E_max_restriction = 0.9;%平均能耗限制为0.82kW·h
% M_Value = [3,4,5,0];
% M_max = size(M_Value,2);
% 
% AUV_rate_max = size(Lambda_AUV_seq,2);
% AoI_sum_1 = zeros(AUV_rate_max,M_max+2);
% E_total = zeros(AUV_rate_max,M_max+2);
% 
% E_W = zeros(AUV_rate_max,M_max);
% L_AUV_seq = zeros(AUV_rate_max,M_max);
% W_seq = zeros(AUV_rate_max,M_max);
% 
% Lambda_AUV = 1/65;%这是H-AUV到达率
% M_optimal = ceil(6 * Lambda_AUV * T_UD);%计算最优M值
% M_Value(M_max) = M_optimal;
% 
% %% we proposed architecture
% % we proposed N-AUV在C-AUV排队模式
% for i = 1:Lambda_data_max
% Lambda_data = Lambda_data_seq(i);
%     for m=1:M_max
%         M = M_Value(m);
%         Q = zeros(M,1);
%         tic
%         Q =  Q_M_Cal(M,T_UD,Lambda_AUV);
%         t =toc
%         [L_AUV,W] = Queueing_length(Q,M,T_UD,Lambda_AUV);
%         L_AUV_seq(i,m) = L_AUV;
%         W_seq(i,m) = W;
%         [E_W,E_UD] = Queueing_energy_comsumption(W,V_U,V_D,H_A,P_w,P_U,P_D);
% 
%          fprintf('Lambda_data=%f ^(-1)；\n 排队容量M=%d；\n AUV排队长度期望%f 个；\n AUV等待时间期望%f s ；\n',1/Lambda_data,M,L_AUV,W);
%         % we proposed N-AUV巡逻模式
% 
%         %巡逻消耗总时间 T_P ，就用泊松过程
%         %sector数据采集所消耗能量 E_tr
%         % sector AUV巡航所消耗能量 E_P
%         %AUV消耗总功率,含传感器能耗 E_sum
%         [T_P,E_tr,E_P,E_sum] = Patrol_mode(D,K_n,eta,h,H_A,V_a,fc,Lambda_data,T_M,W,L_n,P_T,P_w,P_M,P_R,B);
%         fprintf('巡逻消耗总时间=%f s；\n数据采集所消耗能量=%f J；\n AUV巡航所消耗能量=%f J；\n AUV消耗总功率,含传感器能耗=%f J ；\n',T_P,E_tr,E_P,E_sum);
%         % we proposed architecture AoI
% 
% %         AoI_sum_1(i,m) = 0.5 * T_P + W + T_U;
%         AoI_sum_1(i,m)=210+19/2 * 300 + 0.5 * W;
% 
%         % we proposed architecture 排队加上浮消耗能量,排队+vacation期间AUV总能量(不含巡航功率)
%         E_total(i,m) = ((E_W)* (Lambda_AUV * (W + T_UD)) + E_UD)/(3600 * 1000);%单位千瓦时
% 
%     end
% %% 纯AUV采集数据消耗能量&AoI
% E_total(i,(M_max+1)) = (E_UD * (Lambda_AUV * (W + T_UD)))/(3600 * 1000); %和我们的架构相同条件时间段下，只考虑上浮过程能耗
% % AoI_sum_1(i,M_max+1) = 0.5 * T_P + T_U;%没有排队过程
% %9.27修改最新aoi定义
% T_s = D/V_a + H_A*(1/V_U+1/V_D);
% T_i_max = T_s - H_A/V_D - D/(20*V_a);
% T_i_min = H_A/V_U + D/(20*V_a);
% 
% A_0 = 0.5 *(T_i_max+T_i_min);
% AoI_sum_1(i,M_max+1) = A_0 + K_n * T_s;
% %% 考虑到AUV能量限制的单AUV的能耗&AoI
% temp_E = E_max_restriction/E_total(i,(M_max+1));
% E_total(i,(M_max+2)) = E_max_restriction ;
% Nor_V = sqrt(temp_E);
% AoI_sum_1(i,M_max+2) = AoI_sum_1(i,M_max+1)/Nor_V;
% 
% %% 计算得到最优M值的能耗&AoI
% 
% end

%% 跑完程序提醒
sound(sin(2*pi*25*(1:4000)/100));


