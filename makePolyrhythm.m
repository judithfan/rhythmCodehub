function seqs = makePolyrhythm(k1,k2,m1,m2,phaseShift,reps,shuffFlag)

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
% Last updated: Mar 25 2014 by JEF

% Version log:
% Mar 25 2014 / jef / 
% (1) modified the periodic structure such that component
% rhythms are concatenated without break, and then summed together to form
% polyrhythm 
% (2) added simple visualization of one rep of the polyrhythm and component
% rhythms

% 

% see related: bjorklundAlgorithm, playEuclideanRhythm
% ======================================================================

if ~exist('reps')
   reps = 1; 
end

if ~exist('shuffFlag')
    shuffFlag = 0; % default is not to shuffle, obvi
end

% make Euclidean sequences
sequence1 = bjorklundAlgorithm(k1,m1);
sequence2 = bjorklundAlgorithm(k2,m2);

% sound sepcs
Fs = 44000;      %# Samples per second
toneFreq = 220;  %# Tone frequency, in Hertz
nSeconds = 0.1;   %# Duration of the sound
toneEvent = sin(linspace(0, nSeconds*toneFreq*2*pi, round(nSeconds*Fs)));
toneEvent2 = 1.25*sin(linspace(0,nSeconds*toneFreq*2*pi, round(nSeconds*Fs)));

restEvent = zeros(1,length(toneEvent));
y = [];

totalLength = max(length(sequence1),length(sequence2))*reps;

% loop through rhythm as many times as fits into totalLength, keep
% remainder
sequence1 = repmat(sequence1,1,ceil(totalLength/length(sequence1))); 
sequence2 = repmat(sequence2,1,ceil(totalLength/length(sequence2))); 

% do phase shift
sequence2 = [zeros(1,phaseShift) sequence2];

% add sequences together
sequence1 = sequence1(1:totalLength);
sequence2 = sequence2(1:totalLength);

% compile sequence
rhythm = sum([sequence1; sequence2]); 

seqs.full.polyR = rhythm;
seqs.full.comp1 = sequence1;
seqs.full.comp2 = sequence2;

seqs.single.polyR = rhythm(1:totalLength/reps);
seqs.single.comp1 = sequence1(1:totalLength/reps);
seqs.single.comp2 = sequence2(1:totalLength/reps);

% IFF shuffle==1, then shuffle!
if shuffFlag; rhythm = Shuffle(rhythm); end; 

% pad sequence with rests just before building audio file
rhythm = padSequenceWithRests(rhythm); 
sequence1 = padSequenceWithRests(sequence1); 
sequence2 = padSequenceWithRests(sequence2);

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

% play sound?
sound(y, Fs);  %# Play sound at sampling rate Fs

seqs.y = y;
seqs.Fs = Fs;

% save audio file
cd('poly_wav_files')
%# Save as an 8-bit, 1 kHz signal
wavwrite(y, Fs, 8, ['polyEuclideanrhythm_k' num2str(k1) '_k'  num2str(k2) '_m' num2str(m1) '_m' num2str(m2) '_pS' num2str(phaseShift) '.wav']);
cd ..

% save descriptive stats
seqs.stats.proportion = mean(rhythm);

% make simple visualization
close(1);
f1 = figure(1);
subplot(2,1,1);
purple = [0.8 0.4 0.8];
peach = [0.8 0.4 0.4];
blue = [0.4 0.4 0.8];
gray = [0.8 0.8 0.8];
dataVec = seqs.single.polyR;
plot(dataVec,'LineWidth',2,'Color',gray); hold on;
scatter(1:length(dataVec),dataVec,40,purple,'filled'); hold on;
xlim([0 length(dataVec)+1]);
ylim([-0.2 2.2]);
xlabel('Time Bin')
ylabel('Pulse Amplitude')
title('Final Polyrhythm')
subplot(2,1,2);
jitter = 0.1;
dataVec = seqs.single.comp1;
plot(dataVec,'LineWidth',2,'Color',gray); hold on;
scatter(1-jitter:length(dataVec)-jitter,dataVec,40,peach,'filled'); hold on;
dataVec = seqs.single.comp2;
plot(dataVec,'LineWidth',2,'Color',gray); hold on;
scatter(1+jitter:length(dataVec)+jitter,dataVec,40,blue,'filled'); hold on;
xlim([0 length(dataVec)+1]);
ylim([-0.2 2.2]);
xlabel('Time Bin')
ylabel('Pulse Amplitude')
title('Component Rhythms')

end