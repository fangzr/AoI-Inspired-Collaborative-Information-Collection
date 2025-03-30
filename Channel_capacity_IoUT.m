%给定发射功率P_T，带宽B，SNR_gamma，求信道容量
function cap = Channel_capacity_IoUT(P_sl,B,SNR_gamma)

SNR_gamma_n = db_2_normal(SNR_gamma);

cap = B*log2(1+P_sl*SNR_gamma_n/B);