function [auc,x,y] = plot_roc( features,Predict,label)
    %初始点为（1.0, 1.0）
    %计算出ground_truth中正样本的数目pos_num和负样本的数目neg_num
    [n,m]=size(label);
    x = zeros(m+1,6);
    y = zeros(m+1,6);
    for j=1:6
        targs = -ones(1,length(label));
        positive_i=find(label==j);
        targs(positive_i)=1;
        
        dec = features(j,:);
        pre_nag = find(Predict~=j);
        dec(pre_nag)=-dec(pre_nag);
        dvs=dec';
        [pre,Index] = sort(dvs);
        ground_truth = targs(Index);
        m = size(ground_truth,2);
%         x(1,j) = 1; y(1,j) = 1; %当阈值为0.1时，都被分类为了正类，所以真阳率和假阳率都为1.
        for i = 1:m
            TP = sum(ground_truth(i:m) > 0); %大于x(i)的标签为1的都是真阳，大于x(i)的标签为0的都是假阳
            TN = sum(ground_truth(1:i) < 0);
            FP = sum(ground_truth(i:m) < 0);
            FN = sum(ground_truth(1:i) > 0);
            x(i,j) = FP/(FP+TN);
            y(i,j) = TP/(TP+FN);

        end
    end
    x=mean(x');
    y=mean(y');
    auc=AUC(x,y);
end 