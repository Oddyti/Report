%> @����������������

% E_tx = modnorm(tx_sig(:), 'avpow', 1)* tx_sig;
% E_rx = modnorm(E_final(:), 'avpow', 1)* E_final;
E_tx = tx_sig;
E_rx = E_final;
Tx_seq = qamdemod(E_tx(:),M,coding,'UnitAveragePower',true); % QAM��� %,'UnitAveragePower',true
Rx_seq = qamdemod(E_rx(:),M,coding,'UnitAveragePower',true); % QAM���
[a,b] = xcorr(Tx_seq,Rx_seq);
loc = find(a==max(a));
Tx_seq = Tx_seq(b(loc)+1:b(loc)+length(Rx_seq));
[n,r] = symerr(Tx_seq, Rx_seq);
E_tx = E_tx(b(loc)+1:b(loc)+length(Rx_seq));
Tx_bit = de2bi(Tx_seq','left-msb'); % ʮ����ת��Ϊ������
Rx_bit = de2bi(Rx_seq','left-msb'); % ʮ����ת��Ϊ������
save Data_out/E_tx_mt.mat E_tx;
save Data_out/E_rx_mt.mat E_rx;
save Data_out/Tx_bit_mt.mat Tx_bit;
errorRate = comm.ErrorRate;
Sim_Result = errorRate(Tx_bit(:),Rx_bit(:));

figure;
stem(abs(Tx_bit(:)-Rx_bit(:)),'Linewidth',0.2,'MarkerSize',1);title('����ֲ�');xlabel('����');ylabel('����');
scnsize = get(0,'ScreenSize');
set(gcf,'position',[scnsize(3)/2-scnsize(4)/2-1,scnsize(4)/16,scnsize(4)+2,scnsize(4)/4-10]); % ��ͼ��λ��

uiwait(msgbox({[' * ϵͳ����������Ϊ:',num2str(Sim_Result(1)/(1E-3)),'E-3'];...
   [' * ϵͳ�������Ϊ:',num2str(Sim_Result(2)),'����'];...
   [' * ϵͳ�ܱ�����Ϊ:',num2str(Sim_Result(3)),'����']},'���̫����ϵͳ','help'));
clc; close all; 

Result.Performance = Sim_Result;
Result.E_tx = E_tx;
Result.E_rx = E_rx;

save Sim_Results/Result Result;

fprintf(1,' # ���̫����ϵͳ������������Ҫ����\n');
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
fprintf(1,[' * ���Ʋ���Ϊ: ',num2str(M),'QAM\n']);
fprintf(1,[' * �źŲ�����Ϊ: ',num2str(Fb/1e9),'Gbaud\n']);
fprintf(1,[' * ���������Ϊ: ','2^',num2str(log2(num_symb)),'������\n']);
fprintf(1,[' * ������ͷ���Ϊ: ',strcat(PulseShaping,'\n')]);
fprintf(1,[' ---------------------------\n']);

fprintf(1,[' # ����DSP��Ҫ����\n']);
fprintf(1,[' * ���Ծ�����Ϊ: ',strcat(Eq_type,'\n')]);
fprintf(1,[' * ���Ծ����������Ϊ: ',num2str(Eq_iter),'��\n']);
fprintf(1,[' * ���Ծ����ͷ��Ϊ: ',num2str(Eq_taps),'��\n']);
fprintf(1,[' * ��λ��������Ϊ: ','pi/',strcat(num2str(2*BPS_PAR),'\n')]);
fprintf(1,[' * ��λ���ƿ��СΪ: ',strcat(num2str(BPS_N),'\n')]);
fprintf(1,[' ---------------------------\n']);

fprintf(1,[' # ϵͳ��������\n']);
fprintf(1,[' * ϵͳ����������Ϊ:',num2str(r),'\n']);
fprintf(1,[' * ϵͳ����������Ϊ:',num2str(Sim_Result(1)/(1E-3)),'E-3\n']);
fprintf(1,[' * ϵͳ�������Ϊ:',num2str(Sim_Result(2)),'����\n']);
fprintf(1,[' * ϵͳ�ܱ�����Ϊ:',num2str(Sim_Result(3)),'����\n']);

if Sim_Result(1)>0.1
    uiwait(msgbox({'@ϵͳ������Ҫ�Ż�!';'@---��עOSNR���߿��ָ��---';'@---����QAM������ָ��---'},'���̫����ϵͳ','warn'));
end