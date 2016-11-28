#include "../Header/filter.h"
// Form 2 Biquad
// This uses one set of shift registers, Reg0, Reg1, and Reg2 in the center.
filter::filter(int numSection,double *b01,double *b11,double* b21,double* a01,double * a11,double *a21):m_NumSections(numSection)
{
     //declare registers array
     Reg0 = new double [m_NumSections];
     Reg1 = new double [m_NumSections];
     Reg2 = new double [m_NumSections];

     //declare coeff array
     a2 = a21;
     a1 = a11;
     a0 = a01;
     b2 = b21;
     b1 = b11;
     b0 = b01;
}

filter::~filter()
{
    delete Reg0,Reg1,Reg2;
}

void filter::RunIIRBiquadForm2(double *Input, double *Output, int NumSigPts)
{
 double y;
 int j, k;

 for(j=0; j<m_NumSections; j++) // Init the shift registers.
  {
   Reg0[j] = 0.0;
   Reg1[j] = 0.0;
   Reg2[j] = 0.0;
  }

 for(j=0;j<NumSigPts;j++)
  {
   y = SectCalcForm2(0, Input[j]);
   for(k=1; k<m_NumSections; k++)
	{
	 y = SectCalcForm2(k, y);
	}
   Output[j] = y;
  }
}
////---------------------------------------------------------------------------
//
//// Form 2 Biquad Section Calc, called by RunIIRBiquadForm2.
double filter::SectCalcForm2(int k, double x)
{
 double y;

 Reg0[k] = x - a1[k] * Reg1[k] - a2[k] * Reg2[k];
 y = b0[k] * Reg0[k] + b1[k] * Reg1[k] + b2[k] * Reg2[k];

 // Shift the register values
 Reg2[k] = Reg1[k];
 Reg1[k] = Reg0[k];

 return(y);
}

void mediumOuterFilt(double *Input, double *Output, int NumSigPts)
{
    int sec(6);
     double a2[6] ={-0.0195462971369373,0.663402651472753,0.682524987736390,0.737429763154690,0.780918898125465,0.970228475663498};
     double a1[6] ={0.432809112106398,-0.867861362412634,-1.28795220451305,-1.49391356343356,-0.213906426927402,-1.96977855582618};
     double a0[6] ={1,1,1,1,1,1};
     double b2[6] ={0.0664636655671711,0.793403355819594,0.244719159456572,0.810551096680544,0.775527334155995,0.985001757872419};
     double b1[6] ={0.211371859845122,-0.798315099301569,-0.802056527152077,-1.60370365104235,-0.214064241097551,-1.97000351574484};
     double b0[6] ={0.149608005653224,1,1,1,1,0.985001757872419};
     filter mOF(sec,b0,b1,b2,a0,a1,a2);
    mOF.RunIIRBiquadForm2(Input, Output, NumSigPts);
}
