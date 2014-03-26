% List of Euclidean Rhythms

% rhythmCoding project
% created: Mar 25 2014
% from Demaine et al. (2009) The distance geometry of music (p.17-18)

% Initalize workspace
clear all;
close all;
clc;

% The following Euclidean rhythms are Euclidean strings:
er_es = [2 3;
 2 5;
 3 4;
 3 7;
 4 5;
 4 9;
 5 6;
 5 11;
 5 16;
 6 7;
 6 13;
 7 8;
 7 15;
 8 17];
 
% The following Euclidean rhythms are reverse Euclidean strings:
er_res = [3 5;
 3 8;
 3 11;
 3 14;
 4 7;
 4 11;
 4 15;
 5 7;
 5 9;
 5 12;
 7 9;
 7 10;
 7 16;
 7 17;
 9 22;
 11 12;
 11 24];

% The following Euclidean rhythms are neither Euclidean nor reverse Euclidean strings:
 er_nes = [5 8;
  5 13;
  7 12;
  7 18;
  8 19;
  9 14;
  9 16;
  9 23;
  13 24;
  15 34];

% concatenate all rhythms
all_er = vertcat(er_es,er_res,er_nes);
all_er = sortrows(all_er);

% save all
save('allER.mat')