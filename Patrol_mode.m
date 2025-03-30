%% 函数功能：计算AUV巡逻能量消耗
%输入：
%给定路径长度 D
%一个sector的传感器节点数 K_n
%AUV运行高度 h
%水深 H_A
%AUV运行速度V_a
%传输声信号中心频率fc，带宽需要自己求
%单个传感器数据产生速率 Lambda_data
%巡逻在路径的时间 T_P
%排队的时间 W
%每个node更新一次数据包长度L_n
%发射功率 P_T
%AUV悬停功率 P_w
%AUV运动功率 P_M
%接收功率 P_R
%带宽 B
%输出：
%巡逻消耗总时间 T_P ，就用泊松过程
%巡逻能量消耗 E
%AUV消耗总功率,含传感器能耗 E_sum
%% 函数定义
function [T_P,E_tr,E_P,E_sum] = Patrol_mode(D,K_n,eta,h,H_A,V_a,fc,Lambda_data,T_M,W,L_n,P_T,P_w,P_M,P_R,B)
% 求水声信道容量cap
[gamma,gamma_n] = SNR_gamma(h,fc);
% P_SL 转化为 P_T
% 水深
temp1 = eta * P_T;
temp2 = 6.28 * H_A;
I_T = temp1 / temp2;
P_SL = I_T/(0.67*10^(-18));
cap = Channel_capacity_IoUT(P_SL,B,gamma);

%求传递数据的额外时间
temp1 = h * cap + Lambda_data * L_n * 1500 * (T_M + W);
temp2 = 1500 * (cap - Lambda_data * L_n * K_n);
T_tr = (temp1/temp2);%注意这是单个传感器节点的传输时间

%AUV巡航+采集数据消耗时间
T_P = K_n * T_tr + T_M;

%n-th sector数据采集所消耗能量
E_tr = K_n * (P_w + P_T + P_R) * T_tr;

%n-th sector AUV巡航所消耗能量
E_P = (D/V_a) * P_M;

E_sum = E_tr + E_P;








