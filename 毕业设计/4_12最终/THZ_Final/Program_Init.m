%> @�����������������Զ����������ļ���

%% ϵͳ����
    clear all; % ���ݿռ����
    close all; % ͼƬ�ռ����
    clc; % ��ʾ�ռ����
    warning off; % ���治��ʾ���ɿ�Ϊon��
    draw = 1; % Ϊ1����ͼ��Ϊ0����ʾ�����
    
%% ������ļ���
    root = mfilename('fullpath');
    root = root(1:find(root==filesep,1,'last')-1);
    fprintf(1,' @  ����ϵ�̫����ͨ��ϵͳ����ƽ̨\n');
    fprintf(1,' @  MATLAB����----�����ʼ��.�������·��:\n');
    fprintf(' @  %s\n',root);
    addpath(root);
    dirs = {'OE_Modules','DSP_Modules','Sub_Fuctions','Sim_Results','Data_Traces','System_Parameters'}; % �ɲ��䶨�����ļ�������
    for i=1:numel(dirs)
        add = [root filesep dirs{i}];
        fprintf(' @  %s\\*\n',add);
        addpath(genpath(add));
    end    
    pause(5);
    clc;fprintf(1,' @  ����ϵ�̫����ͨ��ϵͳ����ƽ̨-----������-----\n');
