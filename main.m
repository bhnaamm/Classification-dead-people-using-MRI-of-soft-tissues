
%------------------------------------------------------------
%    Author: Behnam Anjomruz
%    Email: behnam.anjomruz@gmail.com
%------------------------------------------------------------

close all;
clear all;
clc



%% reading Data

DB = 'data.xlsx';
sheet = 1;
% xlsRange = 'C:D';
imgs=load('inpts.mat');
Data = xlsread(DB, sheet);
Data(:,1)=[]; %removes the IDs
Data(:,1)=[]; %removes the Dates of Birth
% Data(:,1)=[]; %remove the gender
Data=[Data imgs.inpts];
[L W]=size(Data);


for i=1:L
    if (Data(i,2)==1)
        Targets(i,:)=[1,0];
    else
%         if (0<=age && age<20)
%             Targets(i,:)=T2(6,:);
%         elseif (20<=age && age<30)
%             Targets(i,:)=T2(7,:);
%         elseif (30<=age && age<40)
%             Targets(i,:)=T2(8,:);
%         elseif (40<=age && age<50)
%             Targets(i,:)=T2(9,:);
%         else
%             Targets(i,:)=T2(10,:);
%         end
        Targets(i,:)=[0,1];
    end
end
% Data1=Data;
% Data(:,1)=[]; %removes the age
Data(:,2)=[]; %removes the gender
% Data(:,1)=[]; %removes the Weigth
% Targets=Targets';
% Inputs=reshape(Data.',[],1);
% Inputs=Inputs';
Inputs = Data';
Targets = Targets';

%%
% 1st neural net which classifies males and femals
hiddenLayerSize = 14;
net = patternnet(hiddenLayerSize);



net.divideParam.trainRatio = 62/100;
net.divideParam.valRatio = 14/100;
net.divideParam.testRatio = 14/100;

[net,tr] = train(net,Inputs,Targets);


y = net(Inputs);




e = gsubtract(Targets,y);
tind = vec2ind(Targets);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);
performance = perform(net,Targets,y)

% View the Network
view(net)


% Plots
figure, plotperform(tr)
figure, plottrainstate(tr)
figure, plotconfusion(Targets,y)
figure, plotroc(Targets,y)
figure, ploterrhist(e)
%%
%In this part, we gathered outputs of 1st ANN as inputs for 2nd ANN

for j=1:L
    if (y(1,j)>=y(2,j))
        DataM(:,j)=Inputs(:,j);
    else
        DataF(:,j)=Inputs(:,j);
    end
end
con=zeros(26,1);
DataM(:,all(DataM==0))=[];
DataF(:,all(DataF==0))=[];

T=ones([1 3]);
T2=diag(T);
[sM LM]=size(DataM);
[sF LF]=size(DataF);

%%
% Net for males clissified from 1st step
% 
% for i=1:LM
%     age=DataM(1,i);
%     if (0<=age && age<30)
%         TargetsM(i,:)=T2(1,:);
%     elseif (30<=age && age<50)
%         TargetsM(i,:)=T2(2,:);
% %     elseif (30<=age && age<40)
% %         TargetsM(i,:)=T2(3,:);
% %     elseif (40<=age && age<50)
% %         TargetsM(i,:)=T2(4,:);
%     else
%         TargetsM(i,:)=T2(3,:);
%     end
% end
% DataM(:,1)=[]; %Remove gender field
% DataM(:,1)=[]; %Remove weigth field
% TargetsM(1,:)=[];
% TargetsM(1,:)=[];
% 
% 
% InputsM = DataM;
% TargetsM = TargetsM';
% 
% 
% hiddenLayerSizeM = 20;
% netM = patternnet(hiddenLayerSize);
% 
% 
% 
% netM.divideParam.trainRatio = 50/100;
% netM.divideParam.valRatio = 25/100;
% netM.divideParam.testRatio = 25/100;
% 
% [netM,tr] = train(netM,InputsM,TargetsM);
% 
% 
% yM = netM(InputsM);

%%
% Net for females clissified from 1st step


for i=1:LF
    age=DataF(1,i);
    if (0<=age && age<30)
        TargetsF(i,:)=T2(1,:);
    elseif (30<=age && age<50)
        TargetsF(i,:)=T2(2,:);
%     elseif (30<=age && age<40)
%         TargetsF(i,:)=T2(3,:);
%     elseif (40<=age && age<50)
%         TargetsF(i,:)=T2(4,:);
    else
        TargetsF(i,:)=T2(3,:);
    end
end
DataF(:,1)=[]; %Remove gender field
DataF(:,1)=[]; %Remove weigth field

TargetsF(1,:)=[];
TargetsF(1,:)=[];
% DataF(:,1)=[]; %Remove gender field
% TargetsF(1,:)=[];

InputsF = DataF;
TargetsF = TargetsF';


hiddenLayerSizeF = 14;
netF = patternnet(hiddenLayerSize);



netF.divideParam.trainRatio = 50/100;
netF.divideParam.valRatio = 10/100;
netF.divideParam.testRatio = 35/100;

[netF,trF] = train(netF,InputsF,TargetsF);


yF = netF(InputsF);

%%

eF = gsubtract(TargetsF,yF);
tind = vec2ind(TargetsF);
yind = vec2ind(yF);
percentErrors = sum(tind ~= yind)/numel(tind);
performance = perform(netF,TargetsF,yF)

% View the Network
view(netF)


% Plots
figure, plotperform(trF)
figure, plottrainstate(trF)
figure, plotconfusion(TargetsF,yF)
figure, plotroc(TargetsF,yF)
figure, ploterrhist(eF)
