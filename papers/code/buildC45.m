function tree = buildC45(train_features,train_targets,layer,varargin)
    [feaNum,L]=size(train_features);
    Label=unique(train_targets);
    tree.feature_tosplit=0;
    tree.location=inf;
    if isempty(train_features)
        return
    end
    
    %分裂停止条件
    if (  (L==1)||(length(Label) <=1)||(layer==6)) %如果剩余训练样本太小(小于pruning)，或只剩一个，或只剩一类标签，退出    
        his= hist(train_targets, length(Label));  %统计样本的标签，分别属于每个标签的数目  
        [num, largest]= max(his); 
        tree.value= [];    
        tree.location  = [];    
        tree.child= Label(largest);
        return    
    end    
    
    %C4.5
    for i=1:length(Label)
        PD(i)=length(find(train_targets==Label(i)))/L;
    end
    %计算当前节点的信息熵 -∑pi*log2(pi)
    Info_D=-sum(PD.*log2(PD));
    %记录每个特征的信息增益率
    GainRatio=zeros(1,feaNum);
    location=ones(1,feaNum)*inf;
    for i=1:feaNum
        Di=train_features(i,:);
        Si=unique(Di);
        subNum=length(Si);
        
            node=zeros(length(Label),2);
            %排序
            [sorted_data,indx]=sort(Di);
            [sorted_data2,indx2]=sort(Si);
            sorted_targets=train_targets(indx);
        
            GainA=zeros(1,subNum);
            GainRatioA=zeros(1,subNum);

            for j=1:subNum
                N(j)=length(sorted_targets(find(sorted_data==Si(j))));
                if j~=subNum
                    Th(j)=(sorted_data2(j)+sorted_data2(j+1))/2;
                else 
                    Th(j)=sorted_data2(j);
                end
            end
            
            SplitInfoA=-sum((N/L).*log2(N/L));
            for j=1:subNum-1
                node(:, 1) = hist(sorted_targets(find(sorted_data <= Th(j))) , Label);
                node(:, 2) = hist(sorted_targets(find(sorted_data > Th(j))) , Label);
                Ps=sum(node)/L; %|Dv|/|D|
                Ln=sum(node);
                Ln=Ln+eps*(Ln==0);
                %EntD(+)
                InfoDj(1)=-sum(node(:,1)./Ln(1).*log2(eps+node(:,1)/Ln(1)));
                %EntD(-)
                InfoDj(2)=-sum(node(:,2)./Ln(1).*log2(eps+node(:,2)/Ln(2)));
                GainA(j)=Info_D-sum(Ps.*InfoDj);
                GainRatioA(j)=GainA(j)/SplitInfoA;
            end
        [~,s]=max(GainRatioA);
        GainRatio(i)=GainRatioA(s);
        location(i)=Th(s);
    end
    [val,feature_tosplit]=max(GainRatio);
    dims=1:feaNum;
    tree.feature_tosplit=feature_tosplit;
    value=unique(train_features(feature_tosplit,:));
    subNum=length(value);
    tree.value=value;
    tree.location=location(feature_tosplit);
    
    if (subNum == 1)  %无重复的特征值的数目==1，即这个特征只有这一个特征值，就不能进行分裂  
        his= hist(train_targets, length(Label));
        [num, largest]= max(his); 
        tree.value= [];
        tree.location  = [];    
        tree.child= Label(largest); 
        return    
    end    
        %如果当前选择的这个作为分裂特征的特征是个连续特征
        indx1= find(train_features(feature_tosplit,:) <= location(feature_tosplit));  %找到特征值<=分裂值的样本的索引们  
        indx2= find(train_features(feature_tosplit,:) > location(feature_tosplit));
        if ~(isempty(indx1) || isempty(indx2))  %如果<=分裂值 >分裂值的样本数目都不等于0    
            tree.child(1)= buildC45(train_features(dims, indx1), train_targets(indx1),layer+1);
            tree.child(2)= buildC45(train_features(dims, indx2), train_targets(indx2),layer+1);   
        else    
            his= hist(train_targets, length(Label));  %统计当前所有样本的标签，分别属于每个标签的数目 
            [num, largest]= max(his);
            tree.child= Label(largest);   
            tree.feature_tosplit= 0;  %树的分裂特征记为0  
        end 
%     end
end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

