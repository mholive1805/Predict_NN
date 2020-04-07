require(randomForest)
source('3-2.FeatureSetTA.R')
printf <- function(...) cat(sprintf(...))

# Yahoo ����Ʈ�κ��� �Ｚ���� �ְ� �����͸� �о�´�
p <- getData('005930')

# ����� �м� Feature ������ ��Ʈ�� �����Ѵ�
ds <- FeatureSetTA(p)

# class�� factor ������ ��ȯ�Ѵ�
ds$train$class <- as.factor(ds$train$class)
levels(ds$train$class) <- c("Down", "Up")
ds$test$class <- as.factor(ds$test$class)
levels(ds$test$class) <- c("Down", "Up")

# ����������Ʈ�� �����Ѵ�
rf <- randomForest(class ~ ., data = ds$train, ntree=50)

# Error rate�� �����Ѵ�. (�Ʒ� �����ͷ� ������ Error ��)
plot(rf, main="Error")
err <- as.data.frame(rf$err.rate)
print(head(err))
err$mean <- apply(err, 1, mean)
minErrTree <- which(err$mean == min(err$mean))[1]
printf("* Error �� �ּ��� Ʈ���� ���� = %d\n", minErrTree)

# �׽�Ʈ ������ ��Ʈ�� �̿��Ͽ� ������ Ȯ���Ѵ�
pr <- predict(rf, ds$test)
cm <- table(pr, ds$test$class)
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
printf("\n* ��Ȯ�� = %.4f\n", accuracy)

# �з��������� ���� ���� ����� �м� ��ǥ�� Ȯ���Ѵ�.
varImpPlot(rf, sort = TRUE, pch = 15, col='red', main="Importance")


