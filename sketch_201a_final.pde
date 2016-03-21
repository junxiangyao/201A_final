import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.*;
import javax.sound.sampled.*;

Minim minim;
AudioSample wave;

FFT fft;
Oscil   sine;
float[] buffer;
float[] sound;
int bsize = 1024;
int mx=0, my=height;
int px=0, py=height;
boolean draw=false;
boolean straight = false;

int duration = 4;

float[] samples = new float[bsize];
float[] samplesX = new float[bsize*duration];
float[] frequency ={196.00,207.65,220.00,233.08,246.94,261.63,277.18,293.66,311.13,329.63,349.23,
369.99,392.00,415.30,440.00,466.16,493.88,523.25,554.37,587.33,622.25,659.26,698.46,739.99};
String[] pitch = {"G(3)","G#(3)","A(3)","A#(3)","B(3)","C(4)","C#(4)","D(4)","D#(4)",
"E(4)","F(4)","F#(4)","G(4)","G#(4)","A(4)","A#(4)","B(4)","C(5)","C#(5)","D(5)","D#(5)",
"E(5)","F(5)","F#(5)",};

void setup() {
  size(1000, 720);
  minim = new Minim(this);
  
  

  //println(frequency);
  

  fft = new FFT(bsize, 10240);

  background(255);
  buffer = new float[bsize];
  sound = new float[bsize];
  
 
  for ( int i = 0; i < samples.length; ++i )
  {
    samples[i] = 0;
  }

  for ( int i = 0; i < samplesX.length; ++i )
  {
    samplesX[i] = 0;
  }
  
  grid(frequency,pitch);
}

void draw() {
  //background(255);
   
  
  
  if (draw) {
    stroke(0);
    strokeWeight(5);
    if (!straight) {
      mx = mouseX;
    }
    my = mouseY;
    if (mx>width) {
      mx = width;
    }
    if (mx>=px) {
      line(mx, my, px, py);
      fft.setBand(mx/10, height-my);
      println(mx/10);
      px = mx;
      py = my;
    } else {
      mx = px;
    }
  }


  if (!draw) {
    noStroke();
    fill(255);
    rect(0, 0, width, height);
    grid(frequency,pitch);
    px=0;
    py=height;
    for ( int i = 0; i < samples.length; ++i )
    {
      samples[i] = 0;
    }

    for ( int i = 0; i < samplesX.length; ++i )
    {
      samplesX[i] = 0;
    }
  }
}