#include "../Header/wavfile.h"

wavF::wavF()
{

}

wavF::wavF(SNDFILE  *infile, SndfileHandle file,const char * fName): m_channels(file.channels()),m_samplerate(file.samplerate()),m_wavsize(file.frames()),m_fileName(fName)
{
    static double* data= new double [BUFFER_LEN*m_channels] ;    //initialise class array
    m_wavData = new double[m_wavsize*m_channels] ;
    double* cepstrumValue;

	printf ("Opened file '%s'\n", m_fileName) ;
	printf ("Sample rate : %d\n", m_samplerate) ;
	printf ("Channels    : %d\n", m_channels) ;
	printf ("Size    : %d\n", m_wavsize) ;
	puts ("") ;

    //fill array with the wav channel
    int readcount(0);
    int counter(0);
    while ((readcount = sf_read_double (infile, data, BUFFER_LEN*m_channels)))
    {
       process_data (m_wavData,data, readcount, counter) ;//put value into the array
       counter++;//take into account number of run to place data in the array
    } ;
    sf_close (infile) ;
    delete[] data; //clear allocated buffer array

}

void process_data (double *m_wavData,double *data, int count, int counter)
{
    int k;
    int buffer(BUFFER_LEN);//buffer of the ceptrum windows

    for (k = 0; k < count ; k ++)
    {
         m_wavData[counter*count+k] = data[k] ;
    }

} /* process_data */


wavF::~wavF()
{
}
double* wavF::returnwav()
{
//    return m_wavData;//return the pointer of wav, so the direct data
    return new double (*(m_wavData));// return a copy of the data
}

double*  wavF::returnchan(int channel)
{
    int k(0), chan ;
    double* dataChan= new double[m_wavsize];// create a pointer --> delete in main ?? bad??
    for (chan = channel+1 ; chan < m_wavsize*m_channels; chan+=m_channels)// go from 0 to size*channel in wav
    {
       dataChan[k] =m_wavData[chan] ;// put wav channel in datachan
        k++;
    }
    return dataChan;//
}

int wavF::returnWavSize()
{
    return m_wavsize;
}


int initwav(SNDFILE** pointer,const char * fName)// look if file can be open
{
    SNDFILE     *infile;
    SF_INFO		sfinfo ;
        if (! (infile = sf_open (fName, SFM_READ, &sfinfo)))
    {   /* Open failed so print an error message. */
        printf ("Not able to open input file %s.\n", fName) ;
        puts (sf_strerror (NULL)) ;
        return 1;
    } ;
    *pointer=infile;
    return 0;
}




