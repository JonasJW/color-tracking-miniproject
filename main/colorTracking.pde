import processing.video.*;

Capture video;

color colorToTrackLeft;
color colorToTrackRight;
float avrgXLeft = 0;
float avrgYLeft = 0;
float avrgXRight = 0;
float avrgYRight = 0;
boolean hasFoundLeft = false;
boolean hasFoundRight = false;

float acceptedColorRange = 20;

void initialize() {
  video = new Capture(this, width, height);
  video.start();
}

void updateVideo() {
  if (!video.available()) {
    return;
  }
  
  video.read();
  video.loadPixels();
  
  //pushMatrix();
  //translate(width, 0);
  //scale(-1,1);
  image(video, 0, 0);
  //popMatrix();
  
  
  calculateAvrgLeft();
  calculateAvrgRight();
  
  fill(0);
  textSize(12);
  text("Accepted Color Range: " + acceptedColorRange, 10, 10);
  
  // updateTrackColorLeft();
}

void updateTrackColorLeft() {
  color colorAtAvrg = video.pixels[getArrayPosition((int)avrgXLeft, (int)avrgYLeft)];
  
  float r1 = red(colorAtAvrg);
  float g1 = green(colorAtAvrg);
  float b1 = blue(colorAtAvrg);
  float r2 = red(colorToTrackLeft);
  float g2 = green(colorToTrackLeft);
  float b2 = blue(colorToTrackLeft);
  float diff = distSq(r1, g1, b1, r2, g2, b2); 
  
  if (diff < acceptedColorRange * acceptedColorRange) {
    colorToTrackLeft = colorAtAvrg;
  }
}

void calculateAvrgLeft() {
  if (!hasFoundLeft) {
    return;
  }
  
  int pixelCount = 0;
  float sumX = 0;
  float sumY = 0;
  
  for (int x = 0; x < video.width / 2; x++) {
    for (int y = 0; y < video.height; y++) {
      color currentColor = video.pixels[getArrayPosition(x, y)];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(colorToTrackLeft);
      float g2 = green(colorToTrackLeft);
      float b2 = blue(colorToTrackLeft);
      float diff = distSq(r1, g1, b1, r2, g2, b2); 
      
      if (diff < acceptedColorRange * acceptedColorRange) {
         if (showFoundPixels) {
           stroke(255);
           strokeWeight(1);
           point(x, y);
         }
         sumX += x;
         sumY += y;
         pixelCount++;
      }
    }
  }
  
  if (pixelCount > 0) {
    avrgXLeft = sumX / pixelCount;
    avrgYLeft = sumY / pixelCount;
  } 
}

void calculateAvrgRight() {
  if (!hasFoundRight) {
    return;
  }
  
  int pixelCount = 0;
  float sumX = 0;
  float sumY = 0;
  color colorSum;
  
  for (int x = video.width / 2; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {
      int pos = x + y * video.width; 
      color currentColor = video.pixels[pos];
      
      
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(colorToTrackRight);
      float g2 = green(colorToTrackRight);
      float b2 = blue(colorToTrackRight);
      float diff = distSq(r1, g1, b1, r2, g2, b2); 
      
      if (diff < acceptedColorRange * acceptedColorRange) {
         if (showFoundPixels) {
           stroke(255);
           strokeWeight(1);
           point(x, y);
         } 
         sumX += x;
         sumY += y;
         pixelCount++;
      }
    }
  }
  
  if (pixelCount > 0) {
    avrgXRight = sumX / pixelCount;
    avrgYRight = sumY / pixelCount;
  }
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  return (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
}

int getArrayPosition(int x, int y) {
  return x + y * video.width;
}

void keyPressed() {
  if (key == '+') {
     acceptedColorRange += 10; 
  } else if (key == '-') {
    if (acceptedColorRange > 0) {
       acceptedColorRange -= 10; 
    }
  } else if(key == 'p'){
    if(hasFoundRight && hasFoundLeft){
      gameStarted = !gameStarted;
    }
  }
}

void mousePressed() {
  int mousePos = mouseX + mouseY*video.width;
  color mouseColor = video.pixels[mousePos];
  if (mouseX > width / 2) {
    colorToTrackRight = mouseColor;
    hasFoundRight = true;
  } else {
    colorToTrackLeft = mouseColor;
    println(colorToTrackLeft);
    hasFoundLeft = true;
  }
}
