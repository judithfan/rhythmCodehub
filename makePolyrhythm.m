function rhythm = makePolyrhythm(k1,k2,m1,m2,phaseShift,reps,shuffle)

% Plays two-component polyrhythm using bjorklund-spaced rhythms provided in
% Bjorklund algorithm

% m1 = total number of time bins for rhythm1
% m2 = total number of time bins for rhythm2
% k1 = total number of pulses in rhythm 1 that fit into m1 time bins
% k2 = total number of pulses in rhythm 2 that fit into m2 time bins
% phaseShift = # pulses by which to shift rhythm2 relative to rhythm1
% reps = total number of repetitions of rhythm
% shuffle = flag for whether you want to shuffle the rhythm or not (prior
% to repeating)

% Author: {Mariam Aly, Judy Fan}
% Created: Mar 11 2014
% Last updated: Mar 24 2014 by JEF

% see related: bjorklundAlgorithm, playEuclideanRhythm
% ======================================================================

if ~exist('reps')
   reps = 1; 
end

if ~exist('shuffle')
    shuffle = 0; % default is not to shuffle, obvi
end

% make Euclidean sequences
sequence1 = bjorklundAlgorithm(k1,m1);
sequence2 = bjorklundAlgorithm(k2,m2);

% do phase shift
sequence2 = [zeros(1,phaseShift) sequence2];

% sound sepcs
Fs = 44000;      %# Samples per second
toneFreq = 220;  %# Tone frequency, in Hertz
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
    sequence2 = [sequence2 zeros(1,totalLength-length(sequence2))];
end

% compile sequence
rhythm = sum([sequence1; sequence2]); 

% pad sequence with rests
rhythm = padSequenceWithRests(rhythm); 

% IFF shuffle==1, then shuffle!
if shuffle; rhythm = Shuffle(rhythm); end; 

% loop through rhythm #reps times
rhythm = repmat(rhythm,1,reps); 

% make and play full sequence
for thisBeat = 1:length(rhythm)
    if rhythm(thisBeat) > 1
        y = horzcat(y,toneEvent2);
    elseif rhythm(thisBeat) == 1
        y = horzcat(y,toneEvent);
    else
        y = horzcat(y,restEvent);
    end
end

sound(y, Fs);  %# Play sound at sampling rate Fs

cd('poly_wav_files')
%# Save as an 8-bit, 1 kHz signal
wavwrite(y, Fs, 8, ['polyEuclideanrhythm_k' num2str(k1) '_k'  num2str(k2) '_m' num2str(m1) '_m' num2str(m2) '_pS' num2str(phaseShift) '.wav']);
cd ..

end