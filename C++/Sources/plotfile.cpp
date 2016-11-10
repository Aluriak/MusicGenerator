#include "../Header/plotfile.h"

void plot(double *y,int n)
{
  Dislin g;
  double pas((double)44100/n/2);
  double *x=new double[n];
  for (int i=0;i<n;i++)
  {
      x[i]=i;//*pas;
  }

  g.metafl ("cons");
  g.scrmod ("revers");
  g.disini ();
  //g.pagera ();
  g.complx ();
  g.axspos (450/2, 1800/2);
  g.axslen (2200/2, 1200/2);

  g.name   ("X-axis", "x");
  g.name   ("Y-axis", "y");

//  g.labdig (-1, "x");
//  g.ticks  (9, "x");
//  g.ticks  (10, "y");

  //g.titlin ("Demonstration of CURVE", 2);
  //g.titlin ("SIN(X), COS(X)", 3);

  //ic=g.intrgb (0.095,0.095,0.095);
  //g.axsbgd (ic);
double maximun=maxi(y,n);
if(maximun>10000000000)
    maximun=10000000000;
double minimun=mini(y,n);
if(minimun<-10000000000)
    minimun=-10000000000;
//   cout<<"min "<<minimun<<endl;

   cout<<"max "<<maximun<<endl;


g.graf   (0.0, x[n-1], x[n-1]/4, x[n-1]/2, minimun*2, maximun*1.2, minimun,(maximun-minimun)/4 );// set axis
// g.graf   (0.0, x[n-1], x[n-1]/4, x[n-1]/2, -1, 1, -1,0.5 );// set axis

  //g.setrgb (0.7, 0.7, 0.7);
  //g.grid   (1, 1);//grid on

  //g.color  ("fore");
  //g.height (50);
//  g.title  ();//affiche title
  g.color  ("red");
  g.curve  (x, y, n);
  g.disfin ();
  delete x;

}

double mini(const double *arr, int length) {
    // returns the minimum value of array
    int i;
    double minimum = arr[0];
    for (i = 1; i < length; ++i) {
        if (minimum > arr[i]) {
            minimum = arr[i];
        }
    }
    return minimum;
}
double maxi(const double *arr, int length) {
    // returns the minimum value of array
    int i;
    double maximun = arr[0];
    for (i = 1; i < length; ++i) {
        if (maximun < arr[i]) {
            maximun = arr[i];
            cout<<"max "<<i<<endl;
        }

    }

    return maximun;
}
