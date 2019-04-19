function [ out ] = delZero( data)
%DELZERO Summary of this function goes here
%   Detailed explanation goes here

    [m,n]=size(data);
    id=data(:,7)==0;
    data(id,:)=[];
    out=data;
end

