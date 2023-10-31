function E_Laser = CW_Laser(Lamda,P_dBm,Phase,LW,Npoints,delta_t,C_Light,LO_Index,draw)
%> @����������������

%> @Lamda, ����������
%> @P_dBm, ����������(��λdBm)
%> @Phase, ��������ʼ��λ
%> @LW, �������߿�
%> @Npoints, �����źų���
%> @delta_t, һ�����ŵ�ʱ������
%> @C_Light, ���٣���λm/s��
%> @LO_Index, Ϊ1��Ϊ����Ϊ0��Ϊ����������

%> @E_laser, �������ⳡ

fprintf(1,[' #   ��������ģ��------ ' '\n']);
fprintf(1,[' ---------------------------\n']);

%% ��������λ����
x2 = zeros(1,Npoints);

for qa = 1:Npoints
    x2(qa+1) = x2(qa)+ sqrt(LW*delta_t)*randn(1); % ��������λ����ά�ɹ���
end

laser_phase_noise = x2(1:end-1); %��ȥ���һ����

if draw
    figure;    
    plot(laser_phase_noise);xlabel('ʱ��');ylabel('��λ(rad)');
    if LO_Index
        title('���񼤹�����λ����','FontSize',12);
        scnsize = get(0,'ScreenSize');
        set(gcf,'position',[scnsize(3)/2-scnsize(4)/2-1,scnsize(4)/4,scnsize(4)/2,scnsize(4)/3]); % ��ͼ��λ��
    else
        title('�������Ƽ�������λ����','FontSize',12);
        scnsize = get(0,'ScreenSize');
        set(gcf,'position',[scnsize(3)/2+1,scnsize(4)/4,scnsize(4)/2,scnsize(4)/3]); % ��ͼ��λ��
    end
end

%% ���������
Power_Laser = 10^(P_dBm/10)*0.001; % �������������(��λW)
Omega_Laser = 2*pi*1/(Lamda/C_Light); % ��������Ƶ��
E_Laser=sqrt(Power_Laser)*exp(1i*(Omega_Laser*(1:Npoints)*delta_t+Phase)+1i*laser_phase_noise);

end

