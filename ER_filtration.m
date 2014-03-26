% Sort through all_er in order to discover which rhythms are useable in our
% stimulus list

% initialize workspace
clear all;
close all;
clc;

%load all_er
%all_er is a numER x 2 matrix (first column=k, second column=m)
load('/Volumes/ntb/collab/rhythmCoding/rhythmCodehub/allER.mat');


% set upper and lower bounds for m's (# total time bins in each component
% rhythm)
m.lb = 9;
m.ub = 19;

numER = size(all_er,1);

er_filt = [];

for er_index = 1:numER
    thisER = all_er(er_index,:);
    
    %constraint: k <= 0.5*m
    if thisER(1) <= 0.5*thisER(2)
        %constraint: m within interval set by [m.lb, m.ub]
        if thisER(2) <= m.ub && thisER(2) >= m.lb
            er_filt = [er_filt; thisER]; %#ok<AGROW>
        end
    end
    
    
    
end

% upper and lower bounds for k's (# pulses in a given rhythm)
k.lb = min([m.lb m.ub]);


