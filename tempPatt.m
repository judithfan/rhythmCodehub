
%-------------------------------------------------------------------------
%**Version...
%-------------------------------------------------------------------------

% Stimuli


% Specifics
%# patterns
%

% Reproduction


%% input dialog box
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clc;
prompt = {'Subject number: ', 'Subject ID: ', 'Practice: '};
defaults = {'', '', '0'};
answer = inputdlg(prompt, 'Experimental setup information', 1, defaults);
[subject_number subject_initials practice] = deal(answer{:});  

subject_number = str2double(subject_number);
practice       = str2double(practice);
    

%% Set Boilerplate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

seed = sum(100*clock);
rand('twister',seed); %#ok<RAND>
ListenChar(2);
HideCursor;
GetSecs;
AssertOpenGL;
Priority(0);
Screen('Preference', 'SkipSyncTests', 1 );


%% Folders and paths

root_dir    = pwd;
subject_dir = [root_dir, '/../data/subject', num2str(subject_number), '/'];

addpath([root_dir '/scripts']);

% creating the subject directory if it doesn't exist
if(~(exist(subject_dir))) %#ok<EXIST>
    mkdir(subject_dir);
end
addpath(subject_dir);
   

%% Set Keys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% platform-independent responses
KbName('UnifyKeyNames');

space  = KbName('SPACE');
lshift = KbName('LeftShift');
rshift = KbName('RightShift');


%% Create Screens
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

backColor = 127;
textColor = 255;
dotColor  = 255;

Screens = [0 1];

[MainWindow, rect] = Screen('OpenWindow',min(Screens),backColor);

Screen_X = rect(3); 
Screen_Y = rect(4);

cx = (Screen_X/2);          % center of the screen in the x dimension
cy = (Screen_Y/2);          % center of the screen in the y dimension

ScreenRect = [0,0,Screen_X,Screen_Y]; 
FixDotRect = [cx - 3, cy - 3, cx + 3, cy + 3];


% setting font size and style
Screen(MainWindow,'TextFont', 'Arial');
Screen(MainWindow,'TextSize', 18);
Screen(MainWindow,'TextStyle', 0);



%% Set Paths 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

root_dir    = '.';
subject_dir = [root_dir, '/data/subject', num2str(subject_number), '/'];

        
    
%% Create Data Structures and Write Files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% creating the subject directory if it doesn't exist
if(~(exist(subject_dir))) %#ok<EXIST>
    mkdir(subject_dir);
end
addpath(subject_dir);


data_file = [subject_dir '/tempPatt'];

        
while(true)
    if exist([data_file '.mat'], 'file')
        data_file = [data_file '+']; %#ok<AGROW>
    else
        data_file = [data_file '.mat']; %#ok<AGROW>
        break;
    end
end  
    
% saving general subject/set-up info
data.subject_number   = subject_number;
data.subject_initials = subject_initials;
data.date             = datestr(now,0);
    
    
%% Stimuli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_trials = 1;

reps = 2;

k1 = 2;     % k1   = zeros(1,n_trials);
k2 = 3;     % k2   = zeros(1,n_trials);
m1 = 15;    % m1   = zeros(1,n_trials);
m2 = 11;    % m2   = zeros(1,n_trials);
ps = 3;     %ps   = zeros(1,n_trials);


iti_dur         = 0.5;
response_window = 15;

%(this is where we'd load up the rhythms, select a subset randomly,
%randomize the order of presentation)
rhythm = cell(1,n_trials);


%% Run Experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Priority(2);

for trial_index = 1:n_trials

    % SHOW INSTRUCTIONS
    instructString = 'Listen to the following sound sequence';
    boundRect      = Screen('TextBounds', MainWindow, instructString);
    Screen('drawtext',MainWindow,instructString,cx-boundRect(3)/2,cy-boundRect(4),textColor);
    Screen('Flip',MainWindow);  

    % WAITING
    trial_start = KbWait([],2);
    Screen('Flip',MainWindow);
    stim_start  = trial_start + iti_dur;
    WaitSecs('UntilTime', stim_start-0.01);

    % DOT
    Screen(MainWindow, 'FillOval', dotColor, FixDotRect);
    Screen('Flip', MainWindow);
    
    % PLAY SOUND (currently makes up a polyrhythm - later should select from the list)
    rhythm{trial_index} = ...
        makePolyrhythm(k1(trial_index),k2(trial_index),m1(trial_index),m2(trial_index),reps(trial_index), ps(trial_index)); 

    
    % SHOW PROMPT
    instructString = 'Your turn!';
    boundRect      = Screen('TextBounds', MainWindow, instructString);
    Screen('drawtext',MainWindow,instructString,cx-boundRect(3)/2,cy-boundRect(4),textColor);
    stim_end = Screen('Flip',MainWindow); 

    % RECORD RESPONSE
    FlushEvents('keyDown');
    response_attempt = 0;
    while (GetSecs - stim_end < response_window) 
        WaitSecs(.005);
        [keyIsDown, secs, keyCode] = KbCheck; 
        if (keyIsDown)
            if keyCode(lshift)
                instructString = 'recording...';
                boundRect      = Screen('TextBounds', MainWindow, instructString);
                Screen('drawtext',MainWindow,instructString,cx-boundRect(3)/2,cy-boundRect(4),textColor);
                response_start   = Screen('Flip', MainWindow);
                response_attempt = response_attempt+1;
                response{response_attempt} = []; %#ok<SAGROW>
                WaitSecs(.1);
            else if keyCode(space)
                response{response_attempt} = [response{response_attempt}, secs - stim_end]; %#ok<SAGROW>
                WaitSecs(.1);
                else if keyCode(rshift)
                        break;                     
                    end
                end
            end
        end
    end 

    % SAVE RESPONSE
    data.trial_start(trial_index)    = trial_start;
    data.stim_start(trial_index)     = stim_start;
    data.stim_end(trial_index)       = stim_end;   
    data.response_start(trial_index) = response_start;
    data.response{trial_index}       = response;


    save(data_file,'data');
end
    
Priority(0);
    
save(data_file,'data');
    
% save everything in the workspace!
struct_dir = [subject_dir '/saved_structs'];
if(~(exist(struct_dir)>0)) %#ok<EXIST>
    mkdir(struct_dir);
end
struct_file = [subject_dir '/saved_structs/saved_structs_sub_' int2str(subject_number)];  
save(struct_file);    
    
    
% EXPERIMENT OVER
instructString = 'All done!';
boundRect      = Screen('TextBounds', MainWindow, instructString);
Screen('drawtext',MainWindow,instructString,cx-boundRect(3)/2,cy-boundRect(4),textColor);
Screen('Flip',MainWindow);
    
WaitSecs(3);
    
    
%% Clean up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Screen closeall;
ListenChar(1);
ShowCursor;
fclose('all');
Screen('CloseAll');
    
    