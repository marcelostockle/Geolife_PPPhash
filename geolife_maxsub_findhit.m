function [pointer, child_ind] = geolife_maxsub_findhit(pointer, tree, pattern)
  % If a hit is found in the tree, a pointer is returned (child_ind is zero).
  % If a hit is NOT found, a pointer and a child_ind are returned.
  % If a hit is NOT found and there are no valid children, pointer is zero.
  
  child_ind = 0;
  ind = 1:numel(tree{pointer}.children);
  prohibited_ind = ind(tree{pointer}.children == -1);
  for (i = prohibited_ind)
    pattern_sym = tree{pointer}.elements(i, 1);
    pattern_ind = tree{pointer}.elements(i, 2);
    if (pattern(pattern_ind) != pattern_sym)
      pointer = 0;
      return;
    endif
  endfor
  
  ind = ind(tree{pointer}.children >= 0);
  for (i = ind)
    pattern_sym = tree{pointer}.elements(i, 1);
    pattern_ind = tree{pointer}.elements(i, 2);
    if (pattern(pattern_ind) != pattern_sym)
      aux_pointer = tree{pointer}.children(i);
      if (aux_pointer == 0)
        child_ind = i;
        return;
      elseif (aux_pointer > 0)
        [pointer, child_ind] = geolife_maxsub_findhit(aux_pointer, tree, pattern);
        return;
      endif
    endif
  endfor
endfunction