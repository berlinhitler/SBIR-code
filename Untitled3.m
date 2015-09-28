scale2 = 8; 
scale  = 1;
SCALEreciprocol = 4;
itNo = int32((scale2-scale) * SCALEreciprocol);
if itNo > 20
	itNo = 20;
end
for i = 1:itNo
    disp(i);
end