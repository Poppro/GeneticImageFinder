class poly {
  int x;
  int y;
  int w;
  int h;
  int r;
  int g;
  int b;
  int fitness;
  
  public poly(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    r = floor(random(255));
    g = floor(random(255));
    b = floor(random(255));
  }
  
  void render() {
    fill(r,g,b);
    rect(x,y,w,h);
  }
  
  int[] getColors() {
    int[] c = {r,g,b};
    return c;
  }
}
