clear
clc

% IMPORT DATA
load maximallyFlatLowPass.txt
load chebyshev0_5.txt
load chebyshev3.txt

% SELECT FILTER
lp = 0; 
hp = 0;
bp = 1;
% SELECT RESPONSE
b = 0; % Butterworth Maximally Flat
c = 1; % 0.5 dB Ripple
c3db = 0; % 3 dB Ripple

%% PARAMETERS
fc = 1E9; % CUT-OFF FREQUENCY
N = 5; % ORDER
Rs = 50; % SOURCE IMPEDANCE*
flo = 1.8E9;
fhi = 2.1E9;

BW = fhi - flo;
wlo = 2*pi*flo;
whi = 2*pi*fhi;
wc = 2*pi*fc;
wo = sqrt(wlo*whi);
values = zeros(1, 10);

%% VALUES FOR LOW PASS
% FOR LOW PASS START SERIES L, then SHUNT C, terminated at RL
if lp == 1 && b == 1% LOW PASS MAXIMALLY FLAT | BUTTERWORTH
    for i = 1:N
        if (rem(i,2) ~= 0)
            values(i) = Rs * maximallyFlatLowPass(N, i)/wc;
        else
            values(i) = maximallyFlatLowPass(N, i)/(wc*Rs);
        end
    end
    
    values(N+1) = Rs * maximallyFlatLowPass(N, N+1);
    values = values(values>0);
end

if lp == 1 && c == 1% LOW PASS w/ cheby 0.5 dB
    for i = 1:N
        if (rem(i,2) ~= 0)
            values(i) = Rs * chebyshev0_5(N, i)/wc;
        else
            values(i) = chebyshev0_5(N, i)/(wc*Rs);
        end
    end
    
    values(N+1) = Rs * chebyshev0_5(N, N+1);
    values = values(values>0);
end

if lp == 1 && c3db == 1% LOW PASS w/ cheby 3 dB
    for i = 1:N
        if (rem(i,2) ~= 0)
            values(i) = Rs * chebyshev3(N, i)/wc;
        else
            values(i) = chebyshev3(N, i)/(wc*Rs);
        end
    end
    
    values(N+1) = Rs * chebyshev3(N, N+1);
    values = values(values>0);
end

%% VALUES FOR HIGH PASS
% FOR HIGH PASS START SERIES C, then SHUNT L, terminated at RL
if hp == 1 && b == 1
    for i = 1:N
        if(rem(i,2) ~= 0)
            values(i) = 1/(wc*maximallyFlatLowPass(N, i)*Rs);
        else
            values(i) = Rs * 1/(wc*maximallyFlatLowPass(N, i));
        end
    end
    
    values(N+1) = Rs * maximallyFlatLowPass(N, N+1);
    values = values(values>0);
    
end

if hp == 1 && c == 1
    for i = 1:N
        if(rem(i,2) ~= 0)
            values(i) = 1/(wc*chebyshev0_5(N, i)*Rs);
        else
            values(i) = Rs * 1/(wc*chebyshev0_5(N, i));
        end
    end
    
    values(N+1) = Rs * chebyshev0_5(N, N+1);
    values = values(values>0);
    
end

if hp == 1 && c3db == 1
    for i = 1:N
        if(rem(i,2) ~= 0)
            values(i) = 1/(wc*chebyshev3(N, i)*Rs);
        else
            values(i) = Rs * 1/(wc*chebyshev3(N, i));
        end
    end
   
    values(N+1) = Rs * chebyshev3(N, N+1);
    values = values(values>0);
end

%% VALUES FOR BAND PASS
% FOR BAND PASS START SERIES L + C, then SHUNT L + SHUNT C
% ROW 1 is INDUCTOR, ROW 2 is CAPACITOR, Final Column has RL Value
valuesbp = zeros(2, 10);
if bp == 1 && b == 1
    for i = 1:N
       if(rem(i,2) ~= 0)
          valuesbp(1,i) = maximallyFlatLowPass(N, i) / BW;
          valuesbp(2,i) = BW / (wo^2 * maximallyFlatLowPass(N, i));
       else
          valuesbp(1,i) = BW / (wo^2 * maximallyFlatLowPass(N, i));
          valuesbp(2,i) = maximallyFlatLowPass(N, i) / BW;
       end
    end
    valuesbp(1,N+1) = Rs * maximallyFlatLowPass(N, N+1);
end

if bp == 1 && c == 1
    for i = 1:N
       if(rem(i,2) ~= 0)
          valuesbp(1,i) = chebyshev0_5(N, i) / BW;
          valuesbp(2,i) = BW / (wo^2 * chebyshev0_5(N, i));
       else
          valuesbp(1,i) = BW / (wo^2 * chebyshev0_5(N, i));
          valuesbp(2,i) = chebyshev0_5(N, i) / BW;
       end
    end
    valuesbp(1,N+1) = Rs * chebyshev0_5(N, N+1);
end

if bp == 1 && c3db == 1
    for i = 1:N
       if(rem(i,2) ~= 0)
          valuesbp(1,i) = chebyshev3(N, i) / BW;
          valuesbp(2,i) = BW / (wo^2 * chebyshev3(N, i));
       else
          valuesbp(1,i) = BW / (wo^2 * chebyshev3(N, i));
          valuesbp(2,i) = chebyshev3(N, i) / BW;
       end
    end
    valuesbp(1,N+1) = Rs * chebyshev3(N, N+1);
end
