class BusSchedule {
  float currentLatitude;
  float currentLongtitude;
  float deltaLatitude;
  float deltaLongtitude;
  
  long countDownSeccond;
  Boolean isUpdate = false;
  
  Date dateBegin = new Date();
  float latitudeBegin;
  float longtitudeBegin;
  Date dateEnd = new Date();
  
  color c;
  
  BusSchedule(String dateB, String timeB, float latB, float lonB, String dateE, String timeE, float latE, float lonE) {
    String startDate = "0" + dateB + ":" + timeB;
    String EndDate = "0" + dateE + ":" + timeE;
    try {
      dateBegin = simpleDateFormat.parse(startDate);
      dateEnd = simpleDateFormat.parse(EndDate);
    }
    catch (Exception e) {}
    
    countDownSeccond = (dateEnd.getTime() - dateBegin.getTime()) / 1000;
    deltaLatitude = (latE - latB) / countDownSeccond;
    deltaLongtitude = (lonE - lonB) / countDownSeccond;
    currentLatitude = latB;
    currentLongtitude = lonB;
    latitudeBegin = latB;
    longtitudeBegin = lonB;
    c = color(random(100,255),random(100,255), random(100,255)); 
  }
  
  void shouldStart() {
    if (dateBegin.equals(currentDate)) {
      isUpdate = true;
      numberOfTrip++;
    } else if (isUpdate && countDownSeccond <= 0) {
      isUpdate = false;
      finishedTrip++;
    }
  }
  
  void update() {
    if (isUpdate && countDownSeccond > 0) {
      currentLatitude += deltaLatitude;
      currentLongtitude += deltaLongtitude;
      countDownSeccond--;
    }
  }
  
  void display() {
    if (isUpdate && countDownSeccond > 0) {
      float theta = radians(currentLatitude);
      float phi = radians(currentLongtitude) + PI;
    
      float x = r * cos(theta) * cos(phi);
      float y = -r * sin(theta);
      float z = -r * cos(theta) * sin(phi);
    
      PVector pos = new PVector(x, y, z);
      PVector xaxis = new PVector(1, 0, 0);
      float angleb = PVector.angleBetween(xaxis, pos);
      PVector raxis = xaxis.cross(pos);
    
      pushMatrix();
      translate(x, y, z);
      rotate(angleb, raxis.x, raxis.y, raxis.z);
      fill(c);
      sphere(2);
      popMatrix();
    }
  }
  
  void displayMap() {
    if (isUpdate && countDownSeccond > 0) {
      Location origin = new Location(latitudeBegin, longtitudeBegin);
      ScreenPosition from = map.getScreenPosition(origin);
      Location end = new Location(currentLatitude, currentLongtitude);
      ScreenPosition dest = map.getScreenPosition(end);
      
      fill(c);
      arrow(int(dest.x), int(dest.y), int(from.x), int(from.y));
    }
  }
  
  void arrow(int x1, int y1, int x2, int y2) {
    strokeWeight(4);
    stroke(c);
    line(x1, y1, x2, y2);
    pushMatrix();
    translate(x2, y2);
    float a = atan2(x1-x2, y2-y1);
    rotate(a);
    line(0, 0, -2, -2);
    line(0, 0, 2, -2);
    popMatrix();
  } 
}
