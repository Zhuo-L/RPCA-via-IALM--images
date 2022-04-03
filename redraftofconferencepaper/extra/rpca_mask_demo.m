clc;clear;close all;
%% making the signal added with noise
%%
for n=1
    disp(num2str(n));
    %%
    for dB=10
        %%
        disp(num2str(dB));
        sp=audioread(['sp0' num2str(n) '_m.wav']);
        samples=[1,length(sp)];
        [x,fs]=audioread(['sp0' num2str(n) '_m.wav'],samples);
        %%
        y=audioread(['sp0' num2str(n) '_m_crowdnoise_' num2str(dB) 'dB.wav'],samples);
        %%
        wavinmix=y;
        %% Run RPCA
        parm.outname = ['example', filesep, 'output', filesep,'sp0' num2str(n)];
        parm.lambda = 0.9;
        parm.nFFT = 2048;
        parm.windowsize = 1536;
        parm.masktype = 2; %1: binary mask, 2: no mask
        parm.gain = 1;
        parm.power = 1;
        parm.fs = fs;
        %%
        outputs = rpca_mask_execute(wavinmix, parm,num2str(dB),num2str(n));
       
        %% pesq calculation
        ce=['sp0' num2str(n) '_m.wav'];
       % disp(num2str(dB));
        [a,b,c]=composite1(ce,['sp0' num2str(n) '_m_cn_E_' num2str(dB) 'db.wav']);
        disp(a);
        disp(b);
        disp(c);
    end
end
%%