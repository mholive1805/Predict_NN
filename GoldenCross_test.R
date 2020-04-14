require(quantmod)
source('GoldenCross.R')

# �Ｚ���� �ֽ� �����͸� �����´�
# �����ʹ� �ð�, ����, ����, ����, �ŷ����� ������ (OHLC data)
p <- getData('005930')

# �ܱ�/��� �̵������ �����Ͽ� Golden cross ������ Ȯ���Ѵ�
# ���� �ó����� : �ܱ� ������ ��� ���� �Ʒ��� ���� ���� �ż� ����
#                 �ܱ� ������ ��� ���� ���� ���� ���� �ŵ� ����
r <- goldenCross(p['2013::'], 5, 20, chart = TRUE)
r <- goldenCross(p['2013::'], 10, 40, chart = TRUE)

# Optimization
# ���ͷ� �ִ�, ���� ���ͷ� ǥ������ �ּ�, �׸��� Sharp ratio �ִ��� �Ⱓ�� ã��
opt <- optimize(p['2007-01-01::2012-12-31'], 5, 40, 15, 120)
opt

# ����� �ܱ� ���� = 17��, ��� ���� = 36�� �� �� Sharp ratio�� �ִ뿴��
# �� �Ⱓ���� ���� �� ������ Ȯ����
r <- goldenCross(p['2013-01-01::'], 17, 36, chart = TRUE)
plot(density(r), main = 'Return Density')
abline(v = mean(r), col = 'red')

# �� �Ⱓ���� ������ ���ɸ� Ȯ���� ��
r <- goldenCross(p['2013'], 17, 36, chart = TRUE)
r <- goldenCross(p['2014'], 17, 36, chart = TRUE)
r <- goldenCross(p['2015'], 17, 36, chart = TRUE)
r <- goldenCross(p['2016'], 17, 36, chart = TRUE)