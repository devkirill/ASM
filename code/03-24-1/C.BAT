@ECHO OFF

call ../path.bat

tasm main+print+args
tlink /t main+print+args

del *.obj
del *.map