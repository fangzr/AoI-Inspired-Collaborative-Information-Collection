%% ������Է��̸���ϵ��Z
%input:
%queue length M
%Vacation time T_UD
%AUV arrival rate Lambda_AUV
%ϵ�����±� m
%output:
%ϵ��ֵ Z_m
function Z_m = Coefficient_calculation(M,T_UD,Lambda_AUV,m)
sum_q = 0;
for n=1:15
    syms z;%z���Ա���
    syms x;%x���Ա���
    y = (exp(-1 * Lambda_AUV * T_UD * (1-z)))^(n/M);
    %��n-1�׵���
    y1(z) = diff(y,n-1);
    temp_y1 = y1(0);
    temp_y1 = double(temp_y1);
    temp_e_pow = (2 * pi * m * n)/M;
    temp_e = cos(temp_e_pow) + 1i * sin(temp_e_pow);
    temp_e_temp = temp_e/factorial(n);
    sum_q = double(sum_q + temp_y1 * temp_e_temp);
end
Z_m = sum_q;