function F1 = geolife_protobppf_index(S, preP, count, min_count)
% T is the hash table including two pointers: one to a specific S instance
% and another to a specific V instance. Both pointers constitute a key.
% "count" counts the number of keys, or collisions, in each table cell, and
% it is stored as a sparse matrix.

outliers = geolife_preproc_outliers(preP);
accepted = 1:numel(outliers);
accepted = accepted(outliers);

F1 = [];
if (isempty(accepted))
  disp("No sequence files detected");
  return;
endif

if (isfield(S, "V"))
  period = S(accepted(1)).period;
  N = (numel(preP.partX)+1) * (numel(preP.partY)+1);
  
  [PPPhash, PPPpoint] = find(count >= min_count);
  PPPhash--; % THIS IS KEY TO MAINTAIN AN INDEX-0 HASH
  count_val = count(count >= min_count);
  countdown = ones(size(count_val));
  keys = cell(size(count_val));
  for (i = 1:numel(keys))
    keys{i} = zeros(count_val(i), 2);
  endfor
  
  for (i = accepted)
    for (j = 1:size(S(i).V, 1))
      for (k = 1:size(S(i).V, 2))
        key_ind = find(PPPhash == S(i).V(j,k) & PPPpoint == k);
        if (numel(key_ind) == 1)
          keys{key_ind}(countdown(key_ind), [1 2]) = [i j];
          countdown(key_ind)++;
        endif
      endfor
    endfor
  endfor
  
  F1.keys = keys;
  F1.PPPhash = PPPhash;
  F1.PPPpoint = PPPpoint;
else
  disp("Field S.V not found. Run geolofe_protobppf before this function.")
endif
