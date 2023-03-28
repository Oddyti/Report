%% ϵͳ���������������

%% ��Ƶ������
Fs_awg = 64e9; % AWG�����Ĳ�����(��λSa/s)
F_THz = 160e9; % ̫�����ز�Ƶ��(��λHz)
Clipping = 0.8; % �����Ŵ������Ͳü�����

%% ������
C_Light = 3e8;   % ���٣���λm/s��
P_sig_dBm = 15; % �������Ƽ�����������ʣ���λdBm��
P_LO_dBm = 14; % ���񼤹���������ʣ���λdBm��
Lamda_sig = 1550E-9; % �������Ƽ�������������λm��
Lamda_LO = 1/(1/(Lamda_sig/C_Light)+F_THz)*C_Light; % ���񼤹�����������λm��;����=ʱ��*����; Ƶ��=1/ʱ��
Phase_sig = 0*pi; % �������Ƽ�������ʼ��λ
Phase_LO = 0*pi; % ���񼤹�����ʼ��λ
Linewidth_sig = 2*pi*500e3; % �������Ƽ������߿�, ��λHz
Linewidth_LO = 2*pi*500e3; % ���񼤹����߿�, ��λHz

%% ��MZM������
Vpi = 3.5;  % MZM������Vpiֵ
Vac = 1; % Vpp���ֵ��С����һ����
Phi_off = pi/45; % IQʧ�����

%% ��Ŵ���
Noise_BW = Fb; % ��������
OSNR_dB = 18; % ������ȣ���λdB��

%% ���̽����
R = 0.003;  % PD ��Ӧ��
kB = 1.3806503e-23; % ������������
qelementary = 1.6021e-19; % ���ӵ��
RL = 50; % ƥ���迹
T = 290; % �����¶�

%% ��Ƶ��
P_THz_LO_dBm = 3; % ���񼤹���������ʣ���λdBm��
F_THz_LO = 132e9; % ̫���ȱ���Ƶ��(��λHz)
SNR_Mixer = 18; % ̫���Ȼ�Ƶ������ȣ���λdB��
THz_LO_Phase = 0*pi; % ̫���ȱ����ʼ��λ
Linewidth_THz_LO = 2*pi*100e3; % ̫���ȱ����߿�
R_THz_Mixer = 0.3; % ̫���Ȼ�Ƶ��ת��Ч��

%% ������ʾ

% uiwait(msgbox({[' # ���̫����ϵͳ������������Ҫ����:'];...
%     [' # ','��Init_System_Parameters�ļ�����'];...
%     [' * ̫�����ź�Ƶ��Ϊ: ',num2str(F_THz/1e9),'GHz'];...
%     [' * AWG������Ϊ: ',num2str(Fs_awg/1e9),'GSa/s'];...
%     [' * �������Ƽ���������Ϊ: ',num2str(Lamda_sig*1e9),'nm'];...
%     [' * �������Ƽ������߿�Ϊ: ',num2str(Linewidth_sig/2/pi/1e3),'kHz'];...
%     [' * ���񼤹����߿�Ϊ: ',num2str(Linewidth_LO/2/pi/1e3),'kHz'];...
%     [' * IQʧ�����Ϊ: ','pi/',num2str(pi/Phi_off)];...
%     [' * �������Ϊ: ',num2str(OSNR_dB),'dB'];...
%     [' * ̫���ȱ���Ƶ��Ϊ: ',num2str(F_THz_LO/1e9),'GHz'];...
%     [' * ̫���Ȼ�Ƶ�������Ϊ: ',num2str(SNR_Mixer),'dB'];...
%     [' * ̫���ȱ����߿�Ϊ: ',num2str(Linewidth_THz_LO/2/pi/1e3),'kHz'];...
%     [' ---------------------------'];...
    
%     [' # ���Ʋ�����Ҫ����:'];...
%     [' # ','��Init_Waveform_Parameters�ļ�����'];...
%     [' * ���Ʋ���Ϊ: ',num2str(M),'QAM'];...
%     [' * �źŲ�����Ϊ: ',num2str(Fb/1e9),'Gbaud'];...
%     [' * ���������Ϊ: ','2^',num2str(log2(num_symb)),'������'];...
%     [' * ������ͷ���Ϊ: ',PulseShaping];...
%     [' ---------------------------'];...
    
%     [' # ����DSP��Ҫ����:'];...
%     [' # ','��Init_DSP_Parameters�ļ�����'];...
%     [' * ���Ծ�����Ϊ: ',Eq_type];...
%     [' * ���Ծ����������Ϊ: ',num2str(Eq_iter),'��'];...
%     [' * ���Ծ����ͷ��Ϊ: ',num2str(Eq_taps),'��'];...
%     [' * ��λ��������Ϊ: ','pi/',num2str(2*BPS_PAR)];...
%     [' * ��λ���ƿ��СΪ: ',num2str(BPS_N)]},'���̫����ϵͳ','help'));

fprintf(1,' # ���̫����ϵͳ������������Ҫ����\n');
fprintf(1,' # ��Init_System_Parameters�ļ�����\n');
fprintf(1,[' * ̫�����ź�Ƶ��Ϊ: ',num2str(F_THz/1e9),'GHz\n']);
fprintf(1,[' * AWG������Ϊ: ',num2str(Fs_awg/1e9),'GSa/s\n']);
fprintf(1,[' * �������Ƽ���������Ϊ: ',num2str(Lamda_sig*1e9),'nm\n']);
fprintf(1,[' * �������Ƽ������߿�Ϊ: ',num2str(Linewidth_sig/2/pi/1e3),'kHz\n']);
fprintf(1,[' * ���񼤹����߿�Ϊ: ',num2str(Linewidth_LO/2/pi/1e3),'kHz\n']);
fprintf(1,[' * IQʧ�����Ϊ: ','pi/',strcat(num2str(pi/Phi_off),'\n')]);
fprintf(1,[' * �������Ϊ: ',num2str(OSNR_dB),'dB\n']);
fprintf(1,[' * ̫���ȱ���Ƶ��Ϊ: ',num2str(F_THz_LO/1e9),'GHz\n']);
fprintf(1,[' * ̫���Ȼ�Ƶ�������Ϊ: ',num2str(SNR_Mixer),'dB\n']);
fprintf(1,[' * ̫���ȱ����߿�Ϊ: ',num2str(Linewidth_THz_LO/2/pi/1e3),'kHz\n']);
fprintf(1,[' ---------------------------\n']);

fprintf(1,[' # ���Ʋ�����Ҫ����\n']);
fprintf(1,[' # ','��Init_Waveform_Parameters�ļ�����\n']);
fprintf(1,[' * ���Ʋ���Ϊ: ',num2str(M),'QAM\n']);
fprintf(1,[' * �źŲ�����Ϊ: ',num2str(Fb/1e9),'Gbaud\n']);
fprintf(1,[' * ���������Ϊ: ','2^',num2str(log2(num_symb)),'������\n']);
fprintf(1,[' * ������ͷ���Ϊ: ',strcat(PulseShaping,'\n')]);
fprintf(1,[' ---------------------------\n']);

fprintf(1,[' # ����DSP��Ҫ����\n']);
fprintf(1,[' # ','��Init_DSP_Parameters�ļ�����\n']);
fprintf(1,[' * ���Ծ�����Ϊ: ',strcat(Eq_type,'\n')]);
fprintf(1,[' * ���Ծ����������Ϊ: ',num2str(Eq_iter),'��\n']);
fprintf(1,[' * ���Ծ����ͷ��Ϊ: ',num2str(Eq_taps),'��\n']);
fprintf(1,[' * ��λ��������Ϊ: ','pi/',strcat(num2str(2*BPS_PAR),'\n')]);
fprintf(1,[' * ��λ���ƿ��СΪ: ',strcat(num2str(BPS_N),'\n')]);
fprintf(1,[' ---------------------------\n']);
