import processing.video.*;
Capture video;


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

int duration = 8;


//ruler
float[] samples = new float[bsize];
float[] samplesX = new float[bsize*duration];
float[] frequency ={196.00, 207.65, 220.00, 233.08, 246.94, 261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 
  369.99, 392.00, 415.30, 440.00, 466.16, 493.88, 523.25, 554.37, 587.33, 622.25, 659.26, 698.46, 739.99};
String[] pitch = {"G(3)", "G#(3)", "A(3)", "A#(3)", "B(3)", "C(4)", "C#(4)", "D(4)", "D#(4)", 
  "E(4)", "F(4)", "F#(4)", "G(4)", "G#(4)", "A(4)", "A#(4)", "B(4)", "C(5)", "C#(5)", "D(5)", "D#(5)", 
  "E(5)", "F(5)", "F#(5)", };


//spectrum  related
float [] sx = new float[500];
float [] sy = new float[500];
color trackColor = color(255, 0, 0);
float closestX, closestY;


//computer vision related
PImage bg;
boolean start = false;



void setup() {
  size(1024, 720);
  video = new Capture(this, width, height);
  video.start();
  //for captureing the background
  bg = createImage(width, height, RGB);
  for (int i = 0; i < 500; i++) {
    sx[i] = 0;
    sy[i] = 0;
  }
  minim = new Minim(this);



  fft = new FFT(bsize, 10240);

  //background(255);
  buffer = new float[bsize];
  sound = new float[bsize];

  //initialize the array which saving values for ifft
  for ( int i = 0; i < samples.length; ++i )
  {
    samples[i] = 0;
  }

  for ( int i = 0; i < samplesX.length; ++i )
  {
    samplesX[i] = 0;
  }
  grid(frequency, pitch);
}



void captureEvent(Capture video) {
  video.read();
}




void draw() {
  //------------------------
  //Computer Vision
  //------------------------
  video.loadPixels();
  loadPixels();
  float threshold = 500;
  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {
      int loc = x + y*video.width;
      float r = red(video.pixels[loc]);
      float g = green(video.pixels[loc]);
      float b = blue(video.pixels[loc]);
      float rt = red(trackColor);
      float gt = green(trackColor);
      float bt = blue(trackColor);
      float rb = red(bg.pixels[loc]);
      float gb = green(bg.pixels[loc]);
      float bb = blue(bg.pixels[loc]);
      float d = dist(rt, bt, gt, r, g, b);
      float db = dist(r, g, b, rb, gb, bb);
      if (db>50) {
        pixels[width-1-x+y*width]=video.pixels[loc];
      } else {
        pixels[width-1-x+y*width]=color(0, 0, 0);
      } 
      if (d < threshold) {
        threshold = d;
        closestX = width-1-x;
        closestY = y;
      }
    }
  }
  updatePixels();

  //------------------------
  //Draw Spectrum
  //------------------------
  //draw spectrum and save values
  if (draw) {
    stroke(0);
    strokeWeight(5);
    mx = (int)closestX;
    my = (int)closestY;

    if (mx>width) {
      mx = width;
    }
    fft.setBand(mx/10, height-my);
    println(mx/10);
    px = mx;
    py = my;
  }


  //turn off the drawing and remove the spectrum drew before
  if (!draw) {
    noStroke();
    fill(255);
    grid(frequency, pitch);
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
  grid(frequency, pitch);


  //------------------------
  //Draw Spectrum
  //------------------------
  //I draw points rather than curves or lines in order to give more sence of index.
  if (draw) {
    stroke(0);
    strokeWeight(5);
    mx = (int)closestX;
    my = (int)closestY;
    if (mx>width) {
      mx = width;
    }
    fill(255);
    ellipse(mx, my, 10, 10);
    fft.setBand(mx/10, height-my);
    sx[499] = closestX;
    sy[499] = closestY;
    ellipse(closestX, closestY, 12.5, 12.5);
    for (int i = 0; i < 499; i++) {
      sx[i] = sx[i+1];
      sy[i] = sy[i+1];
      ellipse(sx[i], sy[i], (i*0.1)/2, (i*0.1)/2);
    }
  }
}