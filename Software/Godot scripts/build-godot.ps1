
cd "~/workspace/godot"

rm -R ./bin/*

scons platform=windows target=editor

./bin/godot.windows.editor.x86_64.exe
