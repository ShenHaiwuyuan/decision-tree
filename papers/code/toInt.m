function [ res ] = toInt( label )
%参数：罗马数字
%返回：阿拉伯数字 
    n=size(label);
    res=zeros(n);
    for i=1:size(label)
        if strcmp(label(i), 'I')
            res(i)=1;
        elseif strcmp(label(i), 'II')
            res(i)=2;
        elseif strcmp(label(i), 'III')
            res(i)=3;
        elseif strcmp(label(i), 'IV')
            res(i)=4;
        elseif strcmp(label(i), 'V')
            res(i)=5;
        elseif strcmp(label(i), 'VI')
            res(i)=6;
        elseif strcmp(label(i), 'VII')
            res(i)=7;
        end
    end
end