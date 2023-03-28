function E_THz = Photodetector(E_sig_n,E_LO_laser,P_dBm,kB,qelementary,RL,T,R,Fs_awg,F_THz,draw)
%> @���̽��������

%> @E_sig_n, ��Ŵ������˲���������Ĺ��ź�
%> @E_LO_laser, ���񼤹����ⳡ
%> @P_dBm, ����������(��λdBm)
%> @R, PD ��Ӧ��
%> @kB, ������������
%> @qelementary, ���ӵ��
%> @RL, ƥ���迹
%> @T, �����¶�
%> @Fs_awg, AWG������
%> @F_THz, ̫�����ز�Ƶ��

%> @E_THz, ���̫�����ź�

% uiwait(msgbox('����̫������Ƶ�շ�','��ʾ','help'));
close all;
fprintf(1,[' #   ���̽������ģ��------ ' '\n']);
fprintf(1,[' ---------------------------\n']);

E_THz_1 = 2*R*(E_LO_laser).*conj(E_sig_n); % PD������̫�����źų�

shot_noise_tx = 2*qelementary*R*(10^(P_dBm/10)*0.001)*Fs_awg/2; % ɢ������
thermal_noise_tx = ((4*kB*T)/RL)*Fs_awg/2; % ������
N = length(E_THz_1);
E_N1 = wgn(N,1,shot_noise_tx,'linear')';
E_N2 = wgn(N,1,thermal_noise_tx,'linear')';

E_THz = E_THz_1+E_N1+E_N2; %����PD������̫�����ź�

if draw
    % ̫�����źŵ���(��һ��)
    figure;
    Sig_draw = E_THz;
    datalen = length(Sig_draw);
    fplot = linspace(F_THz-Fs_awg/2,F_THz+Fs_awg/2,datalen);
    FFT_Ex_1 = fft(Sig_draw);
    FFT_Ex = abs(FFT_Ex_1)/(length(Sig_draw));
    FFT_Ex_dB = 10*log10(FFT_Ex.^2);    
    plot( fplot./1e9, FFT_Ex_dB,'color',[0.4940 0.1840 0.5560]);
    title('̫�����źŵ���(��һ��)','FontSize',12);
    xlim([F_THz-Fs_awg/2 F_THz+Fs_awg/2]/1e9);
    xlabel('Ƶ�ʣ�GHz��');
    ylabel('���ʣ�dB��');    
    scnsize = get(0,'ScreenSize');
    set(gcf,'position',[scnsize(3)/2-scnsize(4)*3/4,scnsize(4)/4,scnsize(4)/2,scnsize(4)/3]); % ��ͼ��λ�� 
end

end

