
function [x,y] = plo_pr( Predict,label)
    %初始点为（1.0, 1.0）
    %计算出ground_truth中正样本的数目pos_num和负样本的数目neg_num
    [n,m]=size(label);
    x = zeros(m,5);
    y = zeros(m,5);
    for j=1:5
        ground_truth=label(j,:);
        predict=Predict(j,:);
        
        pos_num = sum(ground_truth==1);
        neg_num = sum(ground_truth==0);

        m = size(ground_truth,2);
        [pre,Index] = sort(predict);
        ground_truth = ground_truth(Index);
%         x(1,j) = 0.5; y(1,j) = 0.5; %当阈值为0.1时，都被分类为了正类，所以真阳率和假阳率都为1.
        for i = 1:m
            TP = sum(ground_truth(i:m) == 1); %大于x(i)的标签为1的都是真阳，大于x(i)的标签为0的都是假阳
            FP = sum(ground_truth(i:m) == 0);
            x(i,j)=TP/pos_num;
            y(i,j)=TP/(TP+FP);
        end
    end
    x=mean(x');
    y=mean(y');
%     figure;
%     plot(x,y);
%     xlabel('ReCall');
%     ylabel('Predict');
%     title('PR曲线');
end 