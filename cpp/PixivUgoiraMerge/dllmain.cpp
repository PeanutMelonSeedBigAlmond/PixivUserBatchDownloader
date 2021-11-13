#include "header.h"

VideoWriter writer;
DECLDIR void init(char* firstImagePath,double fps,const char *output)
{
    Mat frame01 = imread(firstImagePath);
    writer.open(output, CV_FOURCC('M', 'P', '4', 'V'), fps, frame01.size(), true);
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