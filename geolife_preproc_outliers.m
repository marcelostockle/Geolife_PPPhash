function ind = geolife_preproc_outliers(preP)
  % unaptly named. Actually points to inlier files.
  ind = preP.k_id == 1;
  if (sum(ind) < size(preP.k_id, 1) / 2)
    ind = preP.k_id == 2;
  endif
  if (!preP.outlier)
    ind = true(size(ind));
  endif
endfunction