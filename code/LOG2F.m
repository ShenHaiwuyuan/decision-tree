function [ out] = LOG2F(A)
%LOG2F Summary of this function goes here
%   Detailed explanation goes here
%     [M,N]=size(A);
%     if M==1&&N==1
%         out=(A-1)/log(2);
%     else
% %         for i=1:M
% %             for j=1:N
% %                 out(i,j)=(A(i,j)-1)/log(2);
% %             end
% %         end

        out=(A-1)/log(2);
%     end
end

