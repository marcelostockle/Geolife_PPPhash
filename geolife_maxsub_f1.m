function [F1, count] = geolife_maxsub_f1(S, preP, period, min_count, overlap)
  % F1 contains all the 1-patterns that have a minimum support of min_count.
  % F1 includes three atributes:
  % - A numerical symbol (1st column)
  % - An index pointing to the single non-* element in a 
  %     particular pattern (2nd column)
  % - The specific support value (3rd column)
  
  if (nargin < 5)
    overlap = false;
  endif
  outliers = geolife_preproc_outliers(preP);
  accepted = 1:numel(outliers);
  accepted = accepted(outliers);
  
  N = (numel(preP.partX)+1) * (numel(preP.partY)+1);
  aux_win = 1:period;
  count = zeros(N, period);
  for (i = accepted)
    seq = S(i).cseq;
    windows = floor( numel(seq) / period );
    overlap_factor = period;
    if (overlap)
      windows = numel(seq) - period + 1;
      overlap_factor = 1;
    endif
    
    if (windows > 0)
      for (j = 1:windows)
        win = aux_win + (j - 1) * overlap_factor;
        for (p = aux_win)
          count(1 + seq(win(p)), p)++;
        endfor
      endfor
    endif
  endfor
  [I, J] = find(count >= min_count);
  V = count(find(count >= min_count));
  I--;
  F1 = cat(2, I, J, V);
endfunction