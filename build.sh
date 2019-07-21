./bytecode-love.sh src/
cat bin/love.exe FilhosDaMae-x86_64.love > bin/FilhosDaMae.exe

cd bin/
zip -r ../FilhosDaMae.zip SDL2.dll OpenAL32.dll FilhosDaMae.exe license.txt love.dll lua51.dll mpg123.dll msvcp120.dll msvcr120.dll
