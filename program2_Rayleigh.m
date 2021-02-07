close all;  %clear all figure windows
clear all;  %clear all variables from memory

SNRdB = [2:3:35];  %dB SNR
SNR = 10.^(SNRdB/10);

BER = zeros(1,length(SNR));
blockLength = 100000;    %Number of symbols/bits per block


bits = randi([0,1],[1,blockLength]);    %Generating the bits
ModSym = 2*bits - 1;  %Generating BPSK symbols
n = randn(1, blockLength) + 1i*randn(1, blockLength);   %ZMCSCG Noise
h = sqrt(0.5)*(randn(1, blockLength) + 1i*randn(1, blockLength));   %Channel coefficient

for kx = 1:length(SNR)
    x = sqrt(SNR(kx)) * ModSym;   %Transmitted Symbols
    y = h.*x + n;  %AWGN channel model
    
    DecodedBits = (real(conj(h).*y) >= 0); 
    BER(kx) = (sum(DecodedBits ~= bits))/blockLength;  %BER
        
end

semilogy(SNRdB, BER, 'b - ')
hold on;

semilogy(SNRdB, 1/2*(1-sqrt(SNR./(SNR+2))), 'r o')
semilogy(SNRdB, 1/2./SNR, 'g -')
legend('Simulation', 'Theory', 'Approximation')
grid on;

axis tight;

xlabel('SNRdb');
ylabel('BER');
title('BER vs SNR for Rayleigh fading channel')
