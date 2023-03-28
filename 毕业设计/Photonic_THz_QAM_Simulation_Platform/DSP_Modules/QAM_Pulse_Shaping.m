function tx_waveform_awg = QAM_Pulse_Shaping(tx_sig,Nss,PulseShaping,txrolloff,Nsym,Fs_awg,Fs,draw)
%> @QAM������ͺ���

%> @tx_sig,���ɵ�QAM�ź�
%> @Nss,QAM�źŵ�ԭʼ����Ƶ���µĹ�������
%> @PulseShaping,'No_Shaping'|'Rcos' |'RRC'������͵ķ���
%> @txrolloff,������͵Ĺ���ϵ����ȡֵ0~1֮�䣬����Ƶ��Ͷ��ͳ̶�
%> @Nsym,������ͽضϵķ��ŷ�Χ
%> @Fs_awg,AWG�����Ĳ�����
%> @Fs,QAM�źŵ�ԭʼ����Ƶ��

%> @tx_waveform_awg, AWG�������

% uiwait(msgbox('���뷢�Ͷ�DSP(QAM�������)','��ʾ','help'));
close all;scnsize = get(0,'ScreenSize');
fprintf(1,[' #   QAM������ͼ�����------ ' '\n']);
fprintf(1,[' ---------------------------\n']);

tx_up = upsample(tx_sig,Nss); % �ϲ�������ͼ�ã�
tx_wfm = filter(ones(Nss,1),1,tx_up); % �˲�����ͼ�ã�
switch PulseShaping
    case 'No_Shaping' % ֱ�Ӱ��վ��δ�����
        tx_up = upsample(tx_sig,Nss); % �ϲ���
        tx_wfm = filter(ones(Nss,1),1,tx_up); % �˲�
        tx_wfm_Nf = tx_wfm;
    case 'Rcos' % �����������˲����ͣ���Ϊ����
        Hd = rcosdesign(txrolloff,Nsym,Nss,'normal'); % �˲������
        tx_wfm_Nf = upfirdn(tx_sig, Hd, Nss); % �ϲ���
        tx_wfm_Nf = circshift(tx_wfm_Nf,-(Nsym*Nss)/2); % ѭ����λ��ȷ������
        tx_wfm_Nf = tx_wfm_Nf(1:end-(Nsym*Nss-Nss+1));  % ȥ����Ч����
    case 'RRC' % ���վ������������˲����ͣ���Ϊ����
        Hd = rcosdesign(txrolloff,Nsym,Nss,'sqrt'); % �˲������
        tx_wfm_Nf = upfirdn(tx_sig, Hd, Nss); % �ϲ���
        tx_wfm_Nf = circshift(tx_wfm_Nf,-(Nsym*Nss)/2); % ѭ����λ��ȷ������
        tx_wfm_Nf = tx_wfm_Nf(1:end-(Nsym*Nss-Nss+1));  % ȥ����Ч����
end
if Fs ~= Fs_awg % �ز�����AWG�Ĳ�����
    tx_waveform_awg = resample(tx_wfm_Nf,Fs_awg,Fs); % �ز�����AWG�Ĳ�����
else
    tx_waveform_awg = tx_wfm_Nf;
end
if draw
    figure;
    % ʱ�������ͼ
    subplot(3,2,1);
    plot(real(tx_wfm(1:300)),'LineWidth',1);
    title('���������(300����Ʒ��)','FontSize',12);
    xlabel('ʱ���');
    ylabel('����');
    
    subplot(3,2,3);
    plot(real(tx_wfm_Nf(1:300)),'r','LineWidth',1);
    title('�������(300����Ʒ��)','FontSize',12);
    xlabel('ʱ���');
    ylabel('����');
    
    subplot(3,2,5);
    plot(real(tx_waveform_awg(1:300)),'m','LineWidth',1);
    title('�������+�ز���(300����Ʒ��)(AWG)','FontSize',12);
    xlabel('ʱ���');
    ylabel('����');
    
    % Ƶ����ͼ
    data1 = double(tx_wfm);
    data2 = double(tx_wfm_Nf);
    data3 = double(tx_waveform_awg);
    
    Ex_spec1 = data1;
    Npoints1 = length(Ex_spec1);
    FFT_Ex_1 = fftshift(fft(Ex_spec1));
    FFT_Ex1 = abs(FFT_Ex_1)./(length(Ex_spec1));
    Frek1 = (Fs*(-(Npoints1)/2:((Npoints1/2)-1)))/Npoints1;
    
    Ex_spec2 = data2;
    Npoints2 = length(Ex_spec2);
    FFT_Ex_2 = fftshift(fft(Ex_spec2));
    FFT_Ex2 = abs(FFT_Ex_2)./(length(Ex_spec2));
    Frek2 = (Fs*(-(Npoints2)/2:((Npoints2/2)-1)))/Npoints2;
    
    Ex_spec3 = data3;
    Npoints3 = length(Ex_spec3);
    FFT_Ex_3 = fftshift(fft(Ex_spec3));
    FFT_Ex3 = abs(FFT_Ex_3)./(length(Ex_spec3));
    Frek3 = (Fs_awg*(-(Npoints3)/2:((Npoints3/2)-1)))/Npoints3;
    
    subplot(3,2,2);
    plot(Frek1./1e9,10*log10(FFT_Ex1.^2),'.');
    xlabel('Ƶ�ʣ�GHz)');
    ylim([-150,0]);
    title('���������','FontSize',12);
    
    subplot(3,2,4);
    plot(Frek2./1e9,10*log10(FFT_Ex2.^2),'r');
    xlabel('Ƶ�ʣ�GHz)');
    ylim([-150,0]);
    title('�������','FontSize',12);
    
    subplot(3,2,6);
    plot(Frek3./1e9,10*log10(FFT_Ex3.^2),'m');
    xlabel('Ƶ�ʣ�GHz)');
    ylim([-150,0]);
    title('�������+�ز���(AWG)','FontSize',12);
    
    set(gcf,'position',[scnsize(3)/2-scnsize(4)/2,scnsize(4)/6-10,scnsize(4),scnsize(4)*2/3]); % ��ͼ��λ��
end

% uiwait(msgbox('���뷢�Ͷ˹����(������)','��ʾ','help'));
close all;

end

