function [ res ] = labelToInt( label )
%LABELTOINT Summary of this function goes here
%   Detailed explanation goes here

    %参数：罗马数字
%返回：阿拉伯数字 
    n=size(label);
    res=zeros(n);
    for i=1:size(label)
        if strcmp(label(i), '无')
            res(i)=1;
        elseif strcmp(label(i), '优')
            res(i)=2;
        elseif strcmp(label(i), '良')
            res(i)=3;
        elseif strcmp(label(i), '轻度污染')
            res(i)=4;
        elseif strcmp(label(i), '中度污染')
            res(i)=5;
        elseif strcmp(label(i), '重度污染')
            res(i)=6;
        elseif strcmp(label(i), '严重污染')
            res(i)=7;
        end
    end
end

