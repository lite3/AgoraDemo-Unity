#!/bin/sh
echo ""
echo "Compiling NativeCode.c..."
rm -rf libs
rm -rf obj
$NDK_ROOT/ndk-build -C .  $*
#$NDK_ROOT/ndk-build -C "$DIR/src" NDK_MODULE_PATH=src NDK_APPLICATION_MK=$DIR/Application.mk $*
#mv libs/armeabi/libnative.so ..

echo ""
echo "Cleaning up / removing build folders..."  #optional..


echo ""
echo "Done!"
pause
