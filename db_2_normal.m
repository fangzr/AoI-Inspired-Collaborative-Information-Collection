%% dB和正常数值转换函数
function y = db_2_normal(x)
y=10^(x/10);