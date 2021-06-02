//-----------------------------------------------
//GAME VARIABLES
//-----------------------------------------------
int[][] board = new int[10][20];
int cellsize = 40;
color type1 = color(75, 0, 0);
color type2 = color(0, 75, 0);
color type3 = color(0, 0, 75);
color type4 = color(75, 0, 75);
//-----------------------------------------------

int cs = cellsize;
Piece currentBlock;

class Point {
  int ox, oy;
  private int x, y;
  int type;
  
  Point(int ox, int oy, int x, int y, int type) {
    this.ox = ox;
    this.oy = oy;
    this.x = x;
    this.y = y;
    this.type = type;
  }
  
  int x() {
    return ox + x;
  }
  
  int y() {
    return oy + y;
  }
  
  void swap(boolean flip) {
    int t = x;
    x = y;
    y = t;
    
    if (flip) {
      x = -x;
      y = -y;
    }
  }
  
  boolean canFall() {
    return this.y() != 0 && board[this.x()][this.y()-1] == 0;
  }
  
  void draw() {
    rect(this.x()*cs, 900-this.y()*cs, cs, cs);
  }
}

class Piece {
  int x, y;
  Point[] blocks;
  int shape;
  boolean flip;
  
  Piece(int x, int y, int shape) {
    this.x = x;
    this.y = y;
    this.shape = shape;
    this.blocks = new Point[5];
    this.flip = false;
    generateBlocks();
  }
  
  private void makeT() {
    this.blocks[0] = new Point(this.x, this.y, -1, 0, 1);
    this.blocks[1] = new Point(this.x, this.y, 1, 0, 1);
    this.blocks[2] = new Point(this.x, this.y, 0, 0, 1);
    this.blocks[3] = new Point(this.x, this.y, 0, 1, 1);
  }
  
  private void makeL1() {
    this.blocks[0] = new Point(this.x, this.y, -1, 1, 1);
    this.blocks[1] = new Point(this.x, this.y, 0, 1, 1);
    this.blocks[2] = new Point(this.x, this.y, 0, 0, 1);
    this.blocks[3] = new Point(this.x, this.y, 0, -1, 1);
  }
  
  private void makeL2() {
    this.blocks[0] = new Point(this.x, this.y, 1, 1, 1);
    this.blocks[1] = new Point(this.x, this.y, 0, 1, 1);
    this.blocks[2] = new Point(this.x, this.y, 0, 0, 1);
    this.blocks[3] = new Point(this.x, this.y, 0, -1, 1);
  }
  
  private void makeBox() {
    this.blocks[0] = new Point(this.x, this.y, -1, 1, 1);
    this.blocks[1] = new Point(this.x, this.y, 1, 1, 1);
    this.blocks[2] = new Point(this.x, this.y, -1, -1, 1);
    this.blocks[3] = new Point(this.x, this.y, 1, -1, 1);
  }
  
  private void generateBlocks() {
    switch (this.shape) {
      case 1:
        makeT();
        break;
      case 2:
        makeL1();
        break;
      case 3:
        makeL2();
        break;
      case 4:
        makeBox();
        break;
    }
  }
    
  private void makeStatic() {
    for (Point p : blocks)
      if (p != null)
        board[p.x()][p.y()] = p.type;
  }
  
  void fall() {
    boolean willStatic = false;
    
    for (Point p : blocks) {
      if (p != null && !p.canFall())
        willStatic = true;
    }
    
    if (willStatic) {
      makeStatic();
      currentBlock = new Piece(3, 15, 2);
    } else {
      for (Point p : blocks) {
        if (p != null) {
          p.oy--;
        }
      }
    }
  }
  
  void rotate() {
    flip = !flip;
    for (Point p : this.blocks) {
      if (p != null) {
        p.swap(flip);
      }
    }
  }
  
  void draw() {
    switch (shape) {
      case 0:
        fill(255, 255, 255);
        break;
      case 1:
        fill(type1);
        break;
      case 2:
        fill(type2);
        break;
      case 3:
        fill(type3);
        break;
      case 4:
        fill(type4);
        break;
    }
    for (Point block : blocks) {
      if (block != null)
        block.draw();
    }
  }
}

void setup() {
  size(1000, 1000);
  //for (int r=0; r<board.length; r++) {
  //  for (int c=0; c<board[r].length; c++) {
  //    board[r][c] = (int)random(5);
  //  }
  //}
  
  for (int c=0; c<board.length; c++) {
    board[c][0] = 1;
  }
  
  currentBlock = new Piece(3, 15, 2);
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == DOWN)
      currentBlock.fall();
    else if (keyCode == UP)
      currentBlock.rotate();
  }
}

void draw() {
  background(255, 255, 255);
  
  for (int r=0; r<board.length; r++) {
    for (int c=0; c<board[r].length; c++) {
      noStroke();
      switch (board[r][c]) {
        case 0:
          fill(255, 255, 255);
          break;
        case 1:
          fill(type1);
          break;
        case 2:
          fill(type2);
          break;
        case 3:
          fill(type3);
          break;
        case 4:
          fill(type4);
          break;
      }
      rect(r*cs, 900-c*cs, cs, cs);
    }
  }
      
  currentBlock.draw();
  
  for (int r=0; r<board.length; r++) {
    for (int c=0; c<board[r].length; c++) {
      stroke(100, 100, 100);
      noFill();
      rect(r*cs, 900-c*cs, cs, cs);
    }
  }
}
