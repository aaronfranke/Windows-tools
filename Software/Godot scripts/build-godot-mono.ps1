
cd "~/workspace/godot"

rm -R ./bin/*

scons platform=windows target=editor module_mono_enabled=yes mono_glue=no
./bin/godot.windows.editor.x86_64.mono.exe --generate-mono-glue modules/mono/glue
./modules/mono/build_scripts/build_assemblies.py --godot-output-dir ./bin
scons platform=windows target=editor module_mono_enabled=yes mono_glue=yes

./bin/godot.windows.editor.x86_64.mono.exe

