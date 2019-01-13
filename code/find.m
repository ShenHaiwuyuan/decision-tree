function [] = find( tree)
    global nodes;
    global num;
    global orders;

    if ~isempty(tree.value)
        num=num+1;
        orders(num)=num;
        nodes(num,:)=[tree.feature_tosplit tree.location];
        find(tree.child(1));
        find(tree.child(2));
    else
        num=num+1
        orders(num)=num;
        nodes(num,:)=[tree.feature_tosplit tree.child];
    end
end

function [number]=BFS(tree)
    idx=1;
    queue=[];
    number=[];
    head=1;
    tail=1;
    queue(tail)=tree;
    tail=tail+1;
    while head~=tail
        tmp=queue(head);
        number(length(number)+1)=idx;
        idx=idx+1;
        head=head+1;
        if ~isempty(tmp.child(1).value)
            queue(tail)=tmp.child(1);   
            tail=tail+1;
        end
        if ~isempty(tmp.child(2).value)
            queue(tail)=tmp.child(2);
            tail=tail+1;
        end
    end
end
