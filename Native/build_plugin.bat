@echo off

echo Cleaning up / removing build folders...
rmdir /S /Q libs
rmdir /S /Q obj
echo Compiling NativeCode.c...
call "%NDK_ROOT%/ndk-build" -C .  %*
rem $NDK_ROOT/ndk-build -C "$DIR/src" NDK_MODULE_PATH=src NDK_APPLICATION_MK=$DIR/Application.mk $*
rem mv libs/armeabi/libnative.so ..

echo Copy .so to Unity folder
xcopy /Y  "libs\armeabi-v7a\libnative.so" "..\Assets\Plugins\Android\Agora\libs\armeabi-v7a\libnative.so"

echo Done!
pause
