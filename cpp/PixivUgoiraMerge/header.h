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
    //��һ�ε��÷���ת������ַ������ȣ�����ȷ��Ϊwchar_t*���ٶ����ڴ�ռ�
    int pSize = MultiByteToWideChar(CP_ACP, 0, pCStrKey, strlen(pCStrKey) + 1, NULL, 0);
    wchar_t* pWCStrKey = new wchar_t[pSize];
    //�ڶ��ε��ý����ֽ��ַ���ת����˫�ֽ��ַ���
    MultiByteToWideChar(CP_OEMCP, 0, pCStrKey, strlen(pCStrKey) + 1, pWCStrKey, pSize);
    return pWCStrKey;
}

char* wideCharToMultiByte(wchar_t* pWCStrKey)
{
    //��һ�ε���ȷ��ת�����ֽ��ַ����ĳ��ȣ����ڿ��ٿռ�
    int pSize = WideCharToMultiByte(CP_ACP, 0, pWCStrKey, wcslen(pWCStrKey), NULL, 0, NULL, NULL);
    char* pCStrKey = new char[pSize + 1];
    //�ڶ��ε��ý�˫�ֽ��ַ���ת���ɵ��ֽ��ַ���
    WideCharToMultiByte(CP_OEMCP, 0, pWCStrKey, wcslen(pWCStrKey), pCStrKey, pSize, NULL, NULL);
    pCStrKey[pSize] = '\0';
    return pCStrKey;

    //�����Ҫת����string��ֱ�Ӹ�ֵ����
    //string pKey = pCStrKey;
}
