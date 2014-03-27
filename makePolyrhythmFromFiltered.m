function makePolyrhythmFromFiltered(howManySelf, howManyComb, phaseShift, reps, shuffFlag)

% makes the polyrhythms we arrived at after running ER_filtration
%
% howManySelf = # rhythms you want to make that are ER + itself < default : all >
% howManyComb = # rhythms you want to make that are two diff. ERs < default : all >
% phaseShift = # pulses by which to shift rhythm2 relative to rhythm1 < default : 0 >
% reps = # repetitions of rhythm < default : 1 >
% shuffFlag = shuffle the rhythm or not? (prior to repeating) < default : 0 >
%
% Author: Mariam Aly
% Created: March 27, 2014
% Last updated: March 27, 2014
%
% see related: bjorklundAlgorithm, makePolyrhythm, ER_filtration

% =========================================================================


%% load filtered sequences
load er_filt.mat % for ER with itself
load er_comb_filt.mat % for diff ER combinations


%% defaults
if ~exist('howManySelf')
    howManySelf = length(er_filt);
end

if ~exist('howManyComb')
   howManyComb = length(er_comb_filt);
end


% defaults to no phase shift
if ~exist('phaseShift')
   phaseShift = 0;
end


% defaults to 2 reps
if ~exist('reps')
   reps = 1;
end


% defaults to no shuffle
if ~exist('shuffFlag')
    shuffFlag = 0;
end


%% let's make the sequences

% each euclidean rhythm with itself
for i = 1:howManySelf
    makePolyrhythm(er_filt(i,1),er_filt(i,1),er_filt(i,2),er_filt(i,2),phaseShift,reps,shuffFlag)
end

% the constrained ER combinations
for j = 1:howManyComb
    makePolyrhythm(er_comb_filt(j,1),er_comb_filt(j,3),er_comb_filt(j,2),er_comb_filt(j,4),phaseShift,reps,shuffFlag)
end


    
    
    