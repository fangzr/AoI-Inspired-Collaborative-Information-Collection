%% G-limited排队模型
%输入AUV到达率 Lambda_AUV
%输入排队最大容量 M
%输出队列长度期望 L
%输出AUV等待时间期望 W

function [L,W] = G_limited_QT(Lambda_AUV,M)