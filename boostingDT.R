library(adabag)
library(rpart)
source('3-2.FeatureSetTA.R')

# Yahoo ����Ʈ�κ��� �Ｚ���� �ְ� �����͸� �о�´�
p <- getData('005930')

# ����� �м� Feature ������ ��Ʈ�� �����Ѵ�
ds <- FeatureSetTA(p)

# class�� factor ������ ��ȯ�Ѵ�
ds$train$class <- as.factor(ds$train$class)
levels(ds$train$class) <- c("Dwon", "Up")
ds$test$class <- as.factor(ds$test$class)
levels(ds$test$class) <- c("Dwon", "Up")

# Boosting
control = rpart.control(cp = 0.007)
ada <- boosting(class~., data = ds$train, mfinal=100, boos=TRUE, coeflearn='Breiman', control)
#errorevol(ada, ds$train)

# �׽�Ʈ ������ ��Ʈ�� �̿��Ͽ� ������ Ȯ���Ѵ�
cm <- predict(ada, ds$test)$confusion
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
printf("\n* ��Ȯ�� = %.4f\n", accuracy)

# �з��������� ���� ���� ����� �м� ��ǥ�� Ȯ���Ѵ�.
imp <- sort(ada$importance, decreasing=TRUE)
print(imp)
barplot(imp, col='green', xlab=colnames(imp))