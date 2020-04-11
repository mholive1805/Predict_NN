library(quantmod)
source('1.CollectData.R')

p <- getKospi(from='2015-01-01')

# ��Ȱȭ (Smoothing), �ܼ� �̵���� (SMA)
p$sma <- SMA(p$close, n=30)

# Kernel Regression ��Ȱȭ
# ksmooth �� list�� ��ȯ��. --> ������ ���������� ��ȯ
k <- as.data.frame(ksmooth(time(p), p$close, "normal", bandwidth=30))
p$kernel <- as.xts(k$y, order.by=index(p))

# Spline ��Ȱȭ
# spline�� ���� ������ ���������� ��ȯ �ȵ�. $y �� y ��Ҹ� ��ȯ��
k <- as.data.frame(smooth.spline(time(p), p$close, spar=1)$y)
p$spline <- as.xts(k, order.by=index(p))

par(mfrow=c(1,1), mar=c(3, 3, 3, 3), mgp=c(1.5, 0.3, 0))
plot(as.vector(p$close), type='l', main='Smoothing')
lines(as.vector(p$sma), col='blue')
lines(as.vector(p$kernel), col='red')
lines(as.vector(p$spline), col='green')