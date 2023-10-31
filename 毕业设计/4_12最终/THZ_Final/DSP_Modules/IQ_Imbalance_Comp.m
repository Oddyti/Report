function E_Base_IQC = IQ_Imbalance_Comp(E_Base)
%> @IQʧ�ⲹ������

%> @���㷨��Ҫ����Gram-Schmidt�㷨
%> @E_Base, �����źŵ糡
%> @E_Base_IQC, IQʧ�ⲹ����Ļ����źŵ糡

fprintf(1,[' #   IQʧ�ⲹ��������------ ' '\n']);
fprintf(1,[' ---------------------------\n']);

I = real(E_Base);
Q = imag(E_Base);

rho = mean(I.*Q); % I·��Q·���ֵ

% I·���ʹ�һ��
L_I = length(I);
absxsq_I = I.*conj(I);        
E_I = sum(absxsq_I);
P_I = E_I/L_I;

Q = Q - rho*I/P_I;

% Q·���ʹ�һ��
L_Q = length(Q);
absxsq_Q = Q.*conj(Q);        
E_Q = sum(absxsq_Q);
P_Q = E_Q/L_Q;

E_Base_IQC = (I/sqrt(P_I) + 1i*Q/sqrt(P_Q))/sqrt(2);

end

