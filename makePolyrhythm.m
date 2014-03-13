function rhythm = makePolyrhythm(k1,k2,m,reps)

% Plays two-component polyrhythm using bjorklund-spaced rhythms provided in
% Bjorklund algorithm

% m = total number of time bins
% k1 = total number of pulses in rhythm 1 that fit into m time bins
% k2 = total number of pulses in rhythm 2 that fit into m time bins
% reps = total number of repetitions of rhythm

% Author: Judy Fan (based upon code by Mariam Aly)
% Created: Mar 11 2014
% Last updated: Mar 13 2014

% see related: bjorklundAlgorithm, playEuclideanRhythm
% ======================================================================

if ~exist('reps')
   reps = 1; 
end

sequence1 = bjorklundAlgorithm(k1,m);
sequence2 = bjorklundAlgorithm(k2,m);

Fs = 44000;      %# Samples per second
toneFreq = 440;  %# Tone frequency, in Hertz
nSeconds = 0.1;   %# Duration of the sound
toneEvent = sin(linspace(0, nSeconds*toneFreq*2*pi, round(nSeconds*Fs)));
toneEvent2 = 1.5*sin(linspace(0,nSeconds*toneFreq*2*pi, round(nSeconds*Fs)));

restEvent = zeros(1,length(toneEvent));
y = [];

full_sequence = sum([sequence1; sequence2]); rhythm = full_sequence;

for thisBeat = 1:m
    if full_sequence(thisBeat) > 1
        y = horzcat(y,toneEvent2);
    elseif full_sequence(thisBeat) == 1
        y = horzcat(y,toneEvent);
    else
        y = horzcat(y,restEvent);
    end
end

y = repmat(y,1,reps); % produce # reps copies of rhythm 

sound(y, Fs);  %# Play sound at sampling rate Fs

wavwrite(y, Fs, 8, ['polyEuclideanrhythm_' num2str(k1) '_'  num2str(k2) '_' num2str(m) '.wav']);
%# Save as an 8-bit, 1 kHz signal

end
    

