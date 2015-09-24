pict = [123 1 5 7; 30 200 302 1; 3 3 50 101; 9 54 8 100];
pict(pict>=100) = 255;
n = numel(pict);
Height=size(pict,1);
Weight=size(pict,2);
for ending = 1:n
    if pict(ending)==255
        [j,k]=ind2sub([Height,Weight],ending)
    end
end