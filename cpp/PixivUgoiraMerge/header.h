#include <iostream>
#include <string>
#include <vector>
#include <Windows.h>
#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;
#define CV_FOURCC(a,b,c,d) VideoWriter::fourcc(a,b,c,d)
#define DLL_EXPORT

#ifndef DLL_EXPORT
#define DECLDIR __declspec(dllimport)
#else
#define DECLDIR __declspec(dllexport)
#endif

#ifdef __cplusplus
extern "C" {
#endif
    DECLDIR void init(char* firstImagePath, double fps, const char* output);
    DECLDIR void addImage(char* image);
    DECLDIR void finish();
#ifdef __cplusplus
};
#endif

wchar_t* multiByteToWideChar(const string& pKey)
{
    const char* pCStrKey = pKey.c_str();
    //第一次调用返回转换后的字符串长度，用于确认为wchar_t*开辟多大的内存空间
    int pSize = MultiByteToWideChar(CP_ACP, 0, pCStrKey, strlen(pCStrKey) + 1, NULL, 0);
    wchar_t* pWCStrKey = new wchar_t[pSize];
    //第二次调用将单字节字符串转换成双字节字符串
    MultiByteToWideChar(CP_OEMCP, 0, pCStrKey, strlen(pCStrKey) + 1, pWCStrKey, pSize);
    return pWCStrKey;
}

char* wideCharToMultiByte(wchar_t* pWCStrKey)
{
    //第一次调用确认转换后单字节字符串的长度，用于开辟空间
    int pSize = WideCharToMultiByte(CP_ACP, 0, pWCStrKey, wcslen(pWCStrKey), NULL, 0, NULL, NULL);
    char* pCStrKey = new char[pSize + 1];
    //第二次调用将双字节字符串转换成单字节字符串
    WideCharToMultiByte(CP_OEMCP, 0, pWCStrKey, wcslen(pWCStrKey), pCStrKey, pSize, NULL, NULL);
    pCStrKey[pSize] = '\0';
    return pCStrKey;

    //如果想要转换成string，直接赋值即可
    //string pKey = pCStrKey;
}
