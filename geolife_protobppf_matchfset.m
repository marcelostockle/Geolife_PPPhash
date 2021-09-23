function Fnew = geolife_protobppf_matchfset(Fmatch, F2, period, min_count)
  if (nargin < 4)
    min_count = 1;
  endif
  
  dim = period * floor(period / 2);
  aux = 1:dim;
  v_ind = [mod(aux - 1, period); mod(aux - 1 + ceil(aux/period), period)];
  
  Fnew = [];
  Fnew.keys = {};
  Fnew.PPPhash = [];
  Fnew.PPPpoint = [];
  order = size(Fmatch.PPPpoint, 2) + 1; % order of the matching patterns
  for (i = 1:numel(Fmatch.keys))
    v_match = v_ind(:, Fmatch.PPPpoint(i, :));
    for (j = 1:numel(F2.keys))
      % verify whether the match between i and j constitute a pattern of
      % one order higher than Fmatch
      v_2 = v_ind(:, F2.PPPpoint(j));
      
      if (max(v_match(:, end)) == min(v_2) && !any(unique(v_match) == max(v_2)))
        % join keys and check for support
        newindex = geolife_protobppf_compareindex(Fmatch.keys{i}, F2.keys{j});
        if (size(newindex, 1) >= min_count)
          Fnew.keys = cat(1, Fnew.keys, {newindex});
          
          aux_PPPhash = cat(2, Fmatch.PPPhash(i,:), F2.PPPhash(j));
          Fnew.PPPhash = cat(1, Fnew.PPPhash, aux_PPPhash);
          
          aux_PPPpoint = cat(2, Fmatch.PPPpoint(i,:), F2.PPPpoint(j));
          Fnew.PPPpoint = cat(1, Fnew.PPPpoint, aux_PPPpoint);
        endif
      endif
    endfor
  endfor
endfunction