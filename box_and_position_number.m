function [cur_A, cur_B, cur_M, cur_N, pos_A, pos_B, pos_M, pos_N] = ...
    box_and_position_number(box, offset_ele, idx_cur_A, idx_cur_B,...
    idx_cur_M, idx_cur_N, idx_pos_A, idx_pos_B,...
    idx_pos_M, idx_pos_N)
% Computes the current box and position numbers and returns them
%
% SYNTAX
%   [cur_A, cur_B, cur_M, cur_N, pos_A, pos_B, pos_M, pos_N] = ...
%               box_and_position_number(box, offset_ele, idx_cur_A,...
%                idx_cur_B, idx_cur_M, idx_cur_N, idx_pos_A, idx_pos_B,...
%                idx_pos_M, idx_pos_N)
%
% INPUT PARAMETER
%   box         ... Array, with all working boxes
%   offset_ele  ... Integer, position of the first electrode (profile
%                   meter)
%   idx_cur_A   ... Integer, index of box A
%   idx_cur_B   ... Integer, index of box B
%   idx_cur_M   ... Integer, index of box M
%   idx_cur_N   ... Integer, index of box N
%   idx_pos_A   ... Integer, index of elektrode A
%   idx_pos_B   ... Integer, index of elektrode B
%   idx_pos_M   ... Integer, index of elektrode M
%   idx_pos_N   ... Integer, index of elektrode N
%
% OUTPUT PARAMETER
%     cur_A     ... Integer, number of the box at electrode A
%     cur_B     ... Integer, number of the box at electrode B
%     cur_M     ... Integer, number of the box at electrode M
%     cur_N     ... Integer, number of the box at electrode N
%     pos_A     ... Integer, electrode position A
%     pos_B     ... Integer, electrode position B
%     pos_M     ... Integer, electrode position M
%     pos_N     ... Integer, electrode position N

%% Box number -> Interface

cur_A = box(idx_cur_A);         % box at position A
cur_M = box(idx_cur_M);         % box at position M
cur_N = box(idx_cur_N);         % box at position N
if idx_cur_B == 0
    cur_B = 0;                  % electrode far away (pol-dipol)
else
    cur_B = box(idx_cur_B);     % box at position B
end

%% Electrode number -> file

pos_A = idx_pos_A + offset_ele; % position of electrode A
pos_M = idx_pos_M + offset_ele; % position of electrode M
pos_N = idx_pos_N + offset_ele; % position of electrode N
if idx_pos_B == 0
    pos_B = 0;                 % position of electrode B
else
    pos_B = idx_pos_B + offset_ele; % position of electrode B
end

end
