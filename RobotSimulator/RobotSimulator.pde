import java.net.Socket;
import java.io.ObjectOutputStream;
import java.net.InetAddress;
import processing.net.*;

Socket sock;
Client client;
String command;

Robot robot;
Obstacle[] obstacles;
Lidar canonicalLidar;
ObjectOutputStream objStream;

void setup() {
  size(1080, 720);
  background(100);
  try {
    sock = new Socket("127.0.0.1", 9001);
    client = new Client(this, sock);
    objStream = new ObjectOutputStream(sock.getOutputStream());
  } 
  catch(IOException e) {
  }

  obstacles = new Obstacle[3];
  for (int i = 0; i < 3; i++) {
    obstacles[i] = new Obstacle(random(50, width-50), random(50, height-50), random(25, 100));
  }
  canonicalLidar = new Lidar(obstacles);
  robot = new Robot(random(50, width-50), random(50, height-50), random(2*PI), canonicalLidar);
}

void draw() {
  background(100);
  for (Obstacle o : obstacles) {
    o.show();
  }
  robot.update();
  robot.show();
  if (client.available() > 0) {
    command = client.readString();
    robot.acceptCommand(command);
  }
  try {
    objStream.writeObject(robot.points);
  } 
  catch (IOException e) {
    //println("could not sent lidar datapoints to controller");
  }
}

void keyPressed() {
  //robot.printPoints();
  switch(keyCode) {
  case UP:
    robot.acceptCommand("GO");
    break;
  case DOWN:
    robot.acceptCommand("STOP");
    break;
  case RIGHT:
    robot.acceptCommand("TURN_R");
    break;
  case LEFT:
    robot.acceptCommand("TURN_L");
    break;
  }
  switch(key) {
  case ' ':
    robot.acceptCommand("SEARCH");
    break;
  }
}
