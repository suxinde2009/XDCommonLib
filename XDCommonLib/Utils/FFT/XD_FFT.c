//
//  XD_FFT.c
//  XDCommonLib
//
//  Created by SuXinDe on 16/5/17.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#include "XD_FFT.h"

#include<stdio.h>            //计算给定v[NN]的NN点FFT
#include<math.h>
#define pi 3.1415
#define NN 12         //12点FFT
struct plural
{
    float real;
    float image;
};
int g[NN/2],h[NN/2];

void test()
{
    void dft(struct plural *X,int x[NN/2],int N);
    void chaikai(int v[],int l);
    struct plural chengji(struct plural a,struct plural b);
    struct plural w,m,V[NN];
    struct plural G[NN/2],H[NN/2];
    
    int v[NN]={3,9,1,0,2,1,4,3,5,2,6,7};   //给出v[NN]
    int i,N,k,t;
    
    
    for(t=0;t<NN/2;t++)
    {
        G[t].real=0; G[t].image=0;            //初始化G[K],H[K]
        H[t].real=0; H[t].image=0;
    }
    
    N=NN/2;
    chaikai(v,NN);
    dft(G,g,N);
    dft(H,h,N);
    
    
    for(k=0;k<2*N;k++)
    {
        w.real=cos(2*pi*k/(2*N));
        w.image=-sin(2*pi*k/(2*N));
        m=chengji(w,H[k%N]);
        V[k].real=G[k%N].real+m.real;
        V[k].image=G[k%N].image+m.image;
    }
    
    printf("FFT results:\n");
    for(i=0;i<2*N;i++)
        printf("%.4f+(%.4f*j)\n",V[i].real,V[i].image);   //结果输出
    printf("\n");
    
    
}

void dft(struct plural *X,int x[], int N)          //求x[n]的N-DFT
{
    int k,n;
    for(k=0;k<N;k++)
    {
        for(n=0;n<N;n++)
        {
            
            X[k].real+=x[n]*cos(2*pi*k*n/N);
            X[k].image+=-x[n]*sin(2*pi*k*n/N);
        }
        
    }
    
}

struct plural chengji(struct plural a,struct plural b)    //计算两个复数a,b的乘积返回复数c
{
    struct plural c;
    c.real=a.real*b.real-a.image*b.image;
    c.image=a.real*b.image+a.image*b.real;
    return(c);
}


void chaikai(int v[],int l)             //将v[n]拆成g[n]和k[n]
{
    int i,k=0,m=0;
    for(i=0;i<l;i++)
    {
        if(i%2==1)
            h[k++]=v[i];
        if(i%2==0)
            g[m++]=v[i];
        
    }
}
