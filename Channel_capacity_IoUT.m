%�������书��P_T������B��SNR_gamma�����ŵ�����
function cap = Channel_capacity_IoUT(P_sl,B,SNR_gamma)

SNR_gamma_n = db_2_normal(SNR_gamma);

cap = B*log2(1+P_sl*SNR_gamma_n/B);