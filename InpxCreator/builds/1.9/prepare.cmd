rar.exe a lib2inpx-win32.rar -r -ep1 -eH -x*\.svn\* bin\*.*
md5sum.exe lib2inpx-win32.rar >lib2inpx.txt
rar.exe a lib2inpx-win64.rar -r -ep1 -eH -x*\.svn\* bin64\*.*
md5sum.exe lib2inpx-win64.rar >>lib2inpx.txt