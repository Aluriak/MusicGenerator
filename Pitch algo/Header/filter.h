#ifndef FILTER_H_INCLUDED
#define FILTER_H_INCLUDED

class filter

{

    public:

    filter(int numSection,double *b01,double *b11,double* b21,double* a01,double * a11,double *a21);
    ~filter();
    void RunIIRBiquadForm2(double *Input, double *Output, int NumSigPts);
    double SectCalcForm2(int k, double x);

    private:

//    static int monAttribut;
    int m_NumSections; // The number of biquad sections (cascade number)
    double *Reg0, *Reg1, *Reg2;  // Used in the Form 2 code
    double *a2, *a1, *a0, *b2, *b1, *b0; // The 2nd order IIR coefficients.



};
void mediumOuterFilt(double *Input, double *Output, int NumSigPts);

#endif // FILTER_H_INCLUDED
