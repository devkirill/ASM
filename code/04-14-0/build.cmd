@set path=%path%;C:\DOS\ASM\BUILD
@python C:\DOS\ASM\build\gen.py MAIN.CODE > MAIN.ASM || PAUSE && EXIT

"C:\Program Files (x86)\DOSBox-0.74\DOSBOX.exe"