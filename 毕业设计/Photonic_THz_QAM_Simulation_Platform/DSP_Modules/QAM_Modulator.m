function [tx_data, tx_sig] = QAM_Modulator(input_sig, num_symb, bits_per_sym, coding, draw)
    %> @QAM���ƺ���

    %> @input_sig,�����0-1�������У��ɲ�������PRBS15������ģ��
    %> @num_symb,QAM�źŵķ�����
    %> @bits_per_sym,QAM�ź�ÿ���ű�����

    %> @tx_data,���Ͷ�0-1����Դ
    %> @tx_sig,���ɵ�QAM�ź�

    % uiwait(msgbox('���뷢�Ͷ�DSP(QAM����)','��ʾ','help'));
    fprintf(1, [' #   QAM���Ƽ�����------ ' '\n']);
    fprintf(1, [' ---------------------------\n']);

    rep_input_sig = ceil(num_symb * bits_per_sym / (length(input_sig))); % ���ݷ�������input_sig���н�����������չ��rep_input_sigΪ�ظ�������
    tx_data = repmat(input_sig, [rep_input_sig 1]); % ���Ͷ�0-1����
    tx_data = reshape(tx_data, bits_per_sym, num_symb); % ����ת�����������QAM����
    data_trace = bi2de(tx_data', 'left-msb'); %������ת��Ϊʮ����

    if draw
        PlotCons = true;
    else
        PlotCons = false;
    end

    tx_sig = qammod(data_trace, 2 ^ bits_per_sym, coding, 'UnitAveragePower', true, 'PlotConstellation', PlotCons);
    title('QAM��������ͼ', 'FontSize', 12);
    scnsize = get(0, 'ScreenSize');
    set(gcf, 'position', [scnsize(3) / 2 - scnsize(4) / 3, scnsize(4) / 6, scnsize(4) * 2/3, scnsize(4) * 2/3]); % ��ͼ��λ��

end
