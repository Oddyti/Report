function E_Dec = Time_Recovery(E_Base,Fs_awg,Fs,Fb,Nsym,txrolloff,Nss,draw)
%> @ʱ��ͬ����ָ�����

%> @E_Base, �����źŵ糡
%> @delta_t, һ�����ŵ�ʱ������
%> @Fs, QAM�źŵ�ԭʼ����Ƶ��
%> @Fb, QAM�źŵĲ�����
%> @Nsym, ������ͽضϵķ��ŷ�Χ
%> @txrolloff, ������͵Ĺ���ϵ����ȡֵ0~1֮�䣬����Ƶ��Ͷ��ͳ̶�
%> @Nss = Fs/Fb, QAM�źŵ�ԭʼ����Ƶ���µĹ�������

%> @E_Dec, ʱ��ͬ������ź�

% uiwait(msgbox('������ն�DSP(ʱ��ͬ��)','��ʾ','help'));
close all;
fprintf(1,[' #   ʱ��ͬ��������------ ' '\n']);
fprintf(1,[' ---------------------------\n']);

%% Gardner�ز����㷨
% dt_rec = Fs_awg/Fs;
% nom_v = round(Fs_awg/Fb);
% 
% t_new = 1:dt_rec:length(E_Base);
% 
% step = 0.03;
% var = linspace(0,1,1/step);
% var = var(1:end-1);
% L_temp = length(E_Base)/dt_rec;
% 
% PD_gardner = inf(size(var));
% 
% y = real(E_Base(1:L_temp));
% x = 1:L_temp;
% 
% t_new = t_new(1:L_temp);
% 
% for a_c = 1:length(var)
%     Toff = var(a_c)*nom_v;
%     I = interp1(x,y,t_new+Toff,'linear');
%     PD_gardner(a_c) = mean( I(2:2:L_temp-1) .* (I(3:2:L_temp)-I(1:2:L_temp-2)) );
% end
% 
% [~,PD_min] = min( abs(PD_gardner).^2 );
% Toff = var(PD_min)*nom_v;
% out = interp1(E_Base,t_new+Toff,'spline',0);

out = resample(E_Base,Fs,Fs_awg); % �����öԱȣ�MATLAB�Դ����ز����㷨

%% ƥ���˲�
shapeFilter  = fdesign.pulseshaping(Fs/Fb, 'Square Root Raised Cosine','Nsym,beta', Nsym, txrolloff, Fs);
Hd = design(shapeFilter);
E_mflt = filter(Hd,out);

%% ʱ���ȡ
E_dec_real = Decimator(real(E_mflt),Nss);
E_dec_imag = Decimator(imag(E_mflt),Nss);

%% �ź����
E_Dec = E_dec_real + 1i*E_dec_imag;

if draw
    figure;
    scatter(real(E_Base),imag(E_Base),1,'Marker','o');title('ʱ��ͬ��ǰ������ͼ');
    scnsize = get(0,'ScreenSize');
    set(gcf,'position',[scnsize(3)/2-scnsize(4)/2-1,scnsize(4)/4-20,scnsize(4)/2,scnsize(4)/2]); % ��ͼ��λ��
    
    figure;
    scatter(real(E_Dec),imag(E_Dec),1,'Marker','o');title('ʱ��ͬ���������ͼ');
    scnsize = get(0,'ScreenSize');
    set(gcf,'position',[scnsize(3)/2+1,scnsize(4)/4-20,scnsize(4)/2,scnsize(4)/2]); % ��ͼ��λ��
end

end
