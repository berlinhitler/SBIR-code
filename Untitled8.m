clear;
pict = [[17,    24,     1,     8,    15];[23,     5,     7,    14,    16];[4,     6,    13,    20,    22];[10,    12,    19,    21,     3];[11,   18,    25,     2,     9]];
intA = zeros(5);
dirA = zeros(5);
i = ImageProcessing(5,'IMAGE',3);
i.Height = 5;
i.Width = 5;
[intA,dirA] = i.nevat(pict,intA,dirA);