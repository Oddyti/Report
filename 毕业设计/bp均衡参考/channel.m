function [y,len]=channel(x,snr_in_dB)
SNR=exp(snr_in_dB*log(10)/10);    %�������ֵת��
sigma=1/sqrt(2*SNR);              %��˹�������ı�׼��
%ָ���ŵ���ISI���������Կ������ŵ��������ǱȽϲ��
actual_isi=[1 -0.063 0.088 -0.126 -0.25 0.9025 0.25 0 0.126 0.038 0.088];
% actual_isi=[1 0.18 0.35 0.18 -0.25];
len_actual_isi = length(actual_isi);
len = len_actual_isi;
y=conv(actual_isi,x);               %�ź�ͨ���ŵ����൱���ź��������ŵ�ģ�����������
%��Ҫָ������ʱ��Ԫ���г��ȱ�ΪN+len-1������ʱ���Ǵӵ�len����Ԫ��ʼ��N+len������
for i=1:2:(size(y,2) + 1),       
    [noise(i) noise(i+1)]=gngauss(sigma);   %��������
end;
y = y + noise(1:length(y));                            %��������
end