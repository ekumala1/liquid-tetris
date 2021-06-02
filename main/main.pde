int[][] board = new int[10][20];
int cellsize = 40;

int cs = cellsize;
Point[] currentBlock = new Point[5];

class Point {
  int x, y;
  int type;
  
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  boolean canFall() {
    return board[this.x][this.y-1] == 0;
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
          fill(50, 0, 0);
          break;
        case 2:
          fill(0, 50, 0);
          break;
        case 3:
          fill(0, 0, 50);
          break;
        case 4:
          fill(50, 0, 50);
          break;
      }
      rect(r*cs, 900-c*cs, cs, cs);
      
      stroke(100, 100, 100);
      rect(r*cs, 900-c*cs, cs, cs);
    }
  }
}
