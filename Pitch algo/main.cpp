#include	<sndfile.h>
#include	<stdio.h>
#include <iostream>

#include "Header/wavfile.h"
#include "Header/audioalgo.h"
#include "Header/plotfile.h"
#include "Header/filter.h"

int main(void)
{


//________Open the wav file and Extract informations__________
    SNDFILE     *infile ;//pointer toward file
    SNDFILE **pointer=&infile ;
    const char	*infilename = "audio/Piano_mf_Gb2.wav" ;//name of the wav file

	SndfileHandle file;//class object to open wav
	file=SndfileHandle(infilename);//fill file object

	if(initwav(pointer,infilename)) return 0 ;// if unable to open file close all
    wavF wav1(infile,file, infilename);// get data into wav1

//_________________audio algoritm part________________________
    double* data(wav1.returnchan(1));// take a copy of the wav file in wav1 of channel 1
    int wavSize(wav1.returnWavSize());// size of the wav
    int bufferSize(1024*2);// buffer init
    int loop = wavSize/bufferSize;//number of full buffer loop
    int rest = wavSize-loop*bufferSize;// remaining of plain loop --> end of the wavfile < bufferSize

    double buffer [bufferSize];
    double bufferCep[bufferSize];//buffer for cepstrum value
    double waldCepstr[bufferSize]={NULL};//buffer for cepstrum value


// init vector for peak peaking
    vector <double> peak;
    vector <double> posPeak;


    for (int i=0;i<loop;i++)
    {
        for(int k=0;k<bufferSize;k++)
        {
            buffer[k]=data[i*bufferSize+k];

        }
        mediumOuterFilt(buffer, buffer, bufferSize);
        cepstrum(buffer,bufferSize,bufferCep);
        peakPeaking(bufferCep, bufferSize,peak,posPeak);
        primaryPeak(peak,posPeak);

        if(i!=0)
        {
            warpFactor(peak,posPeak);
            waldCepstrum(buffer,bufferCep,bufferSize, waldCepstr);

        }
        else
        {
            waldCepstrum(buffer,bufferCep,bufferSize, waldCepstr);
        }
        cepVal::winnerMoins1[0]=cepVal::winner[0];
        cepVal::winnerMoins1[1]=cepVal::winner[1];
        //plot(waldCepstr,bufferSize/2);


    }

    for (int i=0;i<bufferSize;i++)
    {
        waldCepstr[i]=waldCepstr[i]/cepVal::rPrim0;
    }
    peakPeaking(waldCepstr, bufferSize,peak,posPeak);
    primaryPeak(peak,posPeak);
    plot(waldCepstr,bufferSize/2);


    delete data;// is that bad ?






    return 0 ;
} /* main */




