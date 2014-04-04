% Sort through all_er in order to discover which rhythms satisfy our list
% of constraints
% Then combine each rhythm with all others and do constraint satisfaction
% on the combinations


% initialize workspace
clear all;
close all;
clc;

%load all_er -- a numER x 2 matrix (first column=k, second column=m)
load('/Volumes/ntb/collab/rhythmCoding/rhythmCodehub/allER.mat');


% set upper and lower bounds for m's (# total time bins in each component
% rhythm)
m.lb = 9;
m.ub = 19;

numER = size(all_er,1);

%filtering
er_filt  = [];
er_index = 0;
for i = 1:numER
    thisER = all_er(i,:);
    
    %constraint: k <= 0.5*m
    if thisER(1) <= 0.5*thisER(2)
        %constraint: m within interval set by [m.lb, m.ub]
        if thisER(2) <= m.ub && thisER(2) >= m.lb
            er_index = er_index + 1;
            er_filt  = [er_filt; thisER];  %#ok<AGROW>
        end
    end
end

numER_filt = size(er_filt,1);

%creating all possible combinations
er_combs = er_filt; 
er_combs = horzcat(er_filt,circshift(er_filt,1));
for er_index = 2:(numER_filt-1)   
    er_combs = vertcat(er_combs,horzcat(er_filt,circshift(er_filt,er_index))); %#ok<AGROW>
end

numER_combs = size(er_combs,1);

%filtering
er_comb_filt = [];
er_index     = 0;
for i = 1:numER_combs
    thisER = er_combs(i,:);
    
    %constraint: m1 = m2+-2
    if abs(thisER(2)-thisER(4)) < 3
        %constraint: min(m1,m2) > max(k1,k2)
        if min(thisER(2),thisER(4)) > max(thisER(1),thisER(3))
            er_index = er_index + 1;
            er_comb_filt = [er_comb_filt; thisER]; %#ok<AGROW>
        end
    end
end


for phase_shift = 0:3
    
   rhythm = polyrhythmSequence(k1,k2,m1,m2,phaseShift)







