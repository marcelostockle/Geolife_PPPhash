%%
outliers = geolife_preproc_outliers(preP);
accepted = 1:numel(outliers);
accepted = accepted(outliers);

% Extra pre-processing. Sequences are condensed to either 1) denote movement
% from one quadrant to another EXCLUSIVELY or 2) denote quadrant position at
% fixed time intervals. Choose the prefer modality by setting fixed_time_conf.
% This process will create the S.cseq field (condensed sequence).
fixed_time_conf = false;

% units: Seconds
fixed_time = 120.0 ; 
% transforms the input value to DAYS units
fixed_time = fixed_time / (24 * 60 * 60); 

for (i = accepted)
  if (fixed_time_conf)
    len = numel(S(i).seq);
    ind = zeros(1, len);
    timest = S(i).traj(1,1);
    ind(1) = 1;
    for (j = 2:len)
      if (S(i).traj(j,1) > timest + fixed_time)
        ind(j) = 1;
        timest = S(i).traj(j,1);
      endif
    endfor
    ind = find(ind);
    S(i).cseq = S(i).seq(ind);
  else  
    ind = cat(1, 1, diff(S(i).seq));
    ind = find(ind != 0);
    S(i).cseq = S(i).seq(ind);
  endif
endfor


% Max-subpattern
% First step, find F1
period = 5;
min_count = 30;
F1 = geolife_maxsub_f1(S, preP, period, min_count, false);
tree = geolife_maxsub(S, preP, F1, period, min_count, false);

finalcount = -1 * ones(size(tree));
for (i = 1:numel(tree))
  finalcount = geolife_maxsub_count(finalcount, i, tree);
endfor
[sort_val,sort_ind] = sort(finalcount, "descend");
sort_ind = sort_ind(sort_val>0);
finalcount = finalcount(sort_ind);
for (i = 1:numel(sort_ind))
  cat(2, [sort_ind(i); finalcount(i)], tree{sort_ind(i)}.elements')
endfor
