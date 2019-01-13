function tree_plot( p ,nodevalues,features)
%% ²Î¿¼treeplotº¯Êý
Attributes={'SO2','NO','NO2','NOx','PM10','PM2-5'};
[x,y,h]=treelayout(p);
f = find(p~=0);
pp = p(f);
X = [x(f); x(pp); NaN(size(f))];
Y = [y(f); y(pp); NaN(size(f))];
len=length(nodevalues);
X = X(:);
Y = Y(:);
    n = length(p);
    if n < 500,
        hold on ; 
        plot (x, y, 'ro', X, Y, 'r-');
        nodesize = length(nodevalues);
        for i=1:nodesize
            if nodevalues{1,i}~=fix(nodevalues{1,i})
                str=[char(Attributes(cell2mat(features(i)))) '<' char(num2str(nodevalues{1,i})) '   ' char(Attributes(cell2mat(features(i)))) '>=' char(num2str(nodevalues{1,i}))];
                text(x(i)-0.01,y(i),str,'HorizontalAlignment','center'); 
            else
                str=IntToLabel(nodevalues{1,i});
%                 text(x(i)-0.01,y(i),['' num2str(nodevalues{1,i})]);
                text(x(i)-0.01,y(i),str);
            end
%             text(x(i)+0.01,y(i),nodevalues{1,i}); 
        end
        hold off;
    else
        plot (X, Y, 'r-');
    end;

xlabel(['height = ' int2str(h)]);
axis([0 1 0 1]);

end
