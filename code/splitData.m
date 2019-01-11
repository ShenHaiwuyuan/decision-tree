function [train,test] = splitData( data)

%将数据划分为训练集和测试集，比例7:3（由于数据量小）
%参数：待划分数据
%返回值：训练集和测集  
    train_index=randperm(length(data),floor(length(data)/10*7));
    test_index=setdiff(linspace(1,length(data),length(data)),train_index);
    train=data(train_index,:);
    test=data(test_index,:);
end

