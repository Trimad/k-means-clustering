import peasy.PeasyCam;

PeasyCam cam;
final int SIZE = 1200;
ArrayList<Datum>  points = new ArrayList<Datum>();
ArrayList<Datum> centroids = new ArrayList<Datum>();
Network network = new Network();
int k=5;

void settings() {

  size(SIZE, SIZE, P3D);
  //fullScreen(P3D);
  noSmooth();
}

void setup() {
  colorMode(HSB, 360, 100, 100);
  //http://mrfeinberg.com/peasycam/reference/index.html
  cam = new PeasyCam(this, SIZE>>1, SIZE>>1, SIZE>>1, SIZE<<1);

  //Initialize the centroids
  for (int i = 0; i < k; i++) {
    centroids.add(new Datum(i, new float[] {random(0, 1), random(0, 1), random(0, 1)}));
  }
}

void connect() {
  try {
    network.Get("http://localhost:3000/alltickers/debug");
  }
  catch(IOException e) {
    System.err.println(e);
  }
  catch(InterruptedException ie) {
    System.err.println(ie);
  }
  //network.InitPoints();
}

float zoff=0;
void initPerlin() {
  points = new ArrayList<Datum>();
  float inc = 0.01;
  float xoff = 0;   // Increment xoff
  for (int x = 0; x < SIZE; x+=8) {
    float yoff = 0.0;   // For every xoff, start yoff at 0
    for (int y = 0; y < SIZE; y+=8) {
      yoff += inc; // Increment yoff
      float[] data = {map(x, 0, SIZE, 0, 1), map(y, 0, SIZE, 0, 1), noise(xoff, yoff, zoff)};
      points.add(new Datum(-1, data));
      yoff+=inc;
    }
    xoff+=inc;
  }
  zoff+=inc;
}

void draw() {

  //println(centroids.get(0).toString());
  //translate(width/2, height/2, size>>1);
  //rotateZ(frameCount*0.003);
  //rotateY(frameCount*0.004);
  //translate(-width/2, -height/2, -size>>1);
  background(0);
  strokeWeight(2);
  //Draw the points
  for (Datum d : points) {
    d.draw();
    d.wiggle();
  }
  strokeWeight(10);
  //Draw the centroid targets
  for (Datum d : centroids) {
    d.draw();
  }
  initPerlin();
  kmeans();
  guideLines();
}


void kmeans () {
  /* Associate each point with its closest centroid */
  points.forEach(p -> {
    double min_distance = Double.MAX_VALUE;
    int min_distance_index = 0;
    for (int i = 0; i < centroids.size(); i++) {
      double distance = p.dist(centroids.get(i));

      if (distance < min_distance) {
        min_distance = distance;
        min_distance_index = i;
      }
    }
    p.index = min_distance_index;
  }
  );
  /* Update the centroids' positions */
  for (int i = 0; i < centroids.size(); i++) {
    Datum new_coords = new Datum(i);
    int n = 0;
    for (int j = 0; j < points.size(); j++) {
      if (centroids.get(i).index == points.get(j).index) {
        new_coords.add(points.get(j));//vector addition
        ++n;
      }
    }
    if (n==0)break;
    new_coords.div(n);//vector division
    centroids.set(i, new_coords);
  }
}

boolean state = true;
void keyPressed() {
  state = !state;
}

void guideLines() {
  if (state) {
    strokeWeight(1);
    //x-axis, green positive
    stroke(#FF0000);
    line(0, 0, 0, SIZE, 0, 0);
    //x-axis, green negative
    stroke(#7F0000);
    line(0, 0, 0, -SIZE, 0, 0);

    //y-axis, blue positive
    stroke(#00FF00);
    line(0, 0, 0, 0, SIZE, 0);
    //y-axis, blue negative
    stroke(#007F00);
    line(0, 0, 0, 0, -SIZE, 0);

    //z-axis, red positive
    stroke(#0000FF);
    line(0, 0, 0, 0, 0, SIZE);
    //z-axis, red negative
    stroke(#00007F);
    line(0, 0, 0, 0, 0, -SIZE);

    //The box
    stroke(#FFFF00);
    line(0, SIZE, 0, SIZE, SIZE, 0);

    stroke(#FFFF00);
    line(SIZE, SIZE, 0, SIZE, 0, 0);

    stroke(#FF00FF);
    line(SIZE, 0, SIZE, SIZE, 0, 0);

    stroke(#FF00FF);
    line(0, 0, SIZE, SIZE, 0, SIZE);

    stroke(#00FFFF);
    line(0, 0, SIZE, 0, SIZE, SIZE);

    stroke(#00FFFF);
    line(0, SIZE, 0, 0, SIZE, SIZE);

    stroke(#FFFFFF);
    line(0, SIZE, SIZE, SIZE, SIZE, SIZE);

    stroke(#FFFFFF);
    line(SIZE, 0, SIZE, SIZE, SIZE, SIZE);

    stroke(#FFFFFF);
    line(SIZE, SIZE, 0, SIZE, SIZE, SIZE);
  }
}
