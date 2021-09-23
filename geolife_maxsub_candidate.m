function order = geolife_maxsub_candidate(maxsub, pattern)
  testing = false(size(maxsub.children));
  for (i = 1:numel(testing))
    testing(i) = maxsub.elements(i, 1) == pattern(maxsub.elements(i, 2));
  endfor
  order = sum(testing);
endfunction