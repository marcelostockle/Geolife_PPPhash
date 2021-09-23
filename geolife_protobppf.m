function [S, C] = geolife_protobppf(period, overlap, S, preP)
  outliers = geolife_preproc_outliers(preP);
  accepted = 1:numel(outliers);
  accepted = accepted(outliers);
  N = (numel(preP.partX)+1) * (numel(preP.partY)+1);
  dim = period * floor(period / 2);
  C = sparse(power(N, 2), period * floor(period / 2));
  for (i = accepted)
    seq = S(i).cseq;
    windows = floor( numel(seq) / period );
    overlap_factor = period;
    if (overlap)
      windows = numel(seq) - period + 1;
      overlap_factor = 1;
    endif
    
    if (windows > 0)
      V = zeros(windows, dim);
      aux = 1:dim;
      v_ind = [mod(aux - 1, period); mod(aux - 1 + ceil(aux/period), period)];
      for (j = 1:windows)
        v_ind_instance = v_ind + 1 + (j - 1) * overlap_factor;
        V(j,:) = N * seq(v_ind_instance(1,:)) + seq(v_ind_instance(2,:));
        for (k = 1:dim)
          C(1 + V(j,k), k)++;
        endfor
      endfor
    else
      V = [];
    endif
    S(i).V = V;
    S(i).period = period;
  endfor
endfunction