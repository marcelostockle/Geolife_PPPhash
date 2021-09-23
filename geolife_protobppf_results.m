function [S, C, F] = geolife_protobppf_results(S, preP, period, min_count)
% output: 
%   S.V stores the hash keys associated to every period
%   C counts the numbers of collisions in each bucket
%   F are all the frequent partial patterns separeted by pattern order

[S, C] = geolife_protobppf(period, false, S, preP);

% calculating 2nd order patterns and extracting the index structures is
% the first step. The resulting set of indeces (2nd order) is what all 
% following steps will be matched against, so we will refer to this
% set as F{1}.
F = cell(period - 1, 1);
F{1} = geolife_protobppf_index(S, preP, C, min_count);

% Now, proceed to find F3, F4 and so on (the pattern order is at most the same
% as the period). To find F3, we match F{1} against itself. With every match, 
% a new index is formed with all the elements contained in both indeces. If
% the size of the resulting index is big enough, it's appended to F3.
% If F3 is non-empty, F4 is obtained the same way, only now matching F3 and F{1}.

% Use this module to derivate a new F-set. A new F-set is obtained by matching
% F{1} and another F-set (if this is F{1} again, the resulting set is F3).
Fmatch = F{1}; % Initial iteration
for (order = 3:period)
  Fmatch = F{order - 2};
  F{order - 1} = geolife_protobppf_matchfset(Fmatch, F{1}, period, min_count);
endfor