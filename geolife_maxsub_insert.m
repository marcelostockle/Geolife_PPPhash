function [tree, newind] = geolife_maxsub_insert(tree, newind, pointer, child)
  if (tree{pointer}.children(child) == 0)
    if (newind > numel(tree))
      % resize tree table (double)
      emptytree = cell(size(tree));
      tree = cat(1, tree, emptytree);
    endif
    tree{newind} = tree{pointer};
    rem_ind = cat(2, 1:(child - 1), (child + 1):numel(tree{pointer}.children));
    tree{newind}.elements = tree{newind}.elements(rem_ind, :);
    tree{newind}.children = zeros(numel(rem_ind), 1);
    tree{newind}.count = 0;
    tree{newind}.ancestors = [];
    
    % Section: Refresh ancestors
    N = numel(tree{newind}.children);
    for (i = 1:newind)
      % Verify whether tree{i} is on the tier above
      if (numel(tree{i}.children) == N + 1)
        % Find the difference between tree{i} and tree{newind}
        missing_elem = sum(tree{i}.elements, 1) - sum(tree{newind}.elements, 1);
        % Find the missing element
        missing_ind = find(
          tree{i}.elements(:,1) == missing_elem(1) & 
          tree{i}.elements(:,2) == missing_elem(2));
        if (~isempty(missing_ind))
          % Link parent-child
          tree{i}.children(missing_ind) = newind;
          tree{newind}.ancestors = cat(1, tree{newind}.ancestors, i);
        endif
      endif
    endfor
    
    % Section: Find invalid children
    for (i = 1:N)
      tree{newind}.children(i) = 0;
      unique_pos = tree{newind}.elements(:, 2);
      unique_pos = unique_pos(cat(2, 1:(i - 1), (i + 1):N));
      unique_pos = unique(unique_pos);
      if (numel(unique_pos) == 1)
        % invalid child
        tree{newind}.children(i) = -1;
      endif
    endfor
    
    % Finally, refresh "newind" to allow for new inserts
    newind++;
  endif
endfunction