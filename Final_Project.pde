import java.text.SimpleDateFormat;
import java.util.Date;
import java.text.DateFormatSymbols;
import java.util.concurrent.TimeUnit;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;


Table table;
PImage earth;
PShape globe;
float r = 150;
int zoom = 2;
int numberOfTrip = 0;
int finishedTrip = 0;
float angle = 0;

Boolean isPlaying = false;
float buttonWidth = 100;
float buttonHeight = 50;
float xPlayButton, yPlayButton, xStopButton, yStopButton;

ArrayList<BusSchedule> busSchedules = new ArrayList<BusSchedule>();

PFont f;

int ONE_DAY = 1000*24*60*60;
Date currentDate = new Date();
Date startDate = new Date();
Date x = new Date();
SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MM/dd/yy:HH:mm:ss");
SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yy");  
SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss"); 

PImage mapImg;
PImage spaceImg;

float mapLat = 52;
float mapLon = -110;
int mapZoom = 6;

UnfoldingMap map;

void setup() {
  spaceImg = loadImage("space.jpeg");
  fullScreen(P3D);
  earth = loadImage("earth.jpg");
  table = loadTable("truck1week.csv", "header");
  
  noStroke();
  globe = createShape(SPHERE, r);
  globe.setTexture(earth);
  
 
  String date = "03/14/16:00:00:00";
  try {
    currentDate = simpleDateFormat.parse(date);
    startDate = simpleDateFormat.parse(date);
  }
  catch (Exception e) {}
   
  f = createFont("Tahoma", 20, true);
  
  xPlayButton = width - 375;
  yPlayButton = 800;
  xStopButton = xPlayButton + 150;
  yStopButton = 800;
   
  for(TableRow row : table.rows()) {
    BusSchedule busSchedule = new BusSchedule(row.getString("date_orig"), row.getString("time_orig"), row.getFloat("Latitude_orig"), row.getFloat("Longitude_orig"), 
    row.getString("date_dest"), row.getString("time_dest"), row.getFloat("Latitude_dest"), row.getFloat("Longitude_dest"));
   
    busSchedules.add(busSchedule);
  }
  colorMode(HSB);
  
  map = new UnfoldingMap(this);
  map.zoomAndPanTo(mapZoom, new Location(mapLat, mapLon));
}

void draw() {
  background(51);
  
  map.draw();


  drawUserInteraction();
  drawEarth();
  drawMap();
  
  if (isPlaying) {  
    currentDate = addSecToDate(1, currentDate);
  }
}

Date addSecToDate(int Sec, Date beforeTime){
    final long oneSecInMillis = 1000;

    long curTimeInMs = beforeTime.getTime();
    Date afterAddingMins = new Date(curTimeInMs + (Sec * oneSecInMillis));
    return afterAddingMins;
}

void drawMap() {
  pushMatrix();
  //translate(590, height / 2);
  for (BusSchedule busSchedule: busSchedules) {
    busSchedule.displayMap();
  }
  popMatrix();
}

void drawEarth() {
  pushMatrix();
  translate(width - 250, 275);
  
  if (isPlaying) {
    rotateY(PI -0.1);
    rotateX(PI/4 + 0.2);
  } else {
    rotateY(angle);
    angle += 0.02;
  }
  
  lights();
  fill(200);
  noStroke();
  shape(globe);
  
  for (BusSchedule busSchedule: busSchedules) {
    busSchedule.shouldStart();
    if (isPlaying) { 
      busSchedule.update();
    }
    busSchedule.display();
  }
  popMatrix();
}

void drawUserInteraction() {
  rectMode(CORNERS);
  fill(200);
  strokeWeight(10);
  stroke(90);
  rect(width - 500, 0, width, height);
  rectMode(CENTER);
  noFill();
  rect(width - 250, 275, 450, 450);
  image(spaceImg, width - 475, 50, 450, 450);
  rectMode(CORNER);
  
  textFont(f);
  fill(255, 255, 0);
  pushMatrix();
  translate(width - 475, 575);
  text("Date: " + dateFormat.format(currentDate), 0, 0);
  text("Time: " + timeFormat.format(currentDate), 150, 0);
  text("Number of started trip: " + numberOfTrip, 0, 40);
  text("Number of on going trip: " + (numberOfTrip - finishedTrip), 0, 80);
  text("Number of arrived trip: " + finishedTrip, 0, 120);
  
  long hours = int((currentDate.getTime() - startDate.getTime()) / (60 * 60 * 1000));
  if (hours != 0) {
    text("Average trip per hour: " + numberOfTrip / int(hours), 0, 160);
    text("Average finished trip per hour: " + finishedTrip / int(hours), 0, 200); 
    println(hours);
  } else {
    text("Average trip per hour: " + 0, 0, 160);
    text("Average finished trip per hour: " + 0, 0, 200);    
  }

  
  popMatrix();
  
  fill(#E82F1E);
  rect(xStopButton, yStopButton, buttonWidth, buttonHeight);
  textSize(24);
  fill(0);
  text("Stop",xStopButton + 25, yStopButton + 35);
  
  fill(#1EE859);
  rect(xPlayButton, yPlayButton, buttonWidth, buttonHeight);
  textSize(24);
  fill(0);
  text("Play",xPlayButton + 25, yPlayButton + 35);
  
}

void mousePressed() {
  if (mouseX > xPlayButton && mouseX < xPlayButton +buttonWidth && mouseY > yPlayButton && mouseY < yPlayButton + buttonHeight) {
    isPlaying = true;
  } else if (mouseX > xStopButton && mouseX < xStopButton +buttonWidth && mouseY > yStopButton && mouseY < yStopButton + buttonHeight) {
    isPlaying = false;
  }
}
