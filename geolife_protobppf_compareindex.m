function I = geolife_protobppf_compareindex(A, B)
  
  % return coocurrences between two indeces produced by either
  % geolife_protobppf_index or this very function.
  
  % to note, indeces are always stored in increasing order. In order of
  % priority: first column, THEN second column.
  
  % this function will return the combined index including all coincidences
  
  I = A;
  ind = false(size(I, 1), 1);
  for (i = 1:size(A, 1))
    if (any(B(:,1) == A(i,1) & B(:,2) == A(i,2)))
      ind(i) = true;
    endif
  endfor
  I = I(ind, :);
endfunction
