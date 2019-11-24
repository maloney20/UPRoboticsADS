import java.net.Socket;
import java.io.PrintWriter;
import java.net.InetAddress;
import processing.net.*;

Socket sock;
Client client = new Client(this, "127.0.0.1", 12345);
String command;

Robot robot;
Obstacle[] obstacles;
Lidar canonicalLidar;
PrintWriter out;

void setup() {
  size(1080, 720);
  background(100);
  try {
    sock = new Socket("127.0.0.1", 9001);
    client = new Client(this, sock);
    out = new PrintWriter(sock.getOutputStream());
  } 
  catch(IOException e) {
  }

  obstacles = new Obstacle[3];
  for (int i = 0; i < 3; i++) {
    obstacles[i] = new Obstacle(random(50, width-50), random(50, height-50), random(25, 100));
  }
  canonicalLidar = new Lidar(obstacles);
  robot = new Robot(200, random(50, height-50), random(2*PI), canonicalLidar);
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
    String[] commands = command.split("&");
    for(int i = 0; i < commands.length; i++){
      println(commands[i]);
      robot.acceptCommand(commands[i]); 
    }
  }
  try {
    sendLidarData();
  } 
  catch (Exception e) {
    //println("could not sent lidar datapoints to controller");
  }
}

void sendLidarData() throws IOException {
  String jsonBuilder = "{\n";
  for(Float ang : robot.points.keySet()){
    String entry = "\t \"" + ang + "\" : " + robot.points.get(ang)+",\n";
    //println(entry);
        jsonBuilder += entry;
      }
      String jsonString = jsonBuilder.substring(0, jsonBuilder.length()-2)+"\n}";
      //println("sending "+jsonString);
      out.print(jsonString);
      out.flush(); 
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
