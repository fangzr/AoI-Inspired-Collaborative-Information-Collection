%% ���Ժ�����ϵ������
T_UD = 5;
Lambda_AUV = 1;
M = 2;
m=1;
sum = 0;
% for n=1:150
%     syms z;%z���Ա���
%     syms x;%x���Ա���
%     y = (exp(-1 * Lambda_AUV * T_UD * (1-z)))^(n/M);
%     %��n-1�׵���
%     y1(z) = diff(y,n-1);
%     temp_y1 = y1(0);
%     temp_y1 = double(temp_y1);
%     temp_e_pow = (2 * pi * m * n)/M;
%     temp_e = cos(temp_e_pow) + 1i * sin(temp_e_pow);
%     temp_e_temp = temp_e/factorial(n);
%     sum = double(sum + temp_y1 * temp_e_temp);
% end

%% ���Լ���Q_M
tic
Q = zeros(M,1);
Q =  Q_M_Cal(M,T_UD,Lambda_AUV);

%% ��Q_M����ӳ��͵ȴ�ʱ������
[E_L,W] = Queueing_length(Q,M,T_UD,Lambda_AUV);
t=toc