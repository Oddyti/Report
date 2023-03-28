function E_out = Decimator(E_m,Nss)
%> @ʱ���ȡ�Ӻ���

r = Nss;
N = Nss*fix(numel(E_m)/Nss);
SYMBOLS_LIMIT = 1e5;
LIM = SYMBOLS_LIMIT*Nss;
LIM = min(LIM,N);

E_m = E_m(1:N);
symbols = reshape(E_m(1:LIM),Nss,[]).'; % �����ź�Ϊ������
S = var(symbols);

N2 = 10;
Nsst = 5e3;
v = repmat(S,[1 N2]);
L = N2*Nsst;
x2 = linspace(1,length(v),L);
v2 = interp1(1:length(v),v,x2,'spline');

% Ѱ����󷽲��
idx = Nsst:2*Nsst;
[~, ptr] = max(v2(idx));
samplingPoint = x2(idx(ptr));

% Ѱ��ʱ��skew
skew = samplingPoint - floor(samplingPoint);
E_m = addskew(E_m,skew,1);

% ѡ���µĲ�����
ptr = mod(floor(samplingPoint)-1,r)+1;
idx = ptr:r:N;
E_out = E_m(idx);

end

%% Backup
% if draw
%     figure;
%     plot(v);
%     hold on;
%     plot(x2,v2);
%     if real
%         title('ʵ��ʱ�ӻָ���ֵ����');set(gcf,'unit','centimeters','position',[6.2,10,10,7]); % ��ͼ��λ��
%     else
%         title('�鲿ʱ�ӻָ���ֵ����');set(gcf,'unit','centimeters','position',[6.2,1,10,7]); % ��ͼ��λ��
%     end
% end
% 
% 
% if draw
%     figure;
%     histogram(E_out);
%     if real
%         title('ʵ�����ȸ��ʷֲ�');set(gcf,'unit','centimeters','position',[16.2,10,10,7]); % ��ͼ��λ��
%     else
%         title('�鲿���ȸ��ʷֲ�');set(gcf,'unit','centimeters','position',[16.2,1,10,7]); % ��ͼ��λ��
%     end
% end
