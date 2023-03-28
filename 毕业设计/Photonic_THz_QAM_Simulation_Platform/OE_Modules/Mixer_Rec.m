function E_IF = Mixer_Rec(E_THz,R,P_THz_LO_dBm,F_THz,F_THz_LO,SNR_Mixer,delta_t,Phase,LW,draw)
%> @̫���Ȼ�Ƶ������

%> @E_THz, ̫�����źŵ糡
%> @R, ̫���Ȼ�Ƶ��ת��Ч��
%> @P_THz_LO_dBm, ���񼤹���������ʣ���λdBm��
%> @F_THz, ̫�����ز�Ƶ��(��λHz)
%> @F_THz_LO, ̫���ȱ���Ƶ��(��λHz)
%> @SNR_Mixer, ̫���Ȼ�Ƶ������ȣ���λdB��
%> @delta_t, һ�����ŵ�ʱ������
%> @Phase, ̫���ȱ����ʼ��λ
%> @LW, ̫���ȱ����߿�

%> @E_IF, ��Ƶ�źŵ糡

fprintf(1,[' #   ̫���Ȼ�Ƶ����ģ��------ ' '\n']);
fprintf(1,[' ---------------------------\n']);

Npoints = length(E_THz);
x2 = zeros(1,Npoints);

for qa = 1:Npoints
    x2(qa+1) = x2(qa)+ sqrt(LW*delta_t)*randn(1); % ��������λ����ά�ɹ���
end

LO_phase_noise = x2(1:end-1); %��ȥ���һ����

if draw
    figure;
    plot(LO_phase_noise);xlabel('ʱ��');ylabel('��λ(rad)');
    title('̫���ȱ�����λ����','FontSize',12);
    scnsize = get(0,'ScreenSize');
    set(gcf,'position',[scnsize(3)/2-scnsize(4)/4+2,scnsize(4)/4,scnsize(4)/2,scnsize(4)/3]); % ��ͼ��λ��   
end

Power_LO = 10^(P_THz_LO_dBm/10)*0.001; % ̫���Ȼ�Ƶ�������������(��λW)
Omega_LO = 2*pi*F_THz_LO; % ̫���Ȼ�Ƶ�������Ƶ��
E_THz_LO = sqrt(Power_LO)*exp(1i*(Omega_LO*(1:Npoints)*delta_t+Phase)+1i*LO_phase_noise);

E_IF_1 = 2*R*conj(E_THz_LO).*(E_THz); % �±�Ƶ�����Ƶ�źų�

E_IF=awgn(E_IF_1,SNR_Mixer,'measured'); % �����Ƶ������

if draw
    % �±�Ƶ����Ƶ�źŵ���(��һ��)
    figure;
    Sig_draw = E_IF;
    datalen = length(Sig_draw);
    fplot = linspace(abs(F_THz-F_THz_LO)-1/delta_t/2,abs(F_THz-F_THz_LO)+1/delta_t/2,datalen);
    FFT_Ex_1 = fft(Sig_draw);
    FFT_Ex = abs(FFT_Ex_1)/(length(Sig_draw));
    FFT_Ex_dB = 10*log10(FFT_Ex.^2);    
    plot( fplot./1e9, FFT_Ex_dB,'b');
    title('�±�Ƶ����Ƶ�źŵ���(��һ��)','FontSize',12);
    xlim([abs(F_THz-F_THz_LO)-1/delta_t/2 abs(F_THz-F_THz_LO)+1/delta_t/2]/1e9);
    xlabel('Ƶ�ʣ�GHz��');
    ylabel('���ʣ�dB��');
    scnsize = get(0,'ScreenSize');
    set(gcf,'position',[scnsize(3)/2+scnsize(4)/4+4,scnsize(4)/4,scnsize(4)/2,scnsize(4)/3]); % ��ͼ��λ��  
end

end

