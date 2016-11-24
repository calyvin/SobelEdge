PImage myImage;
public void setup() {
  size(400, 400);
  myImage = loadImage("img1.png");
  myImage.resize(400,400);
  int imgSize = (int)sqrt(myImage.pixels.length);
  double[][] p = new double[imgSize][imgSize];
  
  for(int y = 0; y < imgSize; y++){
    for(int x = 0; x < imgSize; x++){
      color a = myImage.pixels[y*imgSize+x];
      p[y][x] = (red(a)+green(a)+blue(a))/3f;
    }
  }
  
  //double[][] data = new double[][] {
  //new double[] {1, 2, 3, 4, 5},
  //new double[] {6, 7, 8, 9, 10},
  //new double[] {11,12,13,14,15},
  //new double[] {16,17,18,19,20},
  //new double[] {21,22,23,24,25},
  //};
  
  double[][] gx = new double[][] {
   new double[] {-1,0,1},
   new double[] {-2,0,2},
   new double[] {-1,0,1},
  };
  
  double[][] gy = new double[][] {
   new double[] {1,2,1},
   new double[] {0,0,0},
   new double[] {-1,-2,-1},
  };
  
  double[][] cx = convolute(p,gx);
  double[][] cy = convolute(p,gy);
  
  double[][] c = new double[cx.length][cx[0].length];
  
  for(int y = 0; y < c.length; y++) {
   for(int x = 0; x < c[0].length-1; x++) {
     c[y][x] = sqrt(sq((float)cx[y][x])+sq((float)cy[y][x]));
   }
  }
  
  for(int y = 0; y < c.length; y++) {
   for(int x = 0; x < c[0].length-1; x++) {
         print(c[y][x]+", ");
   }
   println(c[y][c[0].length-1]);
  }
  
  for(int y = 0; y < imgSize-2; y++){
  for(int x = 0; x < imgSize-2; x++){
    int grey = constrain((int)map((float)c[y][x],0,1080,0,255),0,255);
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
  for(int y1 = 1; y1 < a.length-1; y1++){
    for(int x1 = 1; x1 < a[0].length-1; x1++){
      double sum = 0;
      for(int y = 0; y < b.length; y++) {
        for(int x = 0; x < b[0].length; x++) {
            sum+= a[y1+y-1][x1+x-1]*b[y][x];
        }
      }
      c[y1-1][x1-1] = sum;
    }
  }
  return c;
}