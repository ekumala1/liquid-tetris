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
  int x, y;
  int type;
  
  Point(int ox, int oy, int x, int y, int type) {
    this.ox = ox;
    this.oy = oy;
    this.x = x;
    this.y = y;
    this.type = type;
  }
  
  boolean canFall() {
    return board[this.x][this.y-1] == 0;
  }
  
  void draw() {
    int x = this.ox + this.x;
    int y = this.oy + this.y;
    rect(x*cs, 900-y*cs, cs, cs);
  }
}

class Piece {
  int x, y;
  Point[] blocks;
  int shape;
  
  Piece(int x, int y, int shape) {
    this.x = x;
    this.y = y;
    this.shape = shape;
    this.blocks = new Point[5];
    generateBlocks();
  }
  
  private void makeT() {
    this.blocks[0] = new Point(this.x, this.y, -1, 0, 1);
    this.blocks[1] = new Point(this.x, this.y, 1, 0, 1);
    this.blocks[2] = new Point(this.x, this.y, 0, 0, 1);
    this.blocks[3] = new Point(this.x, this.y, 0, 1, 1);
  }
  
  private void generateBlocks() {
    switch (this.shape) {
      case 1:
        makeT();
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
  
  currentBlock = new Piece(3, 15, 1);
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
