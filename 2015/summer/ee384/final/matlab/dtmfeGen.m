function [ tone, fs ] = dtmfdial( keys )
% dtmfdial - Phone a friend
% Input - 1x? matrix of keys pressed 1-12, such as [1 3 5 9 11 12]
% Output - Audio at 8kHz, sampling frequency

% DTMF
%  ___________________________
% | Freq | 1209 | 1336 | 1477 |
% |  697 |   1  |  2   |  3   |
% |  770 |   4  |  5   |  6   |
% |  852 |   7  |  8   |  9   |
% |  941 | *(11)| 0(10)| #(12)|
% |______|______|______|______|

% Variables
fs=8000; % Sampling frequency
td=0.5; % Tone duration
sd=0.1; % Space duration
cols=[1209 1336 1477]; % Frequencies from table
rows=[697 770 852 941]; % Frequencies from table
tone_len=0; % Index for tone variable
tone=zeros(1,(length(keys))*fs*0.6); % Initialize sound vector

% For every button value in the input vector.
for button = keys
    % Fix the keymapping so that buttons are sequential
    if button == 10
        button = 11;
    elseif button == 11
        button = 10;
    end
    
    % Get row and column index
    col_index=mod((button-1),3)+1;
    row_index=int8(ceil(button/3));
    
    % Use indecies to get frequency
    freq1=cols(col_index);
    freq2=rows(row_index);
    
    % Create tone's time vector
    t=0:(1/fs):td;
    
    % Generate the tone
    button_tone=sin(2*pi*t*freq1)+sin(2*pi*t*freq2);
    silence=zeros(1,(sd*fs));
    
    % Append to output
    tone((tone_len+1):(tone_len+length(t)+length(silence)))=[button_tone silence];
    tone_len=(tone_len+length(t)+length(silence));
end

end



