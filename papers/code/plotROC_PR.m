a=xlsread('roc.xlsx');
plot(a(:,1)',a(:,2)','r-',a(:,3)',a(:,4)','b-',a(:,5)',a(:,6)','g-',a(:,7)',a(:,8)','k-','LineWidth',1);
legend('ID3','newC4.5','C4.5','BP Neural Network');
xlabel('False Positive Rate(FPR)');
ylabel('True Positive Rate(TPR)');
title('ROC curve');