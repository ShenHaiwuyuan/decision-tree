function discrete_dim=discreteOrContinue(train_features,thres_disc)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %判断某个维度的特征是不是连续取值
    %train_features:训练集的特征
    %thres_disc:离散特征阈值，>thres_disc认定为该特征取值范围连续
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    fea=size(train_features,1);
    discrete_dim = zeros(1,fea);
    for i = 1:fea  %遍历每个特征  
        Ub = unique(train_features(i,:)); 
        Nb = length(Ub);   
        if (Nb <= thres_disc)    
            discrete_dim(i) = Nb; %得到训练样本中，这个特征的无重复的特征值的数目 存放在discrete_dim(i)中，i表示第i个特征  
        end    
    end
end