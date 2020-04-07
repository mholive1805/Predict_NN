# �ְ��� ����ī���� �ùķ��̼�
# r : Risk free rate
# v : volatility
# n : number of simulation
# s : initial value of a stock
MCrealization <- function(r=0.02, v=0.20, n=100, s = 2000, chart=TRUE) {
   # ���� ���ͷ�. r�� ���� ������.
   dRtn <- r / 365
   
   # ���� ������. v�� ���� ������.
   dVol <- v / sqrt(252)
   
   # 1�� �� ������ ��� ���ͷ�
   mRtn <- dRtn - 0.5 * dVol ^ 2
   
   # rnorm ���� ���ͷ� �ùķ��̼�
   result <- data.frame(rnorm(n))
   colnames(result) <- 'rnorm'
   result$rtn <- mRtn + dVol * result$rnorm
   
   # ���ͷ��� �ְ� �ùķ��̼�
   result$price <- s * exp(cumsum(result$rtn))

   # �ְ� ��Ʈ
   if (chart)
      plot(result$price, type='l', col = 'blue', main = "Monte Carlo Simulation")
   
   MonteCalro <- result
}

MCensamble <- function(r=0.02, v=0.20, n=100, s = 2000, k=20) {
   emc <- MCrealization(r=r, v=v, n=n, s=s, chart=FALSE)$price
   
   for (i in 1:(k-1))
      emc <- cbind(emc, MCrealization(r=r, v=v, n=n, s=s, chart=FALSE)$price)
   emc <- as.data.frame(emc)
   
   # ��Ʈ �ۼ�
   minY <- round(min(emc)) - 10
   maxY <- round(max(emc)) + 10
   
   for (i in 1:k) {
      if (i == 1)
         plot(emc[,i], type='l', ylim=c(minY, maxY), main="Monte Carlo Simulation")
      else
         lines(emc[,i], type='l', ylim=c(minY, maxY), xlim=c(1, k), col=sample(rainbow(3 * k), 1))
   }
   abline(h = s)
   
   MCensamble <- emc
}