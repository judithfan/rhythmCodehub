function sequence = bjorklundAlgorithm(pulses, totalN, saveOrNot)

% Generates Euclidean Rhythm using 'Bjorklund Algorithm'
% Based on Bjorklund 2003 and Toussaint 2005
% Specify # pulses/tones & total # events (tones + rest periods)

% Author: Mariam Aly
% Created: Mar 12 2014

% Bjorklund algorithm aims to space out # pulses over # totalN time
% bins *as evenly as possible*

% pulses = number of events 
% totalN = total number of time bins
% saveOrNot = whether or not you want to save the sequence < default to 0 >

% see related: makePolyrhythm, playEuclideanRhythm
% ======================================================================

if ~exist('saveOrNot')
    saveOrNot = 0;
end

if nargin == 0
    fprintf('You must specify the number of pulses and total number of time bins!\n');
    
elseif nargin == 2 && totalN < pulses
    fprintf('Total # time bins must be larger than # of tones. Try again!\n');
    
else
    if nargin == 1
        totalN = pulses*2;
        fprintf('You did not specify the total number of time bins; defaulted to pulses*2\n');   
    end

    rests = totalN - pulses;
    proceed = 1;


    level = 1;
    bits(level) = rests;
    remainder(level) = pulses;
    sequence = [ones(1,pulses) zeros(1,rests)];
    level= level + 1;

    while proceed
        bits(level) = min(remainder(level-1),bits(level-1));
        remainder(level) = max(remainder(level-1),bits(level-1)) - min(remainder(level-1),bits(level-1));
    
        valueBit = horzcat(sequence(1),sequence(end));
        valueBit = valueBit(1)*10^numel(num2str(valueBit(2))) + valueBit(2);
        valueRemainder = sequence(bits(level)+1);
    
        sequence = [repmat(valueBit,1,bits(level)) repmat(valueRemainder,1,remainder(level))];

        if remainder(level) > 1
            level = level + 1;
        else
            proceed = 0;
        end
          
    end
    
    
sequence = num2str(sequence);
sequence = arrayfun(@str2double, sequence);
sequence = sequence(~isnan(sequence));

if saveOrNot
    cd('stim_mats')
    save(['euclidean_rhythm_' num2str(pulses) '_' num2str(totalN)],'sequence', 'pulses', 'totalN');
    cd ..
end

% fprintf('Saved your sequence. Done!\n');
   
end

end