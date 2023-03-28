function [E_Base] = Digital_Mixer(F_THz,F_THz_LO,E_IF,delta_t,Fb,draw)
%> @�����±�Ƶ����

%> @E_IF, ��Ƶ�źŵ糡
%> @F_THz, ̫�����ز�Ƶ��(��λHz)
%> @F_THz_LO, ̫���ȱ���Ƶ��(��λHz)
%> @delta_t, һ�����ŵ�ʱ������
%> @Fb, QAM�źŵĲ�����

%> @E_Base, �����źŵ糡

% uiwait(msgbox('������ն�DSP(�����±�Ƶ)','��ʾ','help'));
close all;
fprintf(1,[' #   �����±�Ƶ������------ ' '\n']);
fprintf(1,[' ---------------------------\n']);

%% �����±�Ƶ
Npoints = length(E_IF);
F_IF = abs(F_THz_LO-F_THz); % ��Ƶ�ź�Ƶ��
E_Base_1 = conj(exp(1i*(2*pi*F_IF*(1:Npoints)*delta_t))).*(E_IF); % �����±�Ƶ��Ļ����źų�

if draw
    % �����źŵ���(��һ��)
    figure;
    Sig_draw = E_Base_1;
    datalen = length(Sig_draw);
    fplot = linspace(-1/delta_t/2,1/delta_t/2,datalen);
    FFT_Ex_1 = fftshift(fft(Sig_draw));
    FFT_Ex = abs(FFT_Ex_1)/(length(Sig_draw));
    FFT_Ex_dB = 10*log10(FFT_Ex.^2);    
    plot( fplot./1e9, FFT_Ex_dB,'b');
    title('�����źŵ���(��һ��)','FontSize',12);
    xlim([-1/delta_t/2 1/delta_t/2]/1e9);
    xlabel('Ƶ�ʣ�GHz��');
    ylabel('���ʣ�dB��');
    scnsize = get(0,'ScreenSize');
    set(gcf,'position',[scnsize(3)/2-scnsize(4)/2-1,scnsize(4)/4,scnsize(4)/2,scnsize(4)/3]); % ��ͼ��λ��
end

%% DC Block����
E_Base_1_Ser = [real(E_Base_1) imag(E_Base_1)];
E_Base_1_Temp1 = bsxfun(@minus,E_Base_1_Ser,mean(E_Base_1_Ser));
E_Base_1_DCB = E_Base_1_Temp1(1:end/2) + 1i*E_Base_1_Temp1(end/2+1:end);

%% ��ͨ�˲�����

lpFilt = designfilt('lowpassiir', ...
    'PassbandFrequency',Fb, ...
    'StopbandFrequency',1.05*Fb,...
    'PassbandRipple',0.05, ...
    'SampleRate',1/delta_t,...
    'StopbandAttenuation',40,...
    'DesignMethod','butter'); % IIR�˲������

E_Base = filter(lpFilt,E_Base_1_DCB);

if draw
    % �˲�������źŵ���(��һ��)
    figure;
    Sig_draw = E_Base;
    datalen = length(Sig_draw);
    fplot = linspace(-1/delta_t/2,1/delta_t/2,datalen);
    FFT_Ex_1 = fftshift(fft(Sig_draw));
    FFT_Ex = abs(FFT_Ex_1)/(length(Sig_draw));
    FFT_Ex_dB = 10*log10(FFT_Ex.^2);    
    plot( fplot./1e9, FFT_Ex_dB,'m');
    title('�˲�������źŵ���(��һ��)','FontSize',12);
    xlim([-1/delta_t/2 1/delta_t/2]/1e9);
    xlabel('Ƶ�ʣ�GHz��');
    ylabel('���ʣ�dB��');
    scnsize = get(0,'ScreenSize');
    set(gcf,'position',[scnsize(3)/2+1,scnsize(4)/4,scnsize(4)/2,scnsize(4)/3]); % ��ͼ��λ��
end

end

%% Backup
% if draw
%     h=fvtool(lpFilt);  suptitle('�˲�����Ӧ');
% end
