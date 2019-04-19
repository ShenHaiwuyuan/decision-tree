function [result]=AUC(x,y)
%º∆À„AUC÷µ
    
    n=length(x);
    result=0;
    for i=2:n
        result=result+abs(x(i)-x(i-1))*y(i);
    end
end