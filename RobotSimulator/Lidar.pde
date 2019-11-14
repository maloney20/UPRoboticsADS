class Lidar {
  Obstacle[] terrain;
  Lidar(Obstacle[] terrain) {
    this.terrain = terrain;
  }

  float getDistance(float x, float y, float angle) {
    float distance = MAX_FLOAT;
    for (Obstacle o : terrain) {
      float oDistance = o.lidarHit(x, y, angle);
      if (oDistance < distance) distance = oDistance;
    }
    return distance;
  }
}
