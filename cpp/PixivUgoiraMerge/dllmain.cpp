#include "header.h"

VideoWriter writer;
DECLDIR void init(char* firstImagePath,double fps,const char *output)
{
    Mat frame01 = imread(firstImagePath);
    writer.open(output, CV_FOURCC('m','p','4','v'), fps, frame01.size(), true);
    frame01.release();
}

DECLDIR void addImage(char* image)
{
        Mat frame = imread(image);
        writer << frame;
        frame.release();
}

DECLDIR void finish()
{
    writer.release();
}