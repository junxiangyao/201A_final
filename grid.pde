void grid(float[] frequency,String[] pitch) { 
  for (int i = 0; i < 24; i++) {
    if(i==1||i==3||i==6||i==8||i==11||i==13||i==15||i==18||i==20||i==23){
    stroke(255);}
    else{stroke(255,0,0);}
    strokeWeight(1);
    line(frequency[i],0, frequency[i],height);
    textAlign(LEFT);
    fill(255);
    float pos = map(i,0,24,height,0);
    text(pitch[i],frequency[i],pos);
    px=0;
    py=height;
  }
}