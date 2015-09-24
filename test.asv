%%[FileName, PathName] = uigetfile({'*.jpg; *.jpeg; *.jpe; *.jfif; *.png; *.bmp; *.raw','Image Files (*.jpg, *.jpeg, *.jpe, *.jfif, *.png, *.bmp, *.raw)'},'Select a image');
fileName = 'nopassaffinegray.bmp';
%%OriginalImage = imread(fullfile(PathName, fileName));
originalImage = imread(fileName);
image(originalImage);
L2PID = fopen('IMAGELine2Para-is.rlt','r');
L2P = fscanf(L2PID,'%i');
fclose(L2PID);