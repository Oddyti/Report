%% �����ʼ��
% �����ʼ��
Program_Init;

% ȫ�ֱ�������
Init_Waveform_Parameters; % �ź��벨�β���
Init_DSP_Parameters; % DSP�������
Init_System_Parameters; % ϵͳ�����豸�Լ�����ģ�����

%% QAM����
[tx_data, tx_sig] = QAM_Modulator(PRBS, num_symb, bits_per_sym, coding, draw);

%% QAM�ź�������ͣ���AWG������ͣ�
tx_waveform_awg = QAM_Pulse_Shaping(tx_sig, Nss, PulseShaping, txrolloff, Nsym, Fs_awg, Fs, draw);

%% ������������
% �������Ƽ�����
E_sig_laser = CW_Laser(Lamda_sig, P_sig_dBm, Phase_sig, Linewidth_sig, length(tx_waveform_awg), 1 / Fs_awg, C_Light, 0, draw);

% ���񼤹���
E_LO_laser = CW_Laser(Lamda_LO, P_LO_dBm, Phase_LO, Linewidth_LO, length(tx_waveform_awg), 1 / Fs_awg, C_Light, 1, draw);

%% IQ�������
E_sig = IQ_Optical_Modulator(tx_waveform_awg, Clipping, Vac, Vpi, Phi_off, E_sig_laser, Fs_awg, Lamda_sig, E_LO_laser, F_THz, C_Light, draw);

%% ��Ŵ������˲���
E_sig_n = Optical_Amplifier(E_sig, OSNR_dB, Noise_BW, Fs_awg, Lamda_sig, C_Light, E_LO_laser, F_THz, draw);

%% ���̽����
E_THz = Photodetector(E_sig_n, E_LO_laser, P_sig_dBm, kB, qelementary, RL, T, R, Fs_awg, F_THz, draw);

%% ��Ƶ��
E_IF = Mixer_Rec(E_THz, R_THz_Mixer, P_THz_LO_dBm, F_THz, F_THz_LO, SNR_Mixer, 1 / Fs_awg, THz_LO_Phase, Linewidth_THz_LO, draw);

%% �����±�Ƶ���˲�
E_Base = Digital_Mixer(F_THz, F_THz_LO, E_IF, 1 / Fs_awg, Fb, draw);

%% IQʧ�ⲹ��
E_Base_IQC = IQ_Imbalance_Comp(E_Base);

%% ʱ��ͬ����ָ�
E_Dec = Time_Recovery(E_Base_IQC, Fs_awg, Fs, Fb, Nsym, txrolloff, Nss, draw);

%% ���Ծ���
[E_est, ~] = Linear_Equalizer(E_Dec, Eq_type, Eq_iter, Eq_CMA_Delay, Eq_taps, Eq_mu, Eq_Adaptive_mu, Eq_conv, M, draw);

%% Ƶƫ�����Լ����벹��
[E_CPR, ~] = Carrier_Recovery(E_est, BPS_PAR, BPS_N, M, Fb, draw);

%% ���Ծ���
[E_final, ~] = Linear_Equalizer(E_CPR, Eq_type, Eq_iter, Eq_CMA_Delay, Eq_taps, Eq_mu, Eq_Adaptive_mu, Eq_conv, M, draw);

%% ������������
Transmission_Performance; 
