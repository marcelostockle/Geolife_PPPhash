function finalcount = geolife_maxsub_count(finalcount, pointer, tree)
  
if (finalcount(pointer) == -1)
  finalcount(pointer) = tree{pointer}.count;
  for (j = tree{pointer}.ancestors')
    finalcount = geolife_maxsub_count(finalcount, j, tree);
    finalcount(pointer) += finalcount(j);
  endfor
endif

