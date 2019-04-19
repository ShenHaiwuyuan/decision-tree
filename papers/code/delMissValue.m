function [res] = delMissValue( data)
%DELMISSVALUE Summary of this function goes here
%   Detailed explanation goes here
    [m,n]=size(data);
    for i=1:m
        for j=1:n-1
            if data(i,j)==0
                tmp=data(find(data(:,7)==data(i,7)&data(:,j)~=0),:);
                data(i,j)=mean(tmp(:,j));
            end
        end
    end
    res=data;
end

