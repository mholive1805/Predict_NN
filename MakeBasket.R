# HTS���� ����, ��¥���� ������ �ܱ���, ��� ������ �� �ŷ������� Transaction ������
# (Ȥ�� Basket ������)�� �����Ѵ�.
# ------------------------------------------------------------------------------------

getCode <- function(date, x) {
   n <- which(x$date == date)
   getCode <- as.vector(x$code[n])
}

# ���� �����͸� transaction (or Basket) �����ͷ� ��ȯ�Ѵ�
# n : �ܱ��� ���ŷ��� = 12��°, ��� ���ŷ��� = 13��°, ���� ���ŷ��� = 14��° colume
# -----------------------------------------------------------------------------------
MakeBasket <- function(x, n=12, trade="Buy") {
   if (trade == "Buy") {
      tmp <- x[which(x[, n] > 0),]
   } else {
      tmp <- x[which(x[, n] < 0),]
   }
   tmp1 <- data.frame(date=tmp[, 2], code=tmp[,1], stringsAsFactors=FALSE)
   tmp2 <- tmp1[order(tmp1$date),]
   
   ds <- data.frame(date=unique(tmp2$date))

   v <- as.list(apply(ds, 1, getCode, tmp2))
   
   # transaction �����͸� �����Ѵ�
   MakeBasket <- as(v, "transactions")
}