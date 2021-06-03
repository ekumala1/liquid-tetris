import java.util.Arrays;

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
int time;

class Point implements Comparable<Point> {
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
  
  private int roundup(float f) {
    if (f > .001)
      return 1;
    else if (f < -.001)
      return -1;
    else
      return 0;
  }
  
  void rotate() {
    if (x != 0 || y != 0) {
      float angle = atan2(y, x);
      angle -= PI/2;
      x = roundup(cos(angle));
      y = roundup(sin(angle));
    }
  }
  
  void drop() {
    y--;
  }
  
  void fix() {
    board[x()][y()] = type;
  }
  
  boolean canFall() {
    return this.y() != 0 && board[this.x()][this.y()-1] == 0;
  }
  
  boolean canFlowLeft() {
    return this.y() != 0 && board[this.x()-1][this.y()-1] == 0;
  }
  
  boolean canFlowRight() {
    return this.y() != 0 && board[this.x()+1][this.y()-1] == 0;
  }
  
  boolean canLeft() {
    return this.x() != 0 && board[this.x()-1][this.y()] == 0;
  }
  
  boolean canRight() {
    return (this.x() != board.length-1) && board[this.x()+1][this.y()] == 0;
  }
  
  void draw() {
    rect(this.x()*cs, 900-this.y()*cs, cs, cs);
  }
  
  int compareTo(Point p) {
    return this.y - p.y;
  }
}

class Piece {
  Point[] blocks;
  int shape;
  boolean grounded;
  boolean fullyGrounded;
  
  Piece(int x, int y, int shape) {
    this.shape = shape;
    this.blocks = new Point[4];
    this.grounded = false;
    this.fullyGrounded = false;
    generateBlocks(x, y);
  }
  
  private void makeT(int x, int y) {
    this.blocks[0] = new Point(x, y, -1, 0, shape);
    this.blocks[1] = new Point(x, y, 1, 0, shape);
    this.blocks[2] = new Point(x, y, 0, 0, shape);
    this.blocks[3] = new Point(x, y, 0, 1, shape);
  }
  
  private void makeL1(int x, int y) {
    this.blocks[0] = new Point(x, y, -1, 1, shape);
    this.blocks[1] = new Point(x, y, 0, 1, shape);
    this.blocks[2] = new Point(x, y, 0, 0, shape);
    this.blocks[3] = new Point(x, y, 0, -1, shape);
  }
  
  private void makeL2(int x, int y) {
    this.blocks[0] = new Point(x, y, 1, 1, shape);
    this.blocks[1] = new Point(x, y, 0, 1, shape);
    this.blocks[2] = new Point(x, y, 0, 0, shape);
    this.blocks[3] = new Point(x, y, 0, -1, shape);
  }
  
  private void makeBox(int x, int y) {
    this.blocks[0] = new Point(x, y, -1, -1, shape);
    this.blocks[1] = new Point(x, y, -1, 0, shape);
    this.blocks[2] = new Point(x, y, 0, -1, shape);
    this.blocks[3] = new Point(x, y, 0, 0, shape);
  }
  
  private void generateBlocks(int x, int y) {
    switch (this.shape) {
      case 1:
        makeT(x, y);
        break;
      case 2:
        makeL1(x, y);
        break;
      case 3:
        makeL2(x, y);
        break;
      case 4:
        makeBox(x, y);
        break;
    }
  }
  
  private void goLeft() {
    for (Point p : blocks)
      if (p != null)
        p.ox--;
  }
  
  private void goRight() {
    for (Point p : blocks)
      if (p != null)
        p.ox++;
  }
  
  private void goDown() {
    for (Point p : blocks)
      if (p != null)
        p.oy--;
    
    reevaluateGrounding();
  }
  
  private void goDownIndividual() {
    for (Point p : blocks)
      if (p != null && p.canFall())
        p.drop();
  }
  
  private void goUp() {
    for (Point p : blocks)
      if (p != null)
        p.oy++;
  }
  
  private void reevaluateGrounding() {
    // sort blocks
    Arrays.sort(blocks);
    
    for (Point p : blocks)
      if (!p.canFall())
        p.fix();
  }
  
  void fall() {
    if (!grounded) {
      goDown();
      fullyGrounded = true;
      
      for (Point p : blocks) {
        if (p != null && !p.canFall())
          grounded = true;
        if (p != null && p.canFall())
          fullyGrounded = false;
      }
    } else if (!fullyGrounded) {
      goDownIndividual();
      reevaluateGrounding();
      
      boolean stuck = true;
      for (Point p : blocks)
        if (p != null && p.canFall())
          stuck = false;
      
      fullyGrounded = stuck;
    } else {
      generatePiece();
    }
  }
  
  void left() {
    boolean canLeft = true;
    
    for (Point p : blocks)
      if (p != null && !p.canLeft())
        canLeft = false;
    
    if (canLeft) goLeft();
  }
  
  void right() {
    boolean canRight = true;
    
    for (Point p : blocks)
      if (p != null && !p.canRight())
        canRight = false;
    
    if (canRight) goRight();
  }
  
  void rotate() {
    if (shape == 4) return;
    if (!grounded) {
      for (Point p : blocks) {
        if (p != null) {
          p.rotate();
          
          if (p.x() < 0)
            goRight();
          else if (p.x() >= board.length)
            goLeft();
          else if (board[p.x()][p.y()] != 0)
            goUp();
        }
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

void generatePiece() {
  currentBlock = new Piece(5, 17, (int)random(4)+1);
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
  
  generatePiece();
  time = millis();
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == DOWN)
      currentBlock.fall();
    else if (keyCode == UP)
      currentBlock.rotate();
    else if (keyCode == LEFT)
      currentBlock.left();
    else if (keyCode == RIGHT)
      currentBlock.right();
  }
}

void draw() {
  background(255, 255, 255);
  
  if (millis() - time > 500) {
    //currentBlock.fall();
    time = millis();
  }
      
  currentBlock.draw();
  
  for (int r=0; r<board.length; r++) {
    for (int c=0; c<board[r].length; c++) {
      noStroke();
      switch (board[r][c]) {
        case 0:
          noFill();
          break;
        case 1:
          fill(255,0,0);
          break;
        case 2:
          fill(0,255,0);
          break;
        case 3:
          fill(0,0,255);
          break;
        case 4:
          fill(255,0,255);
          break;
      }
      rect(r*cs, 900-c*cs, cs, cs);
    }
  }
  
  for (int r=0; r<board.length; r++) {
    for (int c=0; c<board[r].length; c++) {
      stroke(100, 100, 100);
      noFill();
      rect(r*cs, 900-c*cs, cs, cs);
    }
  }
}
