class Obstacle {
  float x, y, rad;
  Obstacle(float x, float y, float rad) {
    this.x=x;
    this.y=y;
    this.rad=rad;
  }

  void show() {
    fill(255);
    ellipse(x, y, rad, rad);
  }
  

  float lidarHit(float robx, float roby, float angle) {
    float radius = rad/2;
    float nsx1 = x+radius;
    float nsy1 = y;
    float nsx2 = x-radius;
    float nsy2 = y;
    float nsx3 = x;
    float nsy3 = y+radius;
    float nsx4 = x;
    float nsy4 = y-radius;
    
    float obDist1 = intersectDistance(new PVector(robx, roby), angle, new PVector(nsx1, nsy1), new PVector(nsx2, nsy2));
    float obDist2 = intersectDistance(new PVector(robx, roby), angle, new PVector(nsx3, nsy3), new PVector(nsx4, nsy4));
    float wallDist = distToWall(robx, roby, angle);
    float[] distances = {obDist1, obDist2, wallDist};
    return min(distances);
  }
  
  float distToWall(float x, float y, float angle) {
    PVector position = new PVector(x, y);
    PVector corn1 = new PVector(0, 0);
    PVector corn2 = new PVector(width, 0);
    PVector corn3 = new PVector(width, height);
    PVector corn4 = new PVector(0, height);
    
    float dWallA = intersectDistance(position, angle, corn1, corn2);
    float dWallB = intersectDistance(position, angle, corn2, corn3);
    float dWallC = intersectDistance(position, angle, corn3, corn4);
    float dWallD = intersectDistance(position, angle, corn4, corn1);
    float[] distances = {dWallA, dWallB, dWallC, dWallD};
    return min(distances);
  }
  
  float intersectDistance(PVector position, float angle, PVector a, PVector b){
     float x1 = a.x;
     float y1 = a.y;
     float x2 = b.x;
     float y2 = b.y;
     
     float x3 = position.x;
     float y3 = position.y;
     float x4 = position.x+cos(angle);
     float y4 = position.y + sin(angle);
     
     float den = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4);
     if(den == 0){
       return MAX_FLOAT; 
     }
     float num = (x1-x3)*(y3-y4) - (y1-y3)*(x3-x4);
     float t = num/den;
     float u = -((x1-x2)*(y1-y3) - (y1-y2)*(x1-x3))/den;
     if(0 < t && t < 1 && 0 < u){
       float intX = x1 + t*(x2-x1);
       float intY = y1 + t*(y2-y1);
       return dist(position.x, position.y, intX, intY);
     }
     return MAX_FLOAT;
  }
}
