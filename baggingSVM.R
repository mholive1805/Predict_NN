library(e1071)
require(foreach)
source('3-2.FeatureSetTA.R')

# Yahoo ����Ʈ�κ��� �Ｚ���� �ְ� �����͸� �о�´�
p <- getData('005930')

# ����� �м� Feature ������ ��Ʈ�� �����Ѵ�
ds <- FeatureSetTA(p)
trainData <- as.data.frame(ds$train)
testData <- as.data.frame(ds$test)

trainData$class <- as.factor(trainData$class)
levels(trainData$class) <- c("Down", "Up")

testData$class <- as.factor(testData$class)
levels(testData$class) <- c("Down", "Up")

# SVM�� ���� Bagging�� �����Ѵ�
# �Ʒ� ������ ��Ʈ�� 5���� ������ 50�� �ݺ� ������
div <- 5
iterations <- 50

bagged <- foreach(m=1:iterations, .combine = cbind) %do% {
   pos <- sample(nrow(trainData), size=floor((nrow(trainData) / div)))
   train_pos <- 1:nrow(trainData) %in% pos
   base <- svm(class ~ ., data = trainData[train_pos,], kernel="radial", cost=1, gamma=0.5)
   predict(base, testData)
}

# Baggind ��� Ȯ��
print(bagged[1:10, 1:10])

# Test �����͸� ����Ͽ� ��Ȯ���� �����Ѵ�
meanPredict <- apply(bagged[, 1:iterations], 1, function(x) {
   s <- (sum(x) / iterations)
   round(s, 0)
   })

svmPredict <- as.data.frame(cbind(testData$class, meanPredict), row.names=F)
cm <- table(svmPredict, dnn=list('predicted', 'actual'))
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
printf("\n* ��Ȯ�� = %.6f\n", accuracy)

