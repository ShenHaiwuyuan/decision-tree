function accuracy=cal_accuracy(test_targets,test_targets_predict)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %计算决策树分类算法的准确度
    %test_targets:测试数据集的实际所属类别
    %test_targets_predict:决策树算法所预测的测试数据集的所属类别
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    right=0;
    for j=1:size(test_targets_predict,2)  
        if test_targets(:,j)==test_targets_predict(:,j)  
            right=right+1;  
        end  
    end
    accuracy=right/size(test_targets,2);
end