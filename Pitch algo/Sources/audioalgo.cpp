#include "../Header/audioalgo.h"
//#include <fftw3.h>

#include "../Header/plotfile.h"

bool cepVal::init=0;
double cepVal::winner[]={0};
double cepVal::winnerMoins1[]={1};
double cepVal::warp=1;
double cepVal::rPrim0=0;
//vector <double> cepVal::peak;
//vector <double> cepVal::posPeak;


void cepstrum(double* dataCep,int N,double * cepstrumValue)
{
    // init hann window
	double twopi(8.0*atan(1.0));            	/* calculate 2*PI*/
	double arg(twopi/N);
	double wvalue;
	double in[N*2];//init fourier array
    int i;
	for (i=0;i<N;i++)
	{
        wvalue = 0.5 - 0.5*cos(arg*i);
		in[2*i]=wvalue*dataCep[i];
		in[2*i+1]=0;
    }
    //Init fft
    four1(in, N);
    //do squared abs value, then log
    for ( i=0; i < N; i++)
    {
        cepstrumValue[i]=log(1+sqrt(pow(in[i*2],2)+pow(in[i*2+1],2)));//log(1+abs^2)
    }

    // redo fft on obtained results
    for ( i=0;i<N;i++)
	{
		in[2*i]=cepstrumValue[i];
		in[2*i+1]=0;
    }
    four1(in, N);

    //Take real part of the complex cepstrum to analyse
    double maxiVal=0;
//    maxiVal=(pow(in[0],1)+pow(in[1],1));
    maxiVal=in[0];
    for ( i = 0; i < N; i++)
    {
        cepstrumValue[i]=in[i*2]/maxiVal;// use infact only real part
    }


}

void four1(double* data, unsigned long nn)
{
    unsigned long n, mmax, m, j, istep, i;
    double wtemp, wr, wpr, wpi, wi, theta;
    double tempr, tempi;

    // reverse-binary reindexing
    n = nn<<1;
    j=1;
    for (i=1; i<n; i+=2) {
        if (j>i) {
            swap(data[j-1], data[i-1]);
            swap(data[j], data[i]);
        }
        m = nn;
        while (m>=2 && j>m) {
            j -= m;
            m >>= 1;
        }
        j += m;
    };

    // here begins the Danielson-Lanczos section
    mmax=2;
    while (n>mmax) {
        istep = mmax<<1;
        theta = -(2*M_PI/mmax);
        wtemp = sin(0.5*theta);
        wpr = -2.0*wtemp*wtemp;
        wpi = sin(theta);
        wr = 1.0;
        wi = 0.0;
        for (m=1; m < mmax; m += 2) {
            for (i=m; i <= n; i += istep) {
                j=i+mmax;
                tempr = wr*data[j-1] - wi*data[j];
                tempi = wr * data[j] + wi*data[j-1];

                data[j-1] = data[i-1] - tempr;
                data[j] = data[i] - tempi;
                data[i-1] += tempr;
                data[i] += tempi;
            }
            wtemp=wr;
            wr += wr*wpr - wi*wpi;
            wi += wi*wpr + wtemp*wpi;
        }
        mmax=istep;
    }
}



double energyACF0(double *Input, int NumSigPts)
{
    double xMin(0);
    for(int i=0;i<NumSigPts;i++)
    xMin+=pow(Input[i],2);
    return xMin;

}

void peakPeaking(double *Input, int NumSigPts,vector <double> &peak,vector <double> &posPeak)
{
    peak.clear();
    posPeak.clear();
    double maxThr=0;
    int pos;
    double posD;

    double threshold=0;//arbitrary 0 threshold
    int debut(0);
    bool test(0);

    while(Input[debut]>Input[debut+10]&& Input[debut]>threshold)//locate first treshold
    {
        debut++;
    }
    for(int i = debut;i<NumSigPts/2;i++)
    {
        if (!test)
        {
            if(Input[i]>threshold)
            {
                test=1;
                maxThr=Input[i];
                pos=i;
            }
        }
        else
        {
           if(Input[i]>maxThr)
           {
               maxThr=Input[i];
               pos=i;
           }
           else if (Input[i]<threshold)
           {
               test=0;
               posD=interp3Peak(pos-1, pos, pos+1,Input[pos-1],maxThr,Input[pos+1]);
               posPeak.push_back(posD);
               peak.push_back(maxThr);
             //  cout<< "peak "<<maxThr<<" pos "<<posD<<endl;

           }


        }
    }

}

double interp3Peak(int a, int &b, int c,double &fa,double &fb,double &fc)
{
    //use parabolic interpolation on 3 points to find the local minima
    //http://fourier.eng.hmc.edu/e176/lectures/NM/node25.html
    double xMin;
    double num=(fa-fb)*pow((c-b),2)-(fc-fb)*(pow(b-a,2));
    double den=(fa-fb)*(c-b)+(fc-fb)*(b-a);
    xMin=b+0.5*num/den;


    fb=fa*(xMin-b)*(xMin-c)/((a-b)*(a-c))+fb*(xMin-a)*(xMin-c)/((b-c)*(b-a))+fc*(xMin-a)*(xMin-b)/((c-a)*(c-b));
    return xMin;
}

double primaryPeak(vector <double> &peak,vector <double> &posPeak)
{
    int i;
    double maximun = peak[0];
    for (i = 1; i < peak.size(); ++i) {
        if (maximun < peak[i])
        {
            maximun = peak[i];
        }
    }
    double vThr=maximun*0.9;

    i=0;
    while(peak[i]<vThr)
    {
        i++;
    }
    cepVal::winner[0]=posPeak[i];
    cepVal::winner[1]= peak[i];
    cout<<"le peak est a"<< cepVal::winner[0] <<"et vaut"<<cepVal::winner[1]<<endl;

}

void warpFactor(vector <double> &peak,vector <double> &posPeak)
{
    cepVal::warp=posPeak[findNearestValueArray(peak)]/cepVal::winnerMoins1[0]*cepVal::warp;
    //cout <<"the warp factor is "<<cepVal::warp<<endl;
    //return cepVal::warp;
}

double findNearestValueArray(vector <double> &grille)
{
    int tailleArray=grille.size();
    double smallest = abs(grille[0]-cepVal::winnerMoins1[1]) ; //declare and initiate smallest value at first case 0

    int position=0;// position of the smallest value
    for ( int i=1;  i < tailleArray;  ++i )
    {
        if ( abs(grille[i]-cepVal::winnerMoins1[1])  < smallest )// if case value smaller replace it
        {
            smallest=abs(grille[i]-cepVal::winnerMoins1[1]);
            position = i;
        }
    }
    return position;
}

void waldCepstrum(double* input,double* cepstrumValue,int N,double * waldCepstrumValue)
{
    double rPrimframe=energyACF0(input, N);
    //cout<<"energy: "<<rPrimframe;
    cepVal::rPrim0+=rPrimframe;

    double wcepstrum[N];
    //warpedCepstrum(cepstrumValue, N,wcepstrum);
    for(int i;i<N;i++)
    {
        waldCepstrumValue[i]+=rPrimframe*cepstrumValue[i];
        //waldCepstrumValue[i]+=rPrimframe*wcepstrum[i];//warped cepstrum  -->prob if beginning of the note not well defined
    }
}

void warpedCepstrum(double* cepstrumValue,int N,double* warpedCepstrum)// hypothetic warpFactor
{
    // take the value of the cepstrum to do the warped cepstrum (warped value in static class)

    double linInterp;//value for ponderation
    int index;// position of the warped value --> warped i index
    warpedCepstrum[0]=cepstrumValue[0];

    if(cepVal::warp<1)// warp coefficient <1
    {
           for ( int i=1; i/cepVal::warp<N;i++)
        {
            index=i/cepVal::warp;
            linInterp=(double) i/cepVal::warp-index;
            warpedCepstrum[i]=cepstrumValue[index]*(1-linInterp)+cepstrumValue[index+1]*(linInterp);
        }

        //complete the remaining case of the array by 0
        for ( int i=(N*cepVal::warp); i<N;i++)
        {
            warpedCepstrum[i]=0;
        }

    }
    else
    {
      for ( int i=1; i<N;i++)
        {
            index=i/cepVal::warp;
            linInterp=(double) i/cepVal::warp-index;
            warpedCepstrum[i]=cepstrumValue[index]*(1-linInterp)+cepstrumValue[index+1]*(linInterp);
        }
    }

}
