void keyPressed() {
  //if (key == 's'|| key == 'S') {
  //  straight = !straight;
  //}


//capture the background
  if (key == '\n') {
    bg = video.copy();
    bg.updatePixels();
    start = true;
  }


//ifft & play sound & reset
  if (key == 'z'|| key == 'Z') {
    if (draw) {
      println("clean");
      for ( int i = 0; i < samples.length; ++i )
      {
        samples[i] = 0;
      }
      for ( int i = 0; i < samplesX.length; ++i )
      {
        samplesX[i] = 0;
      }
    }
    fft = new FFT(bsize, 10240);
    draw = !draw;
  }


  if (key == 'x'||key == 'X') {
    fft.inverse(samples);
    fft = new FFT(bsize, 10240);
    //println(samples);
    for (int j = 0; j < duration; j++) {
      for (int i = 0; i < samples.length; i++) {
        samplesX[i+j*samples.length] = samples[i]*pow(0.6, j);
      }
    }

    AudioFormat format = new AudioFormat
      ( 10240, // sample rate
      16, // sample size in bits
      1, // channels
      true, // signed
      true   // bigEndian
      );

    // finally, create the AudioSample

    wave = minim.createSample
      ( samplesX, // the samples
      format, // the format
      1024     // the output buffer size
      );

    for (int i = 0; i< 10; i++) {
      wave.trigger();
    }
    for (int i = 0; i < 500; i++) {
      sx[i] = 0;
      sy[i] = 0;
    }
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
    for (int i = 0; i < 500; i++) {
      sx[i] = 0;
      sy[i] = 0;
    }
    fft = new FFT(bsize, 10240);
    grid(frequency, pitch);
  }
}