class Robot {
  float x, y, angle;
  HashMap<Float, Float> points;
  Lidar myLidar;
  boolean stopped = true;

  float xVel = 0, yVel = 0, angleVel=0;

  Robot(float x, float y, float angle, Lidar myLidar) {
    this.x=x;
    this.y=y;
    this.angle=angle;
    this.myLidar = myLidar;
    points = new HashMap<Float, Float>();
  }

  void printPoints() {
    println("angle     distance");
    for (float ang : points.keySet()) {
      println(ang + "     " + points.get(ang));
    }
  }

  void gatherPoints() {
    points.clear();
    for (float i = angle+HALF_PI; i < HALF_PI+TWO_PI+angle; i+= TWO_PI/200) {
      float distance = myLidar.getDistance(x+(100*cos(angle)), y+(100*sin(angle)), i);
      if (distance > 0) {
        points.put(i, distance);
      }
    }
  }

  void update() {
    gatherPoints();
    x+=xVel;
    y+=yVel;
    angle+=angleVel;
  }

  void show() {
    fill(0);
    noStroke();
    rectMode(CENTER);
    ellipseMode(CENTER);
    pushMatrix();
    translate(x, y);
    rotate(angle);
    rect(0, 0, 200, 100);
    fill(255);
    ellipse(100, 0, 5, 5);
    fill(0, 255, 0);
    popMatrix();
    drawLidarLines();
    drawLidarPoints();
  }

  void drawLidarLines() {
    pushMatrix();
    translate(x+100*cos(angle), y+100*sin(angle));
    stroke(0, 255, 0);
    for (float x : points.keySet()) {
      line(0, 0, cos(x)*points.get(x), sin(x)*points.get(x));
    }
    popMatrix();
  }

  void drawLidarPoints() {
    pushMatrix();
    translate(x+cos(angle)*100, y+100*sin(angle));
    stroke(0, 255, 0);
    for (float x : points.keySet()) {
      ellipse(cos(x)*points.get(x), sin(x)*points.get(x), 5, 5);
    }
    popMatrix();
  }

  void acceptCommand(String command) {
    switch(command) {
    case "GO":
      if (stopped) {
        yVel=sin(angle);
        xVel=cos(angle);
        stopped=false;
        println("(xVel,yVel)"+xVel+", "+yVel);
      }
      break;
    case "STOP":
      xVel = 0;
      yVel=0;
      angleVel=0;
      stopped = true;
      println("stopped");
      break;
    case "TURN_R":
      if (stopped) {
        stopped = false;
        angleVel = 0.01;
      }
      break;
    case "TURN_L":
      if (stopped) {
        stopped = false;
        angleVel = -0.01;
      }
      break;
    case "SEARCH":
      gatherPoints();
      drawLidarPoints();
      break;
    case "QUIT":
      exit();
    }
  }
}
