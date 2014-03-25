function rhythm = padSequenceWithRests(sequence)

% Author: Judy Fan
% Created: Mar 24 2014
% Last updated: Mar 24 2014

% Pads all events with rests so as to be able to distinguish between
% adjacent events


seqLen = length(sequence);
expandedSeq = zeros(1,seqLen*2);
expandedSeq(2:2:seqLen*2) = sequence;

rhythm = expandedSeq;
