clc;
clear all;
close all;




% ���������(Lambda_data=1/60 s^-1��Lambda_AUV_seq=[0.58:0.04:0.94]./60)
V_U = 1 * 1852 / 3600;%C-AUV�ϸ��ٶ�
V_D = 2 * 1852 / 3600;%C-AUV��Ǳ�ٶ�
V_a = 5*1852/3600;%AUV�ƶ��ٶ�
H_A = 100;%AUV����
% Lambda_AUV = 1/300;%N-AUV����Ƶ��
Lambda_AUV_seq = [0.56:0.06:1.1]./60;
P_w = 0.2 * 1E3;%�ȴ�����
P_U = 6 * 1E3;%��������
P_D = 6 * 1E3;%��Ǳ����
P_M = 2 * 1E3;%�˶�����
T_UD = H_A * (1/V_U + 1/V_D);
T_U = H_A/V_U;
%����Ԥ��·�����Ⱥͽڵ���Ŀ�����AoI���������
K_n = 19;
h = 10 /1E3;%AUV�ڽڵ��Ϸ�
fc = 25E3 /1E3;%���ź�Ƶ��
B = 1E3;%3dB����Ϊ
D = 1000;%��ʻ����
eta = 0.2;%ת��Ч��
T_M = D/V_a;%AUV��Ѳ��·������ʱ��
Lambda_data = 0.6;%���ݲɼ��ٶ�һ����/��
P_T = 30 * 1E-3;%30mW�ķ��书��
P_R = 10 * 1E-3;%10mW�Ľ��չ���
L_n = 1024;%ÿ�θ��µİ���
E_max_restriction = 1.692596984257934e+06;%ƽ���ܺ�����
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
% we proposed N-AUV��C-AUV�Ŷ�ģʽ
for i = 1:AUV_rate_max
Lambda_AUV = Lambda_AUV_seq(i);
M_optimal = min(ceil(3 * Lambda_AUV * T_UD),6);%��������Mֵ
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
        fprintf('Lambda_AUV_rate=%f ^(-1)��\n �Ŷ�����M=%d��\n AUV�Ŷӳ�������%f ����\n AUV�ȴ�ʱ������%f s ��\n',1/Lambda_AUV,M,L_AUV,W);
        % we proposed N-AUVѲ��ģʽ

        %Ѳ��������ʱ�� T_P �����ò��ɹ���
        %sector���ݲɼ����������� E_tr
        % sector AUVѲ������������ E_P
        %AUV�����ܹ���,���������ܺ� E_sum
        if M > (Lambda_AUV * T_UD)
            [T_P,E_tr,E_P,E_sum] = Patrol_mode(D,K_n,eta,h,H_A,V_a,fc,Lambda_data,T_M,W,L_n,P_T,P_w,P_M,P_R,B);
            fprintf('Ѳ��������ʱ��=%f s��\n���ݲɼ�����������=%f J��\n AUVѲ������������=%f J��\n AUV�����ܹ���,���������ܺ�=%f J ��\n',T_P,E_tr,E_P,E_sum);
        end
        % we proposed architecture AoI
        A_0_min = D/((K_n+1)*V_a) + W + T_U;
        A_0_max = (D-50)/(V_a) + W + T_U;
        A_0 = 0.5*(A_0_min+A_0_max);
%         AoI_sum_1(i,m) = 0.5 * T_P + W + T_U;
        AoI_sum_1(i,m)=A_0+(K_n/2 * (T_UD + W));
        % we proposed architecture �ŶӼ��ϸ���������,�Ŷ�+vacation�ڼ�AUV������(����Ѳ������)
        E_total(i,m) = E_P + E_W + E_UD/L_AUV;

    end
%% ��AUV�ɼ�������������&AoI
E_total(i,(M_max+1)) = E_P + E_UD; %�����ǵļܹ���ͬ����ʱ����£�ֻ�����ϸ������ܺ�
% AoI_sum_1(i,M_max+1) = 0.5 * T_P + T_U;%û���Ŷӹ���% %9.27�޸�����aoi����
T_s = D/V_a + H_A*(1/V_U+1/V_D);
T_i_max = T_s - H_A/V_D - D/(20*V_a);
T_i_min = H_A/V_U + D/(20*V_a);

A_1 = 0.5 *(T_i_max+T_i_min);
 AoI_sum_1(i,M_max+1) = A_1 + 0.5 * (K_n) * T_s;
%% ���ǵ�AUV�������Ƶĵ�AUV���ܺ�&AoI
E_max_restriction = E_total(i,3)*1.5;
temp_E = E_max_restriction/E_total(i,(M_max+1));
E_total(i,(M_max+2)) = E_max_restriction ;
Nor_V = (temp_E);%E=kvs�����ٶȳ�����
AoI_sum_1(i,M_max+2) = AoI_sum_1(i,M_max+1)/Nor_V;
end

% % 
% %% �������ݲ������ʶ�AoI���ܺ�Ӱ��
% V_U = 1 * 1852 / 3600;%C-AUV�ϸ��ٶ�1 knot
% V_D = 2 * 1852 / 3600;%C-AUV��Ǳ�ٶ�2 knot
% V_a = 5*1852/3600;%AUV�ƶ��ٶ�5 knot
% H_A = 100;%AUV����
% Lambda_AUV_seq = 70^(-1);
% P_w = 0.2 * 1E3;%�ȴ�������0.2kW
% P_U = 6 * 1E3;%����������4kW
% P_D = 5 * 1E3;%��Ǳ������2kW
% P_M = 2 * 1E3;%�˶�������2kW
% T_UD = H_A * (1/V_U + 1/V_D);
% T_U = H_A/V_U;
% %����Ԥ��·�����Ⱥͽڵ���Ŀ�����AoI���������
% K_n = 20;
% h = 10 /1E3;%AUV�ڽڵ��Ϸ�20m
% fc = 25E3 /1E3;%���ź�Ƶ��25kHz
% B = 1E3;%3dB����Ϊ1kHz
% D = 1000;%��ʻ����1km
% eta = 0.2;%ת��Ч��
% T_M = D/V_a;%AUV��Ѳ��·������ʱ��
% Lambda_data_seq = [0.01:0.05:0.51];
% Lambda_data_max = size(Lambda_data_seq,2);
% % Lambda_data = 1/60;%���ݲɼ��ٶ�һ����/��
% P_T = 30 * 1E-3;%30mW�ķ��书��
% P_R = 10 * 1E-3;%10mW�Ľ��չ���
% L_n = 1024;%ÿ�θ��µİ��� bit
% E_max_restriction = 0.9;%ƽ���ܺ�����Ϊ0.82kW��h
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
% Lambda_AUV = 1/65;%����H-AUV������
% M_optimal = ceil(6 * Lambda_AUV * T_UD);%��������Mֵ
% M_Value(M_max) = M_optimal;
% 
% %% we proposed architecture
% % we proposed N-AUV��C-AUV�Ŷ�ģʽ
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
%          fprintf('Lambda_data=%f ^(-1)��\n �Ŷ�����M=%d��\n AUV�Ŷӳ�������%f ����\n AUV�ȴ�ʱ������%f s ��\n',1/Lambda_data,M,L_AUV,W);
%         % we proposed N-AUVѲ��ģʽ
% 
%         %Ѳ��������ʱ�� T_P �����ò��ɹ���
%         %sector���ݲɼ����������� E_tr
%         % sector AUVѲ������������ E_P
%         %AUV�����ܹ���,���������ܺ� E_sum
%         [T_P,E_tr,E_P,E_sum] = Patrol_mode(D,K_n,eta,h,H_A,V_a,fc,Lambda_data,T_M,W,L_n,P_T,P_w,P_M,P_R,B);
%         fprintf('Ѳ��������ʱ��=%f s��\n���ݲɼ�����������=%f J��\n AUVѲ������������=%f J��\n AUV�����ܹ���,���������ܺ�=%f J ��\n',T_P,E_tr,E_P,E_sum);
%         % we proposed architecture AoI
% 
% %         AoI_sum_1(i,m) = 0.5 * T_P + W + T_U;
%         AoI_sum_1(i,m)=210+19/2 * 300 + 0.5 * W;
% 
%         % we proposed architecture �ŶӼ��ϸ���������,�Ŷ�+vacation�ڼ�AUV������(����Ѳ������)
%         E_total(i,m) = ((E_W)* (Lambda_AUV * (W + T_UD)) + E_UD)/(3600 * 1000);%��λǧ��ʱ
% 
%     end
% %% ��AUV�ɼ�������������&AoI
% E_total(i,(M_max+1)) = (E_UD * (Lambda_AUV * (W + T_UD)))/(3600 * 1000); %�����ǵļܹ���ͬ����ʱ����£�ֻ�����ϸ������ܺ�
% % AoI_sum_1(i,M_max+1) = 0.5 * T_P + T_U;%û���Ŷӹ���
% %9.27�޸�����aoi����
% T_s = D/V_a + H_A*(1/V_U+1/V_D);
% T_i_max = T_s - H_A/V_D - D/(20*V_a);
% T_i_min = H_A/V_U + D/(20*V_a);
% 
% A_0 = 0.5 *(T_i_max+T_i_min);
% AoI_sum_1(i,M_max+1) = A_0 + K_n * T_s;
% %% ���ǵ�AUV�������Ƶĵ�AUV���ܺ�&AoI
% temp_E = E_max_restriction/E_total(i,(M_max+1));
% E_total(i,(M_max+2)) = E_max_restriction ;
% Nor_V = sqrt(temp_E);
% AoI_sum_1(i,M_max+2) = AoI_sum_1(i,M_max+1)/Nor_V;
% 
% %% ����õ�����Mֵ���ܺ�&AoI
% 
% end

%% �����������
sound(sin(2*pi*25*(1:4000)/100));


