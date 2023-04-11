function E_sig_n = Optical_Amplifier(E_sig, OSNR_dB, Noise_BW, Fs_awg, Lamda, C_Light, E_LO_laser, F_THz, draw)
    %> @��Ŵ��������������˲�����

    %> @E_sig, �������ƹ��ź�
    %> @OSNR_dB, ������ȣ���λdB��
    %> @Noise_BW, ��������
    %> @Fs_awg, AWG������
    %> @Lamda, ����������
    %> @E_LO_laser, ���񼤹����ⳡ
    %> @F_THz, ̫�����ز�Ƶ��
    %> @C_Light, ����

    %> @E_sig_n, ��Ŵ������˲���������Ĺ��ź�

    fprintf(1, [' #   ��Ŵ������˲�����ģ��------ ' '\n']);
    fprintf(1, [' ---------------------------\n']);

    OSNR = 10 ^ (OSNR_dB / 10);
    P_sig = mean(abs(E_sig) .^ 2);

    noise_power = (P_sig * Fs_awg) / (2 * Noise_BW * OSNR * 2);
    N = length(E_sig);
    n = 1:N;
    noise = wgn(1, N, noise_power, 'complex', 'linear');
    complex_noise = noise .* exp(1i * (2 * pi * 1 / (Lamda / C_Light) .* n) / Fs_awg);
    E_sig_n = complex_noise + E_sig;

    if draw
        % ���������������źŹ���(��һ��)
        figure;
        Sig_draw = E_sig_n + E_LO_laser;
        datalen = length(Sig_draw);
        fplot = linspace(1 / (Lamda / C_Light) - Fs_awg, 1 / (Lamda / C_Light) + F_THz + Fs_awg, datalen);
        FFT_Ex_1 = fftshift(fft(Sig_draw));
        FFT_Ex = abs(FFT_Ex_1) / (length(Sig_draw));
        FFT_Ex_dB = 10 * log10(FFT_Ex .^ 2);
        plot(fplot ./ 1e9, FFT_Ex_dB, 'black');
        title('���������������źŹ���(��һ��)', 'FontSize', 12);
        xlim([1 / (Lamda / C_Light) - Fs_awg + (F_THz + Fs_awg * 2) / 12 1 / (Lamda / C_Light) + F_THz + Fs_awg] / 1e9);
        xlabel('Ƶ�ʣ�GHz��');
        ylabel('���ʣ�dB��');
        scnsize = get(0, 'ScreenSize');
        set(gcf, 'position', [scnsize(3) / 2 + scnsize(4) / 4 + 4, scnsize(4) / 4, scnsize(4) / 2, scnsize(4) / 3]); % ��ͼ��λ��
    end

end
