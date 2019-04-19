function [net] = BP(train_features,train_targets)
    
    net = newff(train_features,train_targets,20); %构建BP神经网络
    net.trainParam.show=50;%显示训练迭代过程
    net.trainParam.lr=0.05;%学习率
    net.trainParam.epochs=300;%最大训练次数
    net.trainParam.goal=1e-5;%训练要求精度
    net.trainParam.showWindow=0; %不显示窗口
    [net,tr]=train(net,train_features,train_targets);%网络训练
    
    W1=net.lw{1,1};%输入层到中间层的权值
    B1=net.b{1};%中间各层神经元阈值
    W2=net.lw{2,1};%中间层到输出层的权值
    B2=net.b{2};%输出层各神经元阈值
end

