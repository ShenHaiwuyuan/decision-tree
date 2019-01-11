function [ matrix ] = arrayToMatrix( vec )
%ARRAYTOMATRIX Summary of this function goes here
%   Detailed explanation goes here
    
    n=size(vec);
    matrix=zeros(7,n);
    
    for i=1:n
        matrix(vec(i),i)=1;
    end
end

