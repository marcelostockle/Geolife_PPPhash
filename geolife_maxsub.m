function tree = geolife_maxsub(S, preP, F1, period, min_count, overlap)
  if (nargin < 6)
    overlap = false;
  endif
  
  % When creating a node, it's essential to link to ancestors BOTH WAYS
  maxsub_treesize = 100;

  % root.elements is a N x 2 matrix describing all the elements in a pattern.
  % the 1st column represents a quadrant, and the 2nd is a position in a pattern.
  %
  % root.children and root.ancestors are a list is indeces pointing to items
  %   in the tree. They must be refreshed every time a new node is created.
  % nodes have N potential children. These are initialized with a value of 
  %   zero, and later may point to another item in the tree when it applies.
  % In order to refresh root.ancestors, read the entire tree top-down, find the
  %   existing children pointers, then write the reciprocal ancestor pointers.
  root = [];
  root.elements = F1(:, [1 2]);
  root.count = 0;
  root.children = zeros(size(F1, 1), 1);
  root.ancestors = [];

  % tree_newindex points to the last non-null item in the tree.
  tree_newindex = 2;
  tree = cell(maxsub_treesize, 1);
  tree{1} = root;
  
  if (nargin < 5)
    overlap = false;
  endif
  outliers = geolife_preproc_outliers(preP);
  accepted = 1:numel(outliers);
  accepted = accepted(outliers);
  
  N = (numel(preP.partX)+1) * (numel(preP.partY)+1);
  aux_win = 1:period;
  T = zeros(N, period);
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
        % Verify whether a pattern is a hit candidate
        % seq(win)
        order = geolife_maxsub_candidate(tree{1}, seq(win));
        if (order > 1)
          % look for hit or new leaf to insert
          [pointer, child] = geolife_maxsub_findhit(1, tree, seq(win));
          while (pointer > 0)
            if (child == 0) % hit
              tree{pointer}.count++;
              pointer = 0;
            else % insert
              [tree, tree_newindex] = geolife_maxsub_insert(tree, tree_newindex, pointer, child);
              % [tree{tree_newindex - 1}.elements tree{tree_newindex - 1}.children]
              [pointer, child] = geolife_maxsub_findhit(tree{pointer}.children(child), tree, seq(win));
            endif
          endwhile
        endif
      endfor
    endif
  endfor
  
  % null elements are culled from the tree
  tree = tree(1:tree_newindex-1);
  
endfunction