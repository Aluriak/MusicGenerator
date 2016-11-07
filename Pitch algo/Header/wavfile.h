#ifndef WAVFILE_H_INCLUDED
#define WAVFILE_H_INCLUDED

#define	BUFFER_LEN	1024
#include <sndfile.hh>
#include <iostream>
using namespace std;



class wavF
{
    public:
        wavF();
        wavF(SNDFILE  *infile, SndfileHandle file,const char * fName);
        ~wavF();
        double* returnwav();
        double * returnchan(int channel);
        int returnWavSize();



    protected:
         unsigned int m_wavsize;
         unsigned int m_channels;
         unsigned int m_samplerate;

         const char * m_fileName;
         double * m_wavData;

};



void process_data (double *wavData, double * data, int count, int channels);
int initwav(SNDFILE **infile,const char * fName);



#endif // WAVFILE_H_INCLUDED
