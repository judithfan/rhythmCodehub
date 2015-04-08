function rhythm = polyrhythmSequence(k1,k2,m1,m2,phaseShift)

% Creates a polyrhythm but does not play it
%   The idea is to use this to further filter the polyrhythms
%   This code has bits from makePolyrhythm

% m1 = total number of time bins for rhythm1
% m2 = total number of time bins for rhythm2
% k1 = total number of pulses in rhythm 1 that fit into m1 time bins
% k2 = total number of pulses in rhythm 2 that fit into m2 time bins
% phaseShift = # pulses by which to shift rhythm2 relative to rhythm1

% see related: bjorklundAlgorithm, makePolyrhythm
% ======================================================================
reps = 1;

% make Euclidean sequences
sequence1 = bjorklundAlgorithm(k1,m1,0);
sequence2 = bjorklundAlgorithm(k2,m2,0);

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


end

