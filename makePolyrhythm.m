function rhythm = makePolyrhythm(k1,k2,m1,m2,phaseShift,reps)

% Plays two-component polyrhythm using bjorklund-spaced rhythms provided in
% Bjorklund algorithm

% m = total number of time bins
% k1 = total number of pulses in rhythm 1 that fit into m time bins
% k2 = total number of pulses in rhythm 2 that fit into m time bins
% reps = total number of repetitions of rhythm

% Author: Judy Fan (based upon code by Mariam Aly)
% Created: Mar 11 2014
% Last updated: Mar 19 2014

% see related: bjorklundAlgorithm, playEuclideanRhythm
% ======================================================================

if ~exist('reps')
   reps = 1; 
end

% make Euclidean sequences
sequence1 = bjorklundAlgorithm(k1,m1);
sequence2 = bjorklundAlgorithm(k2,m2);

% do phase shift
sequence2 = [zeros(1,phaseShift) sequence2];

% sound sepcs
Fs = 44000;      %# Samples per second
toneFreq = 440;  %# Tone frequency, in Hertz
nSeconds = 0.1;   %# Duration of the sound
toneEvent = sin(linspace(0, nSeconds*toneFreq*2*pi, round(nSeconds*Fs)));
toneEvent2 = 1.5*sin(linspace(0,nSeconds*toneFreq*2*pi, round(nSeconds*Fs)));

restEvent = zeros(1,length(toneEvent));
y = [];

% add sequences together
totalLength = max(length(sequence1),length(sequence2));

if length(sequence1) < totalLength
    sequence1 = [sequence1 zeros(1,totalLength-length(sequence1))];
elseif length(sequence2) < totalLength
    sequence2 = [sequence2 zeros(1,totalLength-length(sequence2))]
end

full_sequence = sum([sequence1; sequence2]); rhythm = full_sequence;

% make and play full sequence
for thisBeat = 1:length(full_sequence)
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

wavwrite(y, Fs, 8, ['polyEuclideanrhythm_k' num2str(k1) '_k'  num2str(k2) '_m' num2str(m1) '_m' num2str(m2) '_pS' num2str(phaseShift) '.wav']);
%# Save as an 8-bit, 1 kHz signal

end
    

