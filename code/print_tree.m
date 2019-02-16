function [nodeids_,nodevalue_,features_] = print_tree(tree)
%% 打印树，返回树的关系向量
clear global nodeid nodeids nodevalue features;
global nodeid nodeids nodevalue features;
nodeids(1)=0; % 根节点的值为0
nodeid=0;
nodevalue={};
features=[];
if isempty(tree) 
    disp('空树！');
    return ;
end

queue = queue_push([],tree);
while ~isempty(queue) % 队列不为空
     [node,queue] = queue_pop(queue); % 出队列
     visit(node,queue_curr_size(queue));
     if isstruct(node.child)&&~strcmp(node.child(1),'null') % 左子树不为空
        queue = queue_push(queue,node.child(1)); % 进队
     end
     if isstruct(node.child)&&~strcmp(node.child(2),'null') % 左子树不为空
         queue = queue_push(queue,node.child(2)); % 进队
     end
end

%% 返回 节点关系，用于treeplot画图
nodeids_=nodeids;
nodevalue_=nodevalue;
features_=(features);
end

function visit(node,length_)
%% 访问node 节点，并把其设置值为nodeid的节点
    global nodeid nodeids nodevalue features;
    if isleaf(node)
        nodeid=nodeid+1;
%         disp('leaf')
%         fprintf('叶子节点，node: %d\t，属性值: %d\n', ...
%         nodeid, node.child);
        nodevalue{1,nodeid}=node.child;
        features{1,nodeid}=0;
    else % 要么是叶子节点，要么不是
        %if isleaf(node.left) && ~isleaf(node.right) % 左边为叶子节点,右边不是
        nodeid=nodeid+1;
        nodeids(nodeid+length_+1)=nodeid;
        nodeids(nodeid+length_+2)=nodeid;
%         fprintf('node: %d\t属性值: %s\t，左子树为节点：node%d，右子树为节点：node%d\n', ...
%         nodeid, node.location,nodeid+length_+1,nodeid+length_+2);
        nodevalue{1,nodeid}=node.location;
        features{1,nodeid}=node.feature_tosplit;
    end
end

function flag = isleaf(node)
%% 是否是叶子节点
%     if strcmp(node.child(1),'null') && strcmp(node.child(2),'null') % 左右都为空
%     if ~isstruct(node.child)&&
    if ~isstruct(node.child)
        flag =1;
    else
        flag=0;
    end
end

function [ newqueue ] = queue_push( queue,item )
%% 进队

% cols = size(queue);
% newqueue =structs(1,cols+1);
newqueue=[queue,item];
end

function [ item,newqueue ] = queue_pop( queue )
%% 访问队列

if isempty(queue)
    disp('队列为空，不能访问！');
    return;
end

item = queue(1); % 第一个元素弹出
newqueue=queue(2:end); % 往后移动一个元素位置

end

function [ length_ ] = queue_curr_size( queue )
%% 当前队列长度

length_= length(queue);

end