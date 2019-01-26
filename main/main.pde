boolean showFoundPixels = false, gameStarted = false;

float x,y,leftPos,rightPos;
PShape playerRight, playerLeft, ball;
int ballWidth = 20, score, playerSpeed = 30, ballSpeedX = 20, ballSpeedY = 20, playerHeight = 100, scoreL = 0, scoreR = 0;

void setup() {
  fullScreen(1);
  //size(640,480);
 
  x = width/2;
  y = height/2;
  leftPos = y;
  rightPos = y;
  
  
  
  frameRate(10);
  initialize();
  
  playerRight = createShape(RECT, 0, 0, 20, playerHeight);
  playerRight.setFill(color(255,0,0));
  
  playerLeft = createShape(RECT, 0, 0, 20, playerHeight);
  playerLeft.setFill(color(0,255,0));
  
  
  ball = createShape(ELLIPSE, 0, 0, ballWidth, ballWidth);
  ball.setFill(color(255));
}

void draw() {
  clear();
  updateVideo();
  drawGame();
  
  if(gameStarted){
  
  
  x = x + ballSpeedX;
  y = y + ballSpeedY;
  
  calcPlayerMovement();
 
  // ball hits player right
    if (x > width - 30 - ballWidth && x < width - 10 && y >= rightPos && y <= rightPos + playerHeight) {
      ballSpeedX = ballSpeedX * -1;
    }
    // ball hits left player
    else if (x < 30 + ballWidth && x > 10 && y >= leftPos && y <= leftPos + playerHeight) {
      ballSpeedX = ballSpeedX * -1;
    }
    // ball hits bottom wall
    else if (y > height - ballWidth) {
      ballSpeedY = ballSpeedY * -1;
    }
    //ball hits top Wall
    else if (y < ballWidth){
       ballSpeedY = ballSpeedY * -1;
    }
    //left player gets a point
    else if (x > width){
      scoreL ++;
      restart();
    }
    //right player gets a point
    else if (x < 0){
      scoreR ++;
      restart();
    }
  
  
    fill(255);
    strokeWeight(4.0);
    stroke(0);
    ellipse(avrgXRight, avrgYRight, 10, 10);
  
    fill(255);
    strokeWeight(4.0);
    stroke(0);
    ellipse(avrgXLeft, avrgYLeft, 10, 10);
  
  }
  
}

void restart(){
  x = width/2;
  y = height/2;
}

void drawGame(){
  fill(0);
  noStroke();
  rect(0+250,0,width-500,height);
  fill(255);
  stroke(255);
  line(width/2,0,width/2,height);
  
  noFill();
  ellipse(width/2,height/2,300,300);
  
  fill(255);
  textSize(26); 
  text(scoreL, (width/2)-40, 20);
  text(scoreR, (width/2)+5, 20);
  
  shape(ball, x, y);
  
  shape(playerRight, width - 30, rightPos);
  shape(playerLeft, 0 + 10, leftPos);
}


void calcPlayerMovement(){
  //right
  if(avrgYRight < rightPos){
    rightPos -= playerSpeed;
  }else if(avrgYRight > rightPos + playerHeight){
    rightPos += playerSpeed;
  }
  
  //left
  //right
  if(avrgYLeft < leftPos){
    leftPos -= playerSpeed;
  }else if(avrgYLeft > leftPos + playerHeight){
    leftPos += playerSpeed;
  }
  
}
