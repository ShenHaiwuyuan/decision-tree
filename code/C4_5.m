function tree = C4_5(train_features,train_targets,varargin)
    disp('C4.5决策树')
    pruning=35; 
    thres_disc=10;
    if nargin>3
        pruning=varargin{1};
        thres_disc=varargin{2};
    elseif nargin>2
        thres_disc=varargin{1};
    end
    [fea,num]=size(train_features); %num是训练样本数，fea是特征数目  
    pruning=pruning*num/100;  %用于剪枝  
    %判断某一维的特征是离散取值还是连续取值，0代表是连续特征
    discrete_dim =discreteOrContinue(train_features,thres_disc); 
    disp('Building Tree...')
    tree=buildTree(train_features,train_targets,discrete_dim,0,1,pruning);
    disp('Saving Tree')
    save tree.mat tree;

end

