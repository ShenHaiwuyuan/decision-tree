function tree = buildTree(train_features,train_targets,discrete_dim,layer,type,varargin)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%调用C4.5决策树算法建立决策树
%training_features：训练样本的特征  
%training_targets：训练样本所属类别  
%discrete_dim：各个维度的特征是否是连续特征，0指的是连续特征  
%layer:节点所属树的层数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
if nargin>5
    pruning=varargin{1};
else
    pruning=35;
end
[fea, L]= size(train_features);  
ale= unique(train_targets);  
tree.feature_tosplit= 0;  
tree.location=inf;  %初始化分裂位置是inf  
        
if isempty(train_features)   
    return    
end    
           
if ((pruning > L) || (L == 1) ||(length(ale) == 1)) %如果剩余训练样本太小(小于pruning)，或只剩一个，或只剩一类标签，退出    
    his= hist(train_targets, length(ale));  %统计样本的标签，分别属于每个标签的数目  
    [num, largest]= max(his); 
    tree.value= [];    
    tree.location  = [];    
    tree.child= ale(largest);
    return    
end    
         
for i = 1:length(ale) %遍历判别标签的数目   
    Pnode(i) = length(find(train_targets == ale(i))) / L; 
end   

%计算当前节点的信息熵 
Inode = -sum(Pnode.*log2(Pnode));    
        
el= zeros(1, fea);  %记录每个特征的信息增益率  
location= ones(1, fea)*inf;
        
for i = 1:fea %遍历每个特征    
    data= train_features(i,:); 
    pe= unique(data);    
    nu= length(pe);   
    if (discrete_dim(i)) %离散特征   
        node= zeros(length(ale), nu);
        for j = 1:length(ale) %遍历每个标签    
            for k = 1:nu %遍历每个特征值    
                indices     = find((train_targets == ale(j)) && (train_features(i,:) == pe(k)));    
                node(j,k)  = length(indices);
            end    
        end    
        rocle= sum(node);
        P1= repmat(rocle, length(ale), 1);
        P1= P1 + eps*(P1==0);
        node= node./P1;
        rocle= rocle/sum(rocle);
        info= sum(-node.*log(eps+node)/log(2));  %每个特征分别计算信息熵,eps是为了防止对数为1 
%         el(i) = (Inode-sum(rocle.*info))/(-sum(rocle.*log(eps+rocle)/log(2))); %信息增益率  
        if tyoe==0
            el(i) = (Inode-sum(rocle.*info));  
        else
            el(i) = (Inode-sum(rocle.*info))/(-sum(rocle.*log(eps+rocle)/log(2))); %信息增益率
        end
    else
        %连续特征
        node= zeros(length(ale), 2);
        
        [sorted_data, indices] = sort(data);
        sorted_targets = train_targets(indices);
        
        %计算分裂信息度量  
         I = zeros(1,nu);  
         spl= zeros(1, nu);  
         for j = 1:nu-1  %特征i有Nbins个连续值，设定Nbins-1个可能的分割点，对每个分割点计算信息增益率
             node(:, 1) = hist(sorted_targets(find(sorted_data <= pe(j))) , ale);  
             node(:, 2) = hist(sorted_targets(find(sorted_data > pe(j))) , ale);   
             Ps= sum(node)/L; 
             node= node/L; 
             rocle= sum(node);    
             P1= repmat(rocle, length(ale), 1); 
             P1= P1 + eps*(P1==0);    
             info= sum(-node./P1.*log(eps+node./P1)/log(2)); %信息增益
             I(j)= Inode - sum(info.*Ps);   
             spl(j) =I(j)/(-sum(Ps.*log(eps+Ps)/log(2)));  %第j个分割点的信息增益率
         end  
  
       [~, s] = max(I);  %求所有分割点的最大信息增益率
       [~,S]=max(spl);
       if type==0
           el(i)=I(s);
           location(i) = pe(s);  %对应特征i的划分位置就是能使信息增益最大的划分值 
       else
           el(i)=spl(S);
           location(i) = pe(S);  %对应特征i的划分位置就是能使信息增益最大的划分值 
       end
%         el(i)=I(s);
        location(i) = pe(s);  %对应特征i的划分位置就是能使信息增益最大的划分值 
   end    
end    
        
%找到当前要作为分裂特征的特征  
[num, feature_tosplit]= max(el); 
dims= 1:fea;  %特征数目  
tree.feature_tosplit= feature_tosplit;  %记为树的分裂特征  
        
value= unique(train_features(feature_tosplit,:)); 
nu= length(value);
tree.value = value;  %记为树的分类特征向量 当前所有样本的这个特征的特征值  
tree.location = location(feature_tosplit);  %树的分裂位置
           
if (nu == 1)  %无重复的特征值的数目==1，即这个特征只有这一个特征值，就不能进行分裂  
    his= hist(train_targets, length(ale));
    [num, largest]= max(his); 
    tree.value= [];
    tree.location  = [];    
    tree.child= ale(largest); 
    return    
end    
        
if (discrete_dim(feature_tosplit))  %如果当前选择的这个作为分裂特征的特征是个离散特征   
    for i = 1:nu   %遍历这个特征下无重复的特征值的数目  
        indices= find(train_features(feature_tosplit, :) == value(i));
        tree.child(i)= buildTree(train_features(dims, indices), train_targets(indices), discrete_dim(dims), layer, pruning);%递归  
       
        %离散特征，分叉成Nbins个，分别针对每个特征值里的样本，进行再分叉  
    end    
else
    
%如果当前选择的这个作为分裂特征的特征是个连续特征
indices1= find(train_features(feature_tosplit,:) <= location(feature_tosplit));  %找到特征值<=分裂值的样本的索引们  
indices2= find(train_features(feature_tosplit,:) > location(feature_tosplit));
  if ~(isempty(indices1) || isempty(indices2))  %如果<=分裂值 >分裂值的样本数目都不等于0    
      tree.child(1)= buildTree(train_features(dims, indices1), train_targets(indices1), discrete_dim(dims),layer+1, pruning);
      tree.child(2)= buildTree(train_features(dims, indices2), train_targets(indices2), discrete_dim(dims),layer+1, pruning);   
  else    
      his= hist(train_targets, length(ale));  %统计当前所有样本的标签，分别属于每个标签的数目 
      [num, largest]= max(his);
      tree.child= ale(largest);   
      tree.feature_tosplit= 0;  %树的分裂特征记为0  
  end    
end 


