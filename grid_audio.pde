void grid(float[] frequency,String[] pitch) { //grid
  for (int i = 0; i < 24; i++) {
    stroke(0);
    strokeWeight(1);
    line(frequency[i],0, frequency[i],height);
    textAlign(LEFT);
    fill(0);
    float pos = map(i,0,24,height,0);
    text(pitch[i],frequency[i],pos);
    px=0;
    py=height;
  }
}