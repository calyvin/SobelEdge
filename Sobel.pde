PImage myImage;
public void setup() {
  size(100, 100);
  myImage = loadImage("img1.png");
  int imgSize = (int)sqrt(myImage.pixels.length);
  double[][] p = new double[imgSize][imgSize];
  
  for(int y = 0; y < imgSize; y++){
    for(int x = 0; x < imgSize; x++){
      color a = myImage.pixels[y*imgSize+x];
      p[x][y] = (red(a)+green(a)+blue(a))/3f;
    }
  }
  
  
  //double[][] data = new double[][] {
  //  new double[] {1, 2, 3, 4, 5},
  //  new double[] {6, 7, 8, 9, 10},
  //  new double[] {11,12,13,14,15},
  //  new double[] {16,17,18,19,20},
  //  new double[] {21,22,23,24,25},
  //};
  
  double[][] gx = new double[][] {
    new double[] {-1,0,1},
    new double[] {-2,0,2},
    new double[] {-3,0,3},
  };
  
  double[][] gy = new double[][] {
    new double[] {1,2,3},
    new double[] {0,0,0},
    new double[] {-1,-2,-3},
  };
  
  double[][] c = convolute(p,gx);
  //for(int x = 0; x < c.length; x++) {
  //    for(int y = 0; y < c[0].length-1; y++) {
  //          print(c[x][y]+", ");
  //    }
  //    println(c[x][c[0].length-1]);
  //}
  
  for(int y = 0; y < imgSize; y++){
   for(int x = 0; x < imgSize; x++){
     int grey = (int)p[x][y];
     color a = color(grey);
     myImage.pixels[y*imgSize+x] = a;
   }
  }
  myImage.updatePixels();
}

public void draw() {
  image(myImage,0,0);
}

public double[][] convolute(double[][] a, double[][]b) {
  
  double[][] c = new double[a.length-2][a[0].length-2];
  for(int x1 = 1; x1 < a.length-1; x1++){
    for(int y1 = 1; y1 < a[0].length-1; y1++){
      double sum = 0;
      for(int x = 0; x < b.length; x++) {
        for(int y = 0; y < b[0].length; y++) {
            sum+= a[x1+x-1][y1+y-1]*b[x][y];
        }
      }
      c[x1-1][y1-1] = sum;
    }
  }
  return c;
}