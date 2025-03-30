%% 求解母函数的概率分布Q
%输入：
%queue length M
%Vacation time T_UD
%AUV arrival rate Lambda_AUV
%输出：1 X M向量

function Q =  Q_M_Cal(M,T_UD,Lambda_AUV)
Z_max = zeros(1,M);
Q_max = zeros(M,1);
Phi_Max = zeros(M,M);
b = zeros(M,1); b(M,1) = M - Lambda_AUV * T_UD;
for m = 1:M-1
    Z_max(m) = Coefficient_calculation(M,T_UD,Lambda_AUV,m);
    for k = 0:M-1
        Phi_Max(m,k+1) = (Z_max(m))^M - (Z_max(m))^k;
    end
    Phi_Max(M,m) = M - m + 1;
end
Phi_Max(M,M) = 1;
Q_max = inv(Phi_Max)*b;
Q = real(Q_max);%只取实部