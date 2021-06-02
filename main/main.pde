int[][] board = new int[10][20];
int cellsize = 40;

int cs = cellsize;

void setup() {
  size(1000, 1000);
  for (int r=0; r<board.length; r++) {
    for (int c=0; c<board[r].length; c++) {
      board[r][c] = (int)random(5);
    }
  }
}

void draw() {
  background(255, 255, 255);
  
  for (int r=0; r<board.length; r++) {
    for (int c=0; c<board[r].length; c++) {
      board[r][c] = (int)random(5);
    }
  }
  
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
      rect(r*cs, c*cs, cs, cs);
      
      stroke(100, 100, 100);
      rect(r*cs, c*cs, cs, cs);
    }
  }
}
