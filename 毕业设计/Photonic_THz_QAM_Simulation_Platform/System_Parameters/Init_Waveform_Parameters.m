%% ϵͳ���������Ʋ��Σ�

% ���Ͷ˵��Ʋ���

M = 16; % QAM���ƽ�������Ϊ4��16��32��64��
bits_per_sym = log2(M); % QAM�ź�ÿ���ű�����
coding = 'bin'; % QAM���ƽṹ�壬��ѡӳ������Ϊ'gray'��'bin'
PRBS = importdata('Data_Traces/tx_seq_mix_train.mat'); % ����α���������Ϊ�ź�Դ�����������PRBS15��Ϊpattern������Ϊ2^15-1=32767
PRBS = [PRBS;0]; % ��0��ȫΪż������

Fb = 25e9;  % QAM�źŵĲ�����
Tb = 1/Fb;  % QAM�ź�һ�����ŵ�ʱ������
Fs = Fb*2; % QAM�źŵ�ԭʼ����Ƶ��
Ts = 1/Fs; % QAM�źŵ�ԭʼ����Ƶ���µ�һ�����ŵ�ʱ������
num_symb = 2^17; % QAM�źŵķ�����
Nss = Fs/Fb; % QAM�źŵ�ԭʼ����Ƶ���µĹ�������

PulseShaping = 'RRC'; % 'No_Shaping'|'Rcos' |'RRC'������͵ķ���
txrolloff = 0.15; % ������͵Ĺ���ϵ����ȡֵ0~1֮�䣬����Ƶ��Ͷ��ͳ̶�
Nsym = 40; % ������ͽضϵķ��ŷ�Χ
