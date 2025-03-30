%% ÅÅ¶ÓÄÜºÄ¼ÆËã
function [E_w] = UD_energy_comsumption(H_A,V_U,V_D,P_U,P_D)
T = H_A/V_U;
E_w = (P_U + P_D) * T;