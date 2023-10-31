function [E_CPR,freq_off] = Carrier_Recovery(E_est,BPS_PAR,BPS_N,M,Fb,draw)
%> @�ز��ָ���������Ƶƫ��������λ����������

%> @E_est, ���������
%> @BPS_PAR, ��λ��������
%> @BPS_N, ���С
%> @M, QAM�źŽ���

uiwait(msgbox('������ն�DSP(�ز��ָ�)','��ʾ','help'));
close all;
fprintf(1,[' #   ���벹��������------ ' '\n']);
fprintf(1,[' #   ���м��㿪����------ ' '\n']);

E_in = modnorm(E_est(:), 'avpow', 1)* E_est;

const = qammod([0:M-1],M);
Constellation = modnorm(const(:),'avpow',1) * const;
Constellation = Constellation';
R = uniquetol( abs(Constellation), 1e-8 );

B = BPS_PAR;
b = (0:B-1)';
gamma = pi/2; % square QAM with symmetry use pi/2 | no symmetry use 2*pi
phi_b = (b/(B-1))*gamma-pi/4;
N = BPS_N;

% [E_fr,freq_off] = Freq_Offset_Comp(E_in,R,Fb); % Ƶ��ƫ�ƹ���
freq_off = 0;
E_fr=E_in;
PConstellation=Constellation*(exp(-1i*phi_b).');

d = zeros(B,length(E_fr));
parfor k = 1:length(E_fr)
    [d(:,k),~] = min(bsxfun(@minus,PConstellation,E_fr(k)));
end
d = (abs(d)).^2;

% ��������ƽ��
s = zeros(B,length(d)-2*N-1);
for k = N+1:1:length(d)-N-1
    s(:,k-N) = sum(d(:,k-N:k+N+1),2);
end
[~,indb]= min(s);

%% ��λ�ָ�
Theta_est = -unwrap(phi_b(indb)*4)/4;
E_fr = E_fr(:);
E_fr = E_fr(N+1:end-N-1);
E_cpr = -E_fr.*exp(-1i*Theta_est);

E_CPR = modnorm(E_cpr(:), 'avpow', 1)* E_cpr;

if draw
    figure;
    scatter(real(E_est),imag(E_est),1,'Marker','o');title('�ز��ָ�ǰ������ͼ');
    scnsize = get(0,'ScreenSize');
    set(gcf,'position',[scnsize(3)/2-scnsize(4)/2-1,scnsize(4)/4-20,scnsize(4)/2,scnsize(4)/2]); % ��ͼ��λ��
    
    figure;
    scatter(real(E_CPR),imag(E_CPR),1,'Marker','o');title('�ز��ָ��������ͼ');
    scnsize = get(0,'ScreenSize');
    set(gcf,'position',[scnsize(3)/2+1,scnsize(4)/4-20,scnsize(4)/2,scnsize(4)/2]); % ��ͼ��λ��
end
fprintf(1,[' ---------------------------\n']);
end

