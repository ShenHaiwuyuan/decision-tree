clc;
clear;
%% 参数定义
datafile='./data/空气建模样本数据.xls';
thres_disc=10;
%% 数据预处理
[data,txt]=xlsread(datafile);
label=toInt(txt(2:size(txt),7)); 
orginal=cat(2,data,label);

%% 划分数据集 train:test=7:3
[trainData,testData]=splitData(orginal);
% 提取features和targets
train_features=trainData(:,1:(size(trainData,2)-1))';  
train_targets=trainData(:,size(trainData,2))';  
test_features=testData(:,1:(size(testData,2)-1))';  
test_targets=testData(:,size(testData,2))';

%% 导入模型训练
%判断某一维的特征是离散取值还是连续取值，0代表是连续特征
discrete_dim =discreteOrContinue(train_features,thres_disc); 
% 1.ID3
id3Tree=ID3(train_features,train_targets);
test_predict1= predict(id3Tree,test_features, 1:size(test_features,2), discrete_dim);
% 2.C4.5
c45Tree=C4_5(train_features,train_targets);
test_predict2= predict(c45Tree,test_features, 1:size(test_features,2), discrete_dim);
% 3.LM
lmNet=LM(train_features,arrayToMatrix(train_targets'));
test_predict3=sim(lmNet,test_features);
% 4.BP
bpNet=BP(train_features,arrayToMatrix(train_targets'));
test_predict4=sim(bpNet,test_features);
%% 模型评价
% 混淆矩阵
plotconfusion(arrayToMatrix(test_predict1'),arrayToMatrix(test_targets'));
figure;
plotconfusion(arrayToMatrix(test_predict2'),arrayToMatrix(test_targets'));
figure;
plotconfusion(arrayToMatrix(test_targets'),test_predict3);
figure;
plotconfusion(arrayToMatrix(test_targets'),test_predict4);
% ROC曲线
figure;
[AUC1,FPR1,TPR1]=plot_roc(arrayToMatrix(test_predict1'),arrayToMatrix(test_targets'));
[AUC2,FPR2,TPR2]=plot_roc(arrayToMatrix(test_predict2'),arrayToMatrix(test_targets'));
[AUC3,FPR3,TPR3]=plot_roc(test_predict3,arrayToMatrix(test_targets'));
[AUC4,FPR4,TPR4]=plot_roc(test_predict4,arrayToMatrix(test_targets'));
plot(FPR1,TPR1,'r-',FPR2, TPR2,'b-',FPR3,TPR3,'g-',FPR4,TPR4,'y-');
legend('ID3','C4.5','LM神经网络','BP神经网络');
xlabel('假正例率(FPR)');
ylabel('真正例率(TPR)');
title('ROC曲线');
% PR曲线
figure;
[precision1,recall1]=plot_pr(arrayToMatrix(test_predict1'),arrayToMatrix(test_targets'));
[precision2,recall2]=plot_pr(arrayToMatrix(test_predict2'),arrayToMatrix(test_targets'));
[precision3,recall3]=plot_pr(test_predict3,arrayToMatrix(test_targets'));
[precision4,recall4]=plot_pr(test_predict4,arrayToMatrix(test_targets'));
plot(precision1,recall1,'r-',precision2,recall2,'b-',precision3,recall3,'g-',precision4,recall4,'y-');
legend('ID3','C4.5','LM神经网络','BP神经网络');
xlabel('精确率');
ylabel('召回率');
title('PR曲线');
% 准确率
disp('准确率')
accuracy(1)=cal_accuracy(test_targets,test_predict1);
accuracy(2)=cal_accuracy(test_targets,test_predict2);
accuracy(3)=cal_accuracy(test_targets,vec2ind(test_predict3));
accuracy(4)=cal_accuracy(test_targets,vec2ind(test_predict4));
fprintf('ID3：%f\nC4.5：%f\nLM：%f\nBP：%f\n',accuracy(1),accuracy(2),accuracy(3),accuracy(4));