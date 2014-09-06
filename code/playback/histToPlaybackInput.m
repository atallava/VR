function outStruct = histToPlaybackInput(enc,lzr)
%HISTTOPLAYBACKINPUT Variable transformer.
% 
% outStruct = HISTTOPLAYBACKINPUT(enc,lzr)
%
% enc       - encHistory object.
% lzr       - laserHistory object.
% 
% outStruct - struct with fields ('tEncArray','encArray','tLaserArray','laserArray')

outStruct.tEncArray = enc.tArray-enc.tArray(1);
outStruct.encArray = enc.log;
outStruct.tLaserArray = lzr.tArray-lzr.tArray(1);
outStruct.laserArray = lzr.log;
end

