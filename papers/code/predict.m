function targets = predict(tree,test_features, indices)       
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%调用C4.5决策树算法对测试样本进行预测
%tree：C4.5算法所建立的决策树 
%test_features：测试样本的特征 
%indices：索引 
%discrete:各个维度的特征是否是连续取值，0指的是连续取值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% indices

targets = zeros(1, size(test_features,2)); 
if(isempty(indices))
    return;
end
if (tree.feature_tosplit == 0)  
    targets(indices) = tree.child;  %得到样本对应的标签是tree.child  
    return    
end    
        
feature_tosplit = tree.feature_tosplit;  %得到分裂特征  
dims= 1:size(test_features,1);  %得到特征索引  
        
% 根据得到的决策树对测试样本进行分类  
in= indices(find(test_features(feature_tosplit, indices)<= tree.location));  
targets= targets + predict( tree.child(1),test_features(dims, :), in); 
in= indices(find(test_features(feature_tosplit, indices)>tree.location)); 
targets= targets + predict(tree.child(2),test_features(dims, :),in);      
end 

