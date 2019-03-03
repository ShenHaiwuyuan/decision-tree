function targets = predict(tree,test_features, indices, discrete_dim)       
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%调用C4.5决策树算法对测试样本进行预测
%tree：C4.5算法所建立的决策树 
%test_features：测试样本的特征 
%indices：索引 
%discrete:各个维度的特征是否是连续取值，0指的是连续取值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% indices

targets = zeros(1, size(test_features,2)); 
        
if (tree.feature_tosplit == 0)  
    targets(indices) = tree.child;  %得到样本对应的标签是tree.child  
    return    
end    
        
feature_tosplit = tree.feature_tosplit;  %得到分裂特征  
dims= 1:size(test_features,1);  %得到特征索引  
        
% 根据得到的决策树对测试样本进行分类  
if (discrete_dim(feature_tosplit) == 0) %如果当前分裂特征是个连续特征 
    in= indices(find(test_features(feature_tosplit, indices)<= tree.location));  
    targets= targets + predict( tree.child(1),test_features(dims, :), in,discrete_dim(dims)); 
    in= indices(find(test_features(feature_tosplit, indices)>tree.location)); 
    targets= targets + predict(tree.child(2),test_features(dims, :),in,discrete_dim(dims));   
else  %如果当前分裂特征是个离散特征  
    Uf= unique(test_features(feature_tosplit,:)); %得到这个样本集中这个特征的无重复特征值  
    for i = 1:length(Uf)  %遍历每个特征值    
        if any(Uf(i) == tree.value)  %tree.Nf为树的分类特征向量 当前所有样本的这个特征的特征值  
            in= indices(find(test_features(feature_tosplit, indices) == Uf(i)));  %找到当前测试样本中这个特征的特征值==分裂值的样本索引  
            targets = targets + predict(tree.child(find(Uf(i)==tree.value)),test_features(dims, :),in,discrete_dim(dims));%对这部分样本再分叉   
        end    
    end    
end 

