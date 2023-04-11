function E_sig = IQ_Optical_Modulator(Sig, Clipping, Vac, Vpi, Phi_off, E_laser, Fs_awg, Lamda, E_LO_laser, F_THz, C_Light, draw)
    %> @IQ-MZM�����������

    %> @Sig, MZM���ƵĻ����ź�
    %> @Clipping, �����Ŵ������Ͳü�����
    %> @Vac, Vpp���ֵ��С����һ����
    %> @Vpi, MZM������Vpiֵ
    %> @Phi_off, IQʧ�����
    %> @E_laser, ����MZM�ļ������ⳡ
    %> @Fs_awg, AWG������
    %> @Lamda, ����������
    %> @E_LO_laser, ���񼤹����ⳡ
    %> @F_THz, ̫�����ز�Ƶ��
    %> @C_Light, ����

    %> @E_sig, �������ƹ��ź�

    % uiwait(msgbox('���뷢�Ͷ˹����(IQ�������)','��ʾ','help'));
    close all;
    fprintf(1, [' #   IQ���������ģ��------ ' '\n']);
    fprintf(1, [' ---------------------------\n']);

    Sig_Real = real(Sig); % QAM�����źŵ�ʵ��
    % QAM�����źŵ�ʵ���ü�
    Sig_Real_Max = max(Sig_Real);

    for i = 1:length(Sig_Real)

        if Sig_Real(i) > Sig_Real_Max * Clipping
            Sig_Real(i) = Sig_Real_Max * Clipping;
        end

    end

    Sig_Imag = imag(Sig); % QAM�����źŵ��鲿

    % QAM�����źŵ��鲿�ü�
    Sig_Imag_Max = max(Sig_Imag);

    for i = 1:length(Sig_Imag)

        if Sig_Imag(i) > Sig_Imag_Max * Clipping
            Sig_Imag(i) = Sig_Imag_Max * Clipping;
        end

    end

    Sig_Real_N = Vac / max(abs(Sig_Real + 1i * Sig_Imag)) .* Sig_Real; % ʵ����һ��
    Sig_Imag_N = Vac / max(abs(Sig_Real + 1i * Sig_Imag)) .* Sig_Imag; % �鲿��һ��

    Voff = Vpi * (2/2) + 0 * Vpi; % ƫ�õ�ѹ��2/2ȷ���ز�����

    MZM_I = cos(pi / 2 .* (Sig_Real_N + Voff) ./ Vpi); % MZM-I���ź�
    MZM_Q = cos(pi / 2 .* (Sig_Imag_N + Voff) ./ Vpi); % MZM-Q���ź�

    MZM_mod = MZM_I + MZM_Q .* exp(1i * (pi / 2 + Phi_off)); % MZM�����ź�

    E_sig = E_laser .* MZM_mod'; % MZM����Ļ������ƹ��ź�

    if draw
        % ����QAM���ƹ��źŹ���(��һ��)
        figure;
        Sig_draw = MZM_mod;
        datalen = length(Sig_draw);
        fplot = linspace(1 / (Lamda / C_Light) - Fs_awg / 2, 1 / (Lamda / C_Light) + Fs_awg / 2, datalen);
        FFT_Ex_1 = fftshift(fft(Sig_draw));
        FFT_Ex = abs(FFT_Ex_1) / (length(Sig_draw));
        FFT_Ex_dB = 10 * log10(FFT_Ex .^ 2);
        plot(fplot ./ 1e9, FFT_Ex_dB, 'r');
        title('����QAM���ƹ��źŹ���(��һ��)', 'FontSize', 12);
        xlabel('Ƶ�ʣ�GHz��');
        ylabel('���ʣ�dB��');
        xlim([1 / (Lamda / C_Light) - Fs_awg / 2 1 / (Lamda / C_Light) + Fs_awg / 2] / 1e9);
        scnsize = get(0, 'ScreenSize');
        set(gcf, 'position', [scnsize(3) / 2 - scnsize(4) * 3/4, scnsize(4) / 4, scnsize(4) / 2, scnsize(4) / 3]); % ��ͼ��λ��

        % ����źŹ���(��һ��)
        figure;
        Sig_draw = E_sig + E_LO_laser;
        datalen = length(Sig_draw);
        fplot = linspace(1 / (Lamda / C_Light) - Fs_awg, 1 / (Lamda / C_Light) + F_THz + Fs_awg, datalen);
        FFT_Ex_1 = fftshift(fft(Sig_draw));
        FFT_Ex = abs(FFT_Ex_1) / (length(Sig_draw));
        FFT_Ex_dB = 10 * log10(FFT_Ex .^ 2);
        plot(fplot ./ 1e9, FFT_Ex_dB, 'm');
        title('����źŹ���(��һ��)', 'FontSize', 12);
        xlim([1 / (Lamda / C_Light) - Fs_awg + (F_THz + Fs_awg * 2) / 12 1 / (Lamda / C_Light) + F_THz + Fs_awg] / 1e9);
        xlabel('Ƶ�ʣ�GHz��');
        ylabel('���ʣ�dB��');
        set(gcf, 'position', [scnsize(3) / 2 - scnsize(4) / 4 + 2, scnsize(4) / 4, scnsize(4) / 2, scnsize(4) / 3]); % ��ͼ��λ��

    end

end
