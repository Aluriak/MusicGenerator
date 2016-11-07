#ifndef AUDIOALGO_H_INCLUDED
#define AUDIOALGO_H_INCLUDED
#include <math.h>
#include <vector>
#include <stdlib.h> //abs
//#include <tgmath.h>// round

#include <iostream>
using namespace std;

class cepVal
{
public:
    // init vector for peak peaking
    //static vector <double> peak;
    //static vector <double> posPeak;

    static bool init;
    static double winner[2];
    static double winnerMoins1[2];
    static double warp;
    static double * wceptrum;
    static double rPrim0;

};

//double* fillBuffer();
void cepstrum(double *dataCep,int N,double *cepstrumValue);
void four1(double* data, unsigned long nn);
double energyACF0(double *Input, int NumSigPts);

void peakPeaking(double *Input, int NumSigPts,vector <double> &peak,vector <double> &posPeak);
double interp3Peak(int a, int &b, int c,double &fa,double &fb,double &fc);
double primaryPeak(vector <double> &peak,vector <double> &posPeak);

void warpFactor(vector <double> &peak,vector <double> &posPeak);
double findNearestValueArray(vector <double> &grille);

void waldCepstrum(double* input,double* cepstrumValue,int N,double * waldCepstrumValue);
void warpedCepstrum(double* cepstrumValue,int N,double* warpedCepstrum);// hypothetic warpFactor





#endif // AUDIOALGO_H_INCLUDED
