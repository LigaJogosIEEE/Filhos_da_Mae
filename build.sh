cd src
zip -r ../game.love ./*
cd ../
cat bin/love.exe game.love > bin/FilhosDaMae.exe

cd bin/
zip -r ../filhos_da_mae.zip SDL2.dll OpenAL32.dll FilhosDaMae.exe license.txt love.dll lua51.dll mpg123.dll msvcp120.dll msvcr120.dll
