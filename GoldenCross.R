library(quantmod)
source('1.CollectData.R')

# �Ｚ���� �ְ� ������ (OHLC)�� ������ ��, ������ �����Ѵ�
# �ŷ����� 0 �� ���� �����Ѵ� (��, ����)
# samsung <- getSymbols('005930.KS', auto.assign=FALSE)
# samsung <- samsung[Vo(samsung) > 0]
# colnames(samsung) <- c('open', 'high', 'log', 'close', 'volume', 'adjusted')
# goldenCross(samsung['2014'], 5, 20)

# ����ȭ
optimize <- function(x, sfrom, sto, lfrom, lto) {
	r <- data.frame()
	t <- 1
	
	# for ������ �ۼ���. ���� ���������� foreach() �� doParallel()�� ���� ó���� �� ��.
	ptime <- system.time(
      for(i in sfrom:sto) {
         longStart <- i + lfrom
         longEnd <- longStart + lto
         for(j in longStart:longEnd) {
            ret <- goldenCross(x, i, j, chart=F)
            stdev <- sd(ret)
            
            r[t, 1] <- i; 	# �ܱ� �̵���� �Ⱓ
            r[t, 2] <- j; 	# ��� �̵���� �Ⱓ
            r[t, 3] <- as.numeric(last(cumsum(ret)))
            r[t, 4] <- stdev
            r[t, 5] <- as.numeric(last(cumsum(ret))) / stdev
            t <- t + 1
         }
      }
	)
	print(ptime)
	retVal <- data.frame()
	
	# ������ ���ͷ��� �ִ��� ���� ����
	retVal <- r[which.max(r[,3]),]
	
	# ������ �ּ��� ���θ� ����
	retVal[2,] <- r[which.min(r[,4]),]
	
	# Sharp ratio�� �ִ��� ���θ� ����
	retVal[3,] <- r[which.max(r[,5]),]
	
	retVal[1, 6] <- 'Max return'
	retVal[2, 6] <- 'Min stdev'
	retVal[3, 6] <- 'Max sharp ratio'

	row.names(retVal) <- c(1:nrow(retVal))
	colnames(retVal) <- c('ShrtMA', 'LongMA', 'LastRtn', 'Stdev', 'Sharp', 'Remark')
	print(retVal)
	optimize <- r
}

# Golden cross, Dead cross ���� Back Test
goldenCross <- function(x, shortMA, longMA, chart) {
	# �ܱ� �̵���ռ��� ��� �̵���ռ��� ���Ѵ�. NA�� �����Ѵ�
	x$maShort <- SMA(Cl(x), shortMA)
	x$maLong <- SMA(Cl(x), longMA)
	x <- na.omit(x)

	# ���ͷ��� ���� ���´�
	# ret <- dailyReturn(s$close) �� open ~ close �������� ���ͷ� ����
	# ret <- ROC(s$close) �� ���� close�� ���� close�� ���ͷ� ���� (�α� ���ͷ�)
	x$return <- ROC(x$close)
	x <- na.omit(x)

	# ������ �����Ѵ�
	# �ܱ������� ������� ���� ������ Long position, �ƴϸ� Short position ����
	x$position <- ifelse(x$maShort > x$maLong, 1, -1)
	
	# ���� ����� ���ͷ��� ����Ѵ�
	x$myret <- lag(x$position) * x$return
	x <- na.omit(x)

	if (chart == TRUE) {
		# ���� ���� ����� Ȯ���Ѵ�
	  par(mfrow = c(2,1), mar=c(2, 2, 2, 2), mgp=c(3, 0.3, 0))
	  plot(as.vector(x$close), type = 'l', main = 'Price & MAs', 
	       ylab='', xlab='', cex.main=1, cex.axis=0.8, xaxt="n", yaxt="n")
	  axis(1, at = seq(1, nrow(x)), tck=-0.02, 
	       label = format(as.Date(index(x)), "%Y/%b"), cex.axis = 0.8)
	  axis(2, tck=-0.02, cex.axis=0.8)
	  grid()
	  
		#par(mfrow=c(2,1))
		#plot(x$close, type = 'l', main = 'Price & MAs')
		lines(as.vector(x$maShort), col = 'blue')
		lines(as.vector(x$maLong), col = 'red')

		plot(cumsum(x$myret), main = 'Realized return', cex.main=1)
		lines(cumsum(x$myret), col = 'red')
	}

	# ���� ���ͷ��� �����Ѵ�
	goldenCross <- x$myret
}