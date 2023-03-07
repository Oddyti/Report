clc;
clear;

t=0:0.01:10;
s1=sin(2*pi*t);
s2=sin(10*pi*t);
s3=sin(20*pi*t);
s=s1+s2+s3;%����ź�

NNLen=30;
N=length(s3);
P=[];
for i=1:(N-NNLen)
    P=[P s(i:i+NNLen-1)'];
    T(i)=s3(i);
end
net=newff(minmax(P),[10,1],{'tansig','tansig','purelin'},'trainlm'); 
net.trainParam.show=10;
net.trainParam.epochs=100;
net.trainParam.goal=0.001;
net.trainParam.lr=0.01;
[net,tr]=train(net,P,T);%������źŽ���BP����ѵ����Ŀ��ֵΪs1
plotperf(tr);%�õ��������
a=sim(net,P);%��������������
figure(1);
subplot(2,1,1);
plot(t,s3);
xlabel('ʱ�� t');
ylabel('��ֵ');
title('ԭʼ�ź�');
subplot(2,1,2);
plot(a,':');
xlabel('������n');
ylabel('��ֵ');
title('������������ź�');