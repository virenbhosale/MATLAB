clear
clc

load butterworth.txt
load chebyshev0_5.txt
load chebyshev3.txt

% SELECT FILTER
lp = 1; 
hp = 0;
bp = 0;
% SELECT RESPONSE
b = 0; % Butterworth Maximally Flat
c = 1; % 0.5 dB Ripple
c3db = 0; % 3 dB Ripple

%% PARAMETERS
fc = 1E9; % CUT-OFF FREQUENCY
N = 8; % ORDER
Ro = 50; % CHARACTERISTIC IMPEDANCE
flo = 1.9E9; % PART OF THE PASS BAND
fhi = 2.0E9;

BW = 2*pi*(fhi - flo);
wlo = 2*pi*flo;
whi = 2*pi*fhi;
wc = 2*pi*fc;
wo = sqrt(wlo*whi);
values = zeros(2, 10);
valuesbp = zeros(4, 10);
%% VALUES FOR LOW PASS
% FOR LOW PASS START SERIES L, then SHUNT C, terminated at RL
% COLUMN 1: Series Inductor then Shunt Capacitor
% COLUMN 2: Shunt Capacitor then Series Inductor
if lp == 1 && b == 1% LOW PASS MAXIMALLY FLAT | BUTTERWORTH
    for i = 1:N
        if (rem(i,2) ~= 0)
            values(1, i) = Ro * butterworth(N, i)/wc;
            values(2, i) = butterworth(N, i)/(wc*Ro);
        else
            values(1, i) = butterworth(N, i)/(wc*Ro);
            values(2, i) = Ro * butterworth(N, i)/wc;
        end
    end
    
    values(1, N+1) = Ro * butterworth(N, N+1);
    values(2, N+1) = Ro * butterworth(N, N+1);
    values = values.';
end

if lp == 1 && c == 1% LOW PASS w/ cheby 0.5 dB
    for i = 1:N
        if (rem(i,2) ~= 0)
            values(1, i) = Ro * chebyshev0_5(N, i)/wc;
            values(2, i) = chebyshev0_5(N, i)/(wc*Ro);
        else
            values(1, i) = chebyshev0_5(N, i)/(wc*Ro);
            values(2, i) = Ro * chebyshev0_5(N, i)/wc;
        end
    end
    
    values(1, N+1) = Ro * chebyshev0_5(N, N+1);
    values(2, N+1) = Ro * chebyshev0_5(N, N+1);
    values = values.';
end

if lp == 1 && c3db == 1% LOW PASS w/ cheby 3 dB
    for i = 1:N
        if (rem(i,2) ~= 0)
            values(1, i) = Ro * chebyshev3(N, i)/wc;
            values(2, i) = chebyshev3(N, i)/(wc*Ro);
        else
            values(1, i) = chebyshev3(N, i)/(wc*Ro);
            values(2, i) = Ro * chebyshev3(N, i)/wc;
        end
    end
    
    values(1, N+1) = Ro * chebyshev3(N, N+1);
    values(2, N+1) = Ro * chebyshev3(N, N+1);
    values = values.';
end

%% VALUES FOR HIGH PASS
% COLUMN 1: SERIES C then SHUNT L
% COULMN 2: SHUNT L then SERIES C
if hp == 1 && b == 1
    for i = 1:N
        if(rem(i,2) ~= 0)
            values(1, i) = 1/(wc*butterworth(N, i)*Ro);
            values(2, i) = Ro * 1/(wc*butterworth(N, i));
        else
            values(1, i) = Ro * 1/(wc*butterworth(N, i));
            values(2, i) = 1/(wc*butterworth(N, i)*Ro);
        end
    end
    
    values(1, N+1) = Ro * butterworth(N, N+1);
    values(2, N+1) = Ro * butterworth(N, N+1);
    values = values.';
end

if hp == 1 && c == 1
    for i = 1:N
        if(rem(i,2) ~= 0)
            values(1, i) = 1/(wc*chebyshev0_5(N, i)*Ro);
            values(2, i) = Ro * 1/(wc*chebyshev0_5(N, i));
        else
            values(1, i) = Ro * 1/(wc*chebyshev0_5(N, i));
            values(2, i) = 1/(wc*chebyshev0_5(N, i)*Ro);
        end
    end
    
    values(1, N+1) = Ro * chebyshev0_5(N, N+1);
    values(2, N+1) = Ro * chebyshev0_5(N, N+1);
    values = values.';
    
end

if hp == 1 && c3db == 1
    for i = 1:N
        if(rem(i,2) ~= 0)
            values(1, i) = 1/(wc*chebyshev3(N, i)*Ro);
            values(2, i) = Ro * 1/(wc*chebyshev3(N, i));
        else
            values(1, i) = Ro * 1/(wc*chebyshev3(N, i));
            values(2, i) = 1/(wc*chebyshev3(N, i)*Ro);
        end
    end
   
    values(1, N+1) = Ro * chebyshev3(N, N+1);
    values(2, N+1) = Ro * chebyshev3(N, N+1);
    values = values.';
end

%% VALUES FOR BAND PASS
% COL 1 is INDUCTOR, COL 2 is CAPACITOR (SERIES L + SERIES C COMBO FIRST)
% COL 3 is INDUCTOR, COL 4 is CAPACITOR (SHUNT L + SHUNT C COMBO FIRST)
% COLS 1, 2 are linked | COLS 3, 4 are linked
if bp == 1 && b == 1
    for i = 1:N
       if(rem(i,2) ~= 0)
          valuesbp(1,i) = Ro * butterworth(N, i) / BW;
          valuesbp(2,i) = BW / (Ro * wo^2 * butterworth(N, i));
          valuesbp(3,i) = Ro * BW / (wo^2 * butterworth(N, i));
          valuesbp(4,i) = butterworth(N, i) / (Ro * BW);
       else
          valuesbp(1,i) = Ro * BW / (wo^2 * butterworth(N, i));
          valuesbp(2,i) = butterworth(N, i) / (Ro * BW);
          valuesbp(3,i) = Ro * butterworth(N, i) / BW;
          valuesbp(4,i) = BW / (Ro * wo^2 * butterworth(N, i));
       end
    end
    valuesbp(1,N+1) = Ro * butterworth(N, N+1);
    valuesbp(3,N+1) = Ro * butterworth(N, N+1);
    valuesbp = valuesbp.';
end

if bp == 1 && c == 1
    for i = 1:N
       if(rem(i,2) ~= 0)
          valuesbp(1,i) = Ro * chebyshev0_5(N, i) / BW;
          valuesbp(2,i) = BW / (Ro * wo^2 * chebyshev0_5(N, i));
          valuesbp(3,i) = Ro * BW / (wo^2 * chebyshev0_5(N, i));
          valuesbp(4,i) = chebyshev0_5(N, i) / (Ro * BW);
       else
          valuesbp(1,i) = Ro * BW / (wo^2 * chebyshev0_5(N, i));
          valuesbp(2,i) = chebyshev0_5(N, i) / (Ro * BW);
          valuesbp(3,i) = Ro * chebyshev0_5(N, i) / BW;
          valuesbp(4,i) = BW / (Ro * wo^2 * chebyshev0_5(N, i));
       end
    end
    valuesbp(1,N+1) = Ro * chebyshev0_5(N, N+1);
    valuesbp(3,N+1) = Ro * chebyshev0_5(N, N+1);
    valuesbp = valuesbp.';
end

if bp == 1 && c3db == 1
    for i = 1:N
       if(rem(i,2) ~= 0)
          valuesbp(1,i) = Ro * chebyshev3(N, i) / BW;
          valuesbp(2,i) = BW / (Ro * wo^2 * chebyshev3(N, i));
          valuesbp(3,i) = Ro * BW / (wo^2 * chebyshev3(N, i));
          valuesbp(4,i) = chebyshev3(N, i) / (Ro * BW);
       else
          valuesbp(1,i) = Ro * BW / (wo^2 * chebyshev3(N, i));
          valuesbp(2,i) = chebyshev3(N, i) / (Ro * BW);
          valuesbp(3,i) = Ro * chebyshev3(N, i) / BW;
          valuesbp(4,i) = BW / (Ro * wo^2 * chebyshev3(N, i));
       end
    end
    valuesbp(1,N+1) = Ro * chebyshev3(N, N+1);
    valuesbp(3,N+1) = Ro * chebyshev3(N, N+1);
    valuesbp = valuesbp.';
end
