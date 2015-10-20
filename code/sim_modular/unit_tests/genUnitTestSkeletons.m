function genUnitTestSkeletons(utName)
%GENUNITTESTSKELETONS Generate unit test file skeletons.
% 
% GENUNITTESTSKELETONS(utName)
% 
% utName - String.

fname = utName;
fname = [fname 'UnitTest' '.m'];
fid = fopen(fname,'w');
fclose(fid);

fname = utName;
fname(1) = upper(fname(1));
fname = ['gen' fname 'UnitTestData' '.m'];
fid = fopen(fname,'w');
fclose(fid);
end

