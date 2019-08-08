
cd "C:/Users/Franke/workspace/godot"

rm -R ./bin/*

scons -j6 p=windows tools=yes module_mono_enabled=yes mono_glue=no
./bin/godot.windows.tools.64.mono.exe --generate-mono-glue modules/mono/glue
scons -j6 p=windows tools=yes module_mono_enabled=yes mono_glue=yes

./bin/godot.windows.tools.64.mono.exe


