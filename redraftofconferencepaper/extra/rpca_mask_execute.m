function outputs = rpca_mask_execute(wavinmix, parm,dB,n)
%% parameters
lambda = parm.lambda;
nFFT = parm.nFFT;
winsize = parm.windowsize;
masktype = parm.masktype;
gain = parm.gain;
power = parm.power;
fs = parm.fs;
outputname = parm.outname;

hop = winsize / 4;
scf = 2 / 3;
S_mix = scf * stft(wavinmix, nFFT, winsize, hop);
%% use inexact_alm_rpca to run RPCA
% A - low rank matrix, E - sparse matrix
try
    [A_mag, E_mag] = inexact_alm_rpca(abs(S_mix) .^ power', ...
        lambda / sqrt(max(size(S_mix))));
    PHASE = angle(S_mix');
catch error
    [A_mag, E_mag] = inexact_alm_rpca(abs(S_mix) .^ power, ...
        lambda / sqrt(max(size(S_mix))));
    PHASE = angle(S_mix);
end
A = A_mag .* exp(1i .* PHASE);  % low rank
E = E_mag .* exp(1i .* PHASE);  % sparse
%% binary mask, no mask
switch masktype
    case 1 % binary mask + median filter
        mask = double(abs(E) > (gain * abs(A)));
        try
            Emask = mask .* S_mix;
            Amask = S_mix - Emask;
        catch error
            Emask = mask .* S_mix';
            Amask = S_mix' - Emask;
        end
    case 2 % no mask
        Emask = E;
        Amask = A;
    otherwise
        fprintf('masktype error\n');
end
%% do istft
try
    wavoutE = istft(Emask', nFFT, winsize, hop)';
    wavoutA = istft(Amask', nFFT, winsize, hop)';
catch error
    wavoutE = istft(Emask, nFFT, winsize, hop)';
    wavoutA = istft(Amask, nFFT, winsize, hop)';
end
%disp("------------");
%disp(outputname);
wavoutE = wavoutE / max(abs(wavoutE));
audiowrite(['sp0' num2str(n) '_m_cn_E_' num2str(dB) 'db.wav'], wavoutE, 8000);

wavoutA = wavoutA / max(abs(wavoutA));
audiowrite(['sp0' num2str(n) '_m_cn_A_' num2str(dB) 'db.wav'], wavoutA, 8000);

outputs.wavoutA = wavoutA;
outputs.wavoutE = wavoutE;