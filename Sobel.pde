PImage myImage;
public void setup() {
  size(400, 400);
  
  //Load 1D image array and resize to a square
  myImage = loadImage("img1.png");
  myImage.resize(400,400);
  
  //Convert colored 1D array into greyscale 2D array
  int imgSize = (int)sqrt(myImage.pixels.length);
  double[][] p = new double[imgSize][imgSize];
  for(int y = 0; y < imgSize; y++){
    for(int x = 0; x < imgSize; x++){
      color a = myImage.pixels[y*imgSize+x];
      p[y][x] = (red(a)+green(a)+blue(a))/3f;
    }
  }
  
  //Initialize horizontal edge detection kernel
  double[][] gx = new double[][] {
   new double[] {-1,0,1},
   new double[] {-2,0,2},
   new double[] {-1,0,1},
  };
  
  //Initialize vertical edge detection kernel
  double[][] gy = new double[][] {
   new double[] {1,2,1},
   new double[] {0,0,0},
   new double[] {-1,-2,-1},
  };
  
  //Get horizontal and vertical convolutions
  double[][] cx = convolute(p,gx);
  double[][] cy = convolute(p,gy);
  
  //Combine horizontal and vertical gradients to get overall gradient magnitude
  double[][] c = new double[cx.length][cx[0].length];
  for(int y = 0; y < c.length; y++) {
   for(int x = 0; x < c[0].length-1; x++) {
     c[y][x] = sqrt(sq((float)cx[y][x])+sq((float)cy[y][x]));
   }
  }
  
  //Convert edge detection into 1D greyscale pixel array
  for(int y = 0; y < imgSize-2; y++){
    for(int x = 0; x < imgSize-2; x++){
      int grey = constrain((int)map((float)c[y][x],0,1080,0,255),0,255);
      color a = color(grey);
      myImage.pixels[y*imgSize+x] = a;
    }
  }
  
  //Update pixel array of image to edge detection array
  myImage.updatePixels();
}

public void draw() {
  //Draw edge detected image
  image(myImage,0,0);
}

//Convolute image 'a' with kernel 'b'
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
