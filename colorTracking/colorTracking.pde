
import processing.video.*;

Capture video;

color colorToTrackLeft;
color colorToTrackRight;
float avrgXLeft = 0;
float avrgYLeft = 0;
float avrgXRight = 0;
float avrgYRight = 0;

float acceptedColorRange = 20;

void setup() {
  size(640, 480);

  video = new Capture(this, width, height);
  video.start();
  
  frameRate(10);
}

void draw() {
  if (!video.available()) {
    return;
  }
  
  clear();
  video.read(); // Read the new frame from the camera
  video.loadPixels();
  
  image(video, 0, 0);
  calculateAvrgLeft();
  calculateAvrgRight();
}

void calculateAvrgLeft() {
  int pixelCount = 0;
  float sumX = 0;
  float sumY = 0;
  
  for (int x = 0; x < video.width / 2; x++) {
    for (int y = 0; y < video.height; y++) {
      int pos = x + y * video.width; 
      color currentColor = video.pixels[pos];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(colorToTrackLeft);
      float g2 = green(colorToTrackLeft);
      float b2 = blue(colorToTrackLeft);
      float diff = distSq(r1, g1, b1, r2, g2, b2); 
      
      if (diff < acceptedColorRange * acceptedColorRange) {
         stroke(255);
         strokeWeight(1);
         point(x, y);
         sumX += x;
         sumY += y;
         pixelCount++;
      }
    }
  }
  
  if (pixelCount > 0) {
    
    avrgXLeft = sumX / pixelCount;
    avrgYLeft = sumY / pixelCount;
    fill(255);
    strokeWeight(4.0);
    stroke(0);
    ellipse(avrgXLeft, avrgYLeft, 10, 10);
  }
}

void calculateAvrgRight() {
  int pixelCount = 0;
  float sumX = 0;
  float sumY = 0;
  
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
         stroke(255);
         strokeWeight(1);
         point(x, y);
         sumX += x;
         sumY += y;
         pixelCount++;
      }
    }
  }
  
  if (pixelCount > 0) {
    
    avrgXRight = sumX / pixelCount;
    avrgYRight = sumY / pixelCount;
    fill(255);
    strokeWeight(4.0);
    stroke(0);
    ellipse(avrgXRight, avrgYRight, 10, 10);
  }
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  return (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
}

void mousePressed() {
  int mousePos = mouseX + mouseY*video.width;
  color mouseColor = video.pixels[mousePos];
  if (mouseX > width / 2) {
    colorToTrackRight = mouseColor;
  } else {
    colorToTrackLeft = mouseColor;
    print(colorToTrackLeft);
  }
}
