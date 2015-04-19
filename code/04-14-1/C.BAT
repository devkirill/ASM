@ECHO OFF

call ../path.bat

tasm main
tlink /t main

del *.obj
del *.map