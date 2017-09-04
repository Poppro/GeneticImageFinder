PImage g;
int row, col;
int s = 15;
PImage guess;
poly[][] gs;
float[][] fitScores;
int guessA = 50;

void setup() {
  size(600, 600);
  noStroke();
  col = width/s;
  row = height/s;
  gs = new poly[col*row][guessA];
  fitScores = new float[col*row][guessA];
  g = loadImage("grapefruit.jpg");
  g.resize(width,height);
  int dimension = g.width * g.height;
  g.loadPixels();
  g = pixelate(g);
  g.updatePixels();
  guessImg();
}

void draw() {
  background(255);
  image(g, 0, 0);
  for(int i = 0; i < gs.length; i++) {
    for(int j = 0; j < gs[i].length; j++) {
      if(gs[i][j] != null) {
        gs[i][j].render();
      }
    }
  }
  nextGen();
}

void guessImg() {
  int crow = 0;
  int ccol = -1;
  for(int i = 0; i < gs.length; i++) {
    if(ccol >= col - 1) {
      crow++;
      ccol = -1;
    }
    ccol++;
    for(int j = 0; j < guessA; j++) {
      gs[i][j] = new poly(ccol*s,crow*s, s, s);
    }
  }
  for(int j = 0; j < gs.length; j++) {
  decideFitness(gs[j], j);
  }
}

void nextGen() {
  for(int i = 0; i < gs.length; i++) {
    gs[i] = selection(gs[i], i);
    gs[i] = mutate(gs[i]);
    decideFitness(gs[i], i);
  }
}

poly[] selection(poly[] t, int index) {
  poly[] ns = new poly[guessA];
  for(int i = 0; i < ns.length; i++) {
    int si = 0;
    while(ns[i] == null) {
      if(random(765) < fitScores[index][si]) {
        ns[i] = t[si];
      }
      si++;
      if(si > guessA-1) {
        si = 0;
      }
    }
  }
  return ns;
}

void decideFitness(poly[] t, int index) {
  float maxfitness = 765;
  for(int i = 0; i < t.length; i++) {
    if(t[i] != null) {
      t[i].getColors();
      int rcol = 0;
      int gcol = 0;
      int bcol = 0;
      for(int x = t[i].x; x < t[i].x + t[i].w; x++) {
        for(int y = t[i].y; y < t[i].y + t[i].h; y++) {
          rcol += red(g.get(x,y));
          gcol += green(g.get(x,y));
          bcol += blue(g.get(x,y));
        }
      }
      if(t[i].h * t[i].w != 0) {
      rcol /= t[i].h * t[i].w;
      gcol /= t[i].h * t[i].w;
      bcol /= t[i].h * t[i].w;
      } else {
      }
      int[] colors = t[i].getColors();
      float fitness = 765.0/(abs(rcol - colors[0] + 1) + abs(gcol - colors[1]) + abs(bcol - colors[2]));
      //float fitness = 255/(abs(gcol - colors[1]) + 1);
      fitScores[index][i] = fitness;
    }
  }
}


poly[] mutate(poly[] t) {
  int r = 5;
  poly[] ns = new poly[guessA];
  for(int i = 0; i < t.length; i++) {
        ns[i] = new poly(0,0,0,0);
        ns[i].r = (int)random(-r,r) + t[i].r;
        ns[i].g = (int)random(-r,r) + t[i].g;
        ns[i].b = (int)random(-r,r) + t[i].b;
        ns[i].h = t[i].h;
        ns[i].w = t[i].w;
        ns[i].x = t[i].x;
        ns[i].y = t[i].y;
        
        if(ns[i].r < 0) {
          ns[i].r = 0;
        }
        if(ns[i].r > 255) {
          ns[i].r = 255;
        }
        if(ns[i].g < 0) {
          ns[i].g = 0;
        }
        if(ns[i].g > 255) {
          ns[i].g = 255;
        }
        if(ns[i].b < 0) {
          ns[i].b = 0;
        }
        if(ns[i].b > 255) {
          ns[i].b = 255;
        }
        if(ns[i].h < 1) {
          ns[i].h = 1;
        }
        if(ns[i].h > height) {
          ns[i].h = height;
        }
        if(ns[i].w < 1) {
          ns[i].w = 1;
        }
        if(ns[i].w > width) {
          ns[i].w = width;
        }
        
        if(ns[i].y < 0) {
          ns[i].y = 0;
        }
        if(ns[i].y > height) {
          ns[i].y = height;
        }
         if(ns[i].x < 1) {
          ns[i].x = 1;
        }
        if(ns[i].x > width) {
          ns[i].x = width;
        }
        if(ns[i].x + ns[i].w > width) {
          ns[i].w -= ns[i].x + ns[i].w - width;
        }
        if(ns[i].y + ns[i].h > height) {
          ns[i].h -= ns[i].y + ns[i].h - height;
        }
  }
    return ns;
}




PImage pixelate(PImage img) {
  PImage pixelated = img;
  img.loadPixels();
  for(int r = 0; r < row; r++) {
    for(int c = 0; c < col; c++) {
      int x = c*s;
      int y = r*s;
      int rsum = 0;
      int gsum = 0;
      int bsum = 0;
      for(int i = x; i < x+s; i++) {
        for(int j = y; j < y+s; j++) {
          rsum += red(img.get(i,j));
          gsum += green(img.get(i,j));
          bsum += blue(img.get(i,j));
        }
      }
      fill(rsum/(s*s),gsum/(s*s),bsum/(s*s));
      //rect(x,y,s,s);
      
    }
  }
  
  return pixelated;
}