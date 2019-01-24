boolean showFoundPixels = true;

void setup() {
  size(640, 480);
  frameRate(10);
  initialize();
}

void draw() {
  clear();
  updateVideo();
  
  if (hasFoundRight) {
    fill(255);
    strokeWeight(4.0);
    stroke(0);
    ellipse(avrgXRight, avrgYRight, 10, 10);
  }
  
  if (hasFoundLeft) {
    fill(255);
    strokeWeight(4.0);
    stroke(0);
    ellipse(avrgXLeft, avrgYLeft, 10, 10);
  }
}
