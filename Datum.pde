class Datum {
  int index;
  float[] data;
  String label;

  Datum(int index, float[] data, String label) {

    this.index = index;
    this.data = data;
    this.label = label;
  }

  Datum(int index, float[] data) {

    this.index = index;
    this.data = data;
  }

  Datum(int index) {
    this.index = index;
    this.data = new float[]{0, 0, 0};//x,y, and z coordinates that are later normalized between 0 and 1
  }

  public double dist(Datum other) {
    float xDist = (this.data[0] - other.data[0])* (this.data[0] - other.data[0]);
    float yDist = (this.data[1] - other.data[1]) * (this.data[1] - other.data[1]);
    float zDist = (this.data[2] - other.data[2]) * (this.data[2] - other.data[2]);
    return Math.sqrt(xDist+yDist+zDist);
  }

  public void div(int n) {
    for (int i = 0; i < this.data.length; i++) {
      this.data[i] /= n;
    }
  }
  //Unused
  public void div(Datum other) {
    for (int i = 0; i < this.data.length; i++) {
      this.data[i] /= other.index;
    }
  }

  public void add(Datum other) {
    for (int i = 0; i < this.data.length; i++) {
      this.data[i] += other.data[i];
    }
  }

  //public void wiggle() {
  //  for (int i = 0; i < this.data.length; i++) {
  //    this.data[2] += random(-0.002, 0.002);
  //  }
  //}

  public void updateZ(float z) {
    this.data[2] = z;
  }

  public void draw() {
    color c = color(map(this.index, 0, k, 0, 360), 100, 100);
    stroke(c);
    float x = map(data[0], 0, 1, 0, SIZE);
    float y = map(data[1], 0, 1, 0, SIZE);
    float z = map(data[2], 0, 1, 0, SIZE);
    point(x, y, z);
  }

  public String toString() {
    return "x: " + data[0] + "y: " + data[1] + "z: " + data[2];
  }
}
