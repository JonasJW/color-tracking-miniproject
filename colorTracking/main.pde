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
