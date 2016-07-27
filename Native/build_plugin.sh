#!/bin/sh
echo ""
echo "Cleaning up / removing build folders..."  #optional..
rm -rf libs
rm -rf obj
echo "Compiling NativeCode.c..."
$NDK_ROOT/ndk-build -C .  $*
#$NDK_ROOT/ndk-build -C "$DIR/src" NDK_MODULE_PATH=src NDK_APPLICATION_MK=$DIR/Application.mk $*
#mv libs/armeabi/libnative.so ..

echo ""

echo "Copy .so to Unity folder"
cp -rf libs/* ../Assets/Plugins/Android/Agora/libs/

echo ""
echo "Done!"
