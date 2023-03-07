clear;clc;echo off;close all;
%% -------------ѵ�������������-------------------------------
N=1000;                             %ָ���ź����г���
info=randsrc(1,N,[-1 1;.5 .5]);      %�����������ź�����
SNR_in_dB = 3;

for j=1:length(SNR_in_dB)
    y=channel(info,SNR_in_dB(j));        %ͨ���ŵ�
    NNLen=30;
    N=length(info);
    P=[];
    for i=1:(N-NNLen)
        P=[P y(i:i+NNLen-1)'];
        T(i)=info(i);
    end
    net=newff(minmax(P),[10,1],{'tansig','tansig','purelin'},'trainlm');
    net.trainParam.show = 10;
    net.trainParam.epochs=100;%��������
    net.trainParam.goal=0.0001;
    net.trainParam.lr=0.01;%ѧϰ��
    [net,tr]=train(net,P,T);
    plotperform(tr)
end

%% -------------ѵ����ɣ���ʼ����-------------------------------
SNR_in_dB=8:1:18; 

N=10000;                             %ָ���ź����г���
for j=1:length(SNR_in_dB)
    %----- ��ͷ�ӳ��ߣ�׼��������������--------
    info=randsrc(1,N,[-1 1;.5 .5]);      %�����������ź�����
    y=channel(info,SNR_in_dB(j));        %ͨ���ŵ�
    N=length(info);
    P=[];
    for i=1:(N-NNLen)
        P=[P y(i:i+NNLen-1)'];
    end
    
    
    a=sim(net,P);   %----- ��������� ----------
    
    %----- ������������--------
    numoferr_NN=0;           %�������Ԫ����
    for i=1:length(a),
        if (a(i)<0),
            decis=-1;
        else
            decis=1;
        end;
        if (decis~=info(i)),
            numoferr_NN=numoferr_NN+1;
        end;
    end;
    Pe1_NN(j)=numoferr_NN/N;                   % ������Ӧ����������󣬵õ���������

    %----- �޾����������--------
    numoferr = 0;                       %��ʼ����ͳ����
    for i=1:N                  %�ӵ�len����Ԫ��ʼΪ��ʵ�ź���Ԫ
        if (y(i)<0),                    %�о�����
            decis=-1;
        else
            decis=1;
        end;
        if (decis~=info(i)),             %�ж��Ƿ����룬ͳ��������Ԫ����
            numoferr=numoferr+1;
        end;
    end;
    Pe(j)=numoferr/N;                   % δ�����������⣬�õ���������
end

%% --------------------------------------------
figure
semilogy(SNR_in_dB,Pe1_NN, '--+');        %����Ӧ����������֮�������ʽ��ͼ
hold on;
semilogy(SNR_in_dB,Pe,'blue--d');           %δ���������������ʽ��ͼ
hold on;

xlabel('SNR in dB');
ylabel('Pe');
legend('������Ӧ����������','δ������������');