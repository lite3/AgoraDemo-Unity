#include <dlfcn.h>
#include <stddef.h>

float add(float x, float y)
{
    return x + y;
}

typedef int (*UniSDKAgoraPCM_RECEIVER)(short*, int, int, int, int);
UniSDKAgoraPCM_RECEIVER unisdkAgora_pfnPCMCallback;

int unisdkAgoraInit() {
    int result = 0;
    unisdkAgora_pfnPCMCallback = NULL;
    void* m_hDll = dlopen("libHDACEngine.so", RTLD_LAZY);
    if (m_hDll) {
        unisdkAgora_pfnPCMCallback = (UniSDKAgoraPCM_RECEIVER)dlsym(m_hDll, "_Z11pcmCallbackPsiiii");
        result = unisdkAgora_pfnPCMCallback != NULL ? 0 : 4;
    } else {
        result = 2;
    }
    
    return result;
}

void unisdkAgoraSetData(short* data, int length, int fs, int channels, int volume) {
    if (unisdkAgora_pfnPCMCallback) {
        unisdkAgora_pfnPCMCallback(data, length, fs, channels, volume);
    }
}


