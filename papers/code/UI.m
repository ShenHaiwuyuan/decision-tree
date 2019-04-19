function varargout = UI(varargin)
% UI MATLAB code for UI.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI

% Last Modified by GUIDE v2.5 20-Feb-2019 21:41:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI (see VARARGIN)

% Choose default command line output for UI
handles.output = hObject;
% Update handles structure
% img=imread('./imgs/bg.jpg');
% image(img);

load './save/train_features.mat' train_features;
load './save/train_targets.mat' train_targets;
% load './save/test_features.mat' test_features;
% load './save/test_targets.mat' test_targets;
load './save/discrete_dim.mat' discrete_dim;
handles.train_features=train_features;
handles.train_targets=train_targets;
% handles.test_features=test_features;
% handles.test_targets=test_targets;
handles.test_features=[];
handles.test_targets=[];
handles.discrete_dim=discrete_dim;

load './save/newc45Tree.mat' newc45Tree;
handles.newc45Tree=newc45Tree;
[nodeids,nodevalues,features] = print_tree(handles.newc45Tree);

tree_plot(nodeids,nodevalues,features);
% UIWAIT makes UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');

%% 各算法性能比较
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.test_features)
    h=msgbox('请加载测试数据！');
    return;
end
% 1.ID3
handles.id3Tree=ID3(handles.train_features,handles.train_targets);
handles.test_predict1= predict(handles.id3Tree,handles.test_features, 1:size(handles.test_features,2));
% 2.LM
handles.lmNet=LM(handles.train_features,arrayToMatrix(handles.train_targets'));
handles.test_predict2=sim(handles.lmNet,handles.test_features);
% 3.BP
handles.bpNet=BP(handles.train_features,arrayToMatrix(handles.train_targets'));
handles.test_predict3=sim(handles.bpNet,handles.test_features);

handles.test_predict= predict(handles.newc45Tree,handles.test_features, 1:size(handles.test_features,2));

figure;
subplot(1,2,1);
[AUC1,FPR1,TPR1]=plot_roc(arrayToMatrix(handles.test_predict1'),arrayToMatrix(handles.test_targets'));
[AUC2,FPR2,TPR2]=plot_roc(arrayToMatrix(handles.test_predict'),arrayToMatrix(handles.test_targets'));
[AUC3,FPR3,TPR3]=plot_roc(handles.test_predict2,arrayToMatrix(handles.test_targets'));
[AUC4,FPR4,TPR4]=plot_roc(handles.test_predict3,arrayToMatrix(handles.test_targets'));
plot(FPR1,TPR1,'r-',FPR2, TPR2,'b-',FPR3,TPR3,'g-',FPR4,TPR4,'y-');
legend('ID3','改进版C4.5','LM神经网络','BP神经网络');
xlabel('假正例率(FPR)');
ylabel('真正例率(TPR)');
title('ROC曲线');

subplot(1,2,2);
[precision1,recall1]=plot_pr(arrayToMatrix(handles.test_predict1'),arrayToMatrix(handles.test_targets'));
[precision2,recall2]=plot_pr(arrayToMatrix(handles.test_predict'),arrayToMatrix(handles.test_targets'));
[precision3,recall3]=plot_pr(handles.test_predict2,arrayToMatrix(handles.test_targets'));
[precision4,recall4]=plot_pr(handles.test_predict3,arrayToMatrix(handles.test_targets'));
plot(precision1,recall1,'r-',precision2,recall2,'b-',precision3,recall3,'g-',precision4,recall4,'y-');
legend('ID3','改进版C4.5','LM神经网络','BP神经网络');
xlabel('精确率');
ylabel('召回率');
title('PR曲线');
figure;
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
so2=str2num(get(handles.edit1,'String'));
no=str2num(get(handles.edit3,'String'));
no2=str2num(get(handles.edit4,'String'));
nox=str2num(get(handles.edit5,'String'));
pm10=str2num(get(handles.edit6,'String'));
pm2_5=str2num(get(handles.edit7,'String'));

data=[so2 no no2 nox pm10 pm2_5];  
test_predict= predict(handles.newc45Tree,data', 1:size(data',2), handles.discrete_dim);
set(handles.edit2,'String',IntToLabel(test_predict));


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
%% 混淆矩阵
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.test_features)
    h=msgbox('请加载测试数据！');
    return;
end
handles.test_predict= predict(handles.newc45Tree,handles.test_features, 1:size(handles.test_features,2));
figure;
plotconfusion(arrayToMatrix(handles.test_predict'),arrayToMatrix(handles.test_targets'));
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.test_features)
    h=msgbox('请加载测试数据！');
    return;
end
figure;
[AUC,FPR,TPR]=plot_roc(arrayToMatrix(handles.test_predict'),arrayToMatrix(handles.test_targets'));
plot(FPR,TPR,'b-');
legend('改进版C4.5');
xlabel('假正例率(FPR)');
ylabel('真正例率(TPR)');
title('ROC曲线');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.test_features)
    h=msgbox('请加载测试数据！');
    return;
end
figure;
[precision,recall]=plot_pr(arrayToMatrix(handles.test_predict'),arrayToMatrix(handles.test_targets'));
plot(precision,recall,'r-');
legend('改进版C4.5');
xlabel('精确率');
ylabel('召回率');
title('PR曲线');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.test_features)
    h=msgbox('请加载测试数据！');
    return;
end
accuracy=cal_accuracy(handles.test_targets,handles.test_predict);
str=strcat('精确率：',num2str(accuracy));
h=msgbox(str);


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('.xls','选择测试数据');
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
    return;
end
datafile=[pathname filename]
%% 数据预处理
[data,txt]=xlsread(datafile);
label=toInt(txt(2:size(txt),7)); 
orginal=cat(2,data,label);
orginal=delMissValue(orginal);
handles.test_targets
% % 提取features和targets
% [trainData,testData]=splitData(orginal);
% % 提取features和targets
% handles.train_features=trainData(:,1:(size(trainData,2)-1))';  
% handles.train_targets=trainData(:,size(trainData,2))';
% handles.test_features=testData(:,1:(size(testData,2)-1))';  
% handles.test_targets=testData(:,size(testData,2))';
% handles.test_targets
handles.test_features=orginal(:,1:(size(orginal,2)-1))';  
handles.test_targets=orginal(:,size(orginal,2))'
handles.test_predict= predict(handles.newc45Tree,handles.test_features, 1:size(handles.test_features,2));
guidata(hObject, handles);
h=msgbox('数据加载完成！');
