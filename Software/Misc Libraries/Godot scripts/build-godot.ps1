
cd "C:/Users/Franke/workspace/godot"

rm -R ./bin/*

scons -j6 p=windows tools=yes

./bin/godot.windows.tools.64.exe


