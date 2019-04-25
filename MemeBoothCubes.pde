/** //<>//
 Based on: https://github.com/hamoid/P5PostProcessing 
 Move your mouse in X to change focus distance.
 **/

static final int rows = 20;
static final int cols = 20;
static final float cubeSize = 100;
static final float spacing = 1.5;

boolean renderDepth = false;
float[] lightVals;
float xTransConst = cols / 2 * cubeSize / 2 - cubeSize / 1.25;
float transCubeSize = cubeSize * spacing;
Cube[] cubes;
DofManager dof;

public void setup() {
  size(800, 800, P3D);
  // fullScreen(P3D);
  dof = new DofManager();
  dof.setup(this, width, height);
  this.generateCubes();
}

void generateCubes() {
  cubes = new Cube[rows * cols];
  lightVals = new float[] {random(-1, 1), random(-1, 1), random(-1, 1), random(-1, 1), random(-1, 1), random(-1, 1) };
  int rowCols;

  PShape shape;
  for (int row = 0; row < rows; row++) {
    rowCols = row * cols;
    for (int col = 0; col < cols; col++) {
      shape = createShape(BOX, cubeSize);
      shape.setFill(color(0, random(0, 255), random(0, 255)));
      shape.setStroke(false);
      cubes[col + rowCols] = new Cube(col, random(-2000, 0) + 1200, row, shape);
    }
  }
}

public void draw() {
  background(0);

  drawGeometry(dof.getSrc(), true);
  drawGeometry(dof.getDepth(), false);

  dof.draw();

  dof.setMaxDepth(2000);
  dof.setFocus(map(mouseX, 0, width, -0.5f, 1.5f));
  dof.setMaxBlur(0.015);
  dof.setAperture( 0.02f);


  if (!renderDepth)
    image(dof.getDest(), 0, 0);
  else
    image(dof.getDepth(), 0, 0);
}

private void drawGeometry(PGraphics pg, boolean lights) {
  pg.beginDraw();
  pg.background(0);
  
  if (lights) {
    pg.directionalLight(255, 100, 50, lightVals[0], lightVals[1], lightVals[2]);
    pg.directionalLight(50, 100, 255, lightVals[3], lightVals[4], lightVals[5]);
  }

  if (cubes != null && cubes.length > 0) {
    for (int i = 0; i < cubes.length; i++) {
      pg.pushMatrix();
      pg.translate(cubes[i].x * transCubeSize - xTransConst, cubes[i].y, -1850 + cubes[i].z * transCubeSize);
      pg.shape(cubes[i].shape);
      pg.popMatrix();
    }
  }


  pg.endDraw();
}

void mouseClicked() {
  this.generateCubes();
}

void keyPressed() {
  saveFrame("/Users/kindohm/Desktop/dof-cubes-######.png");
}

public class Cube
{
  public PShape shape;
  public float x;
  public float y;
  public float z;

  Cube(float xx, float yy, float zz, PShape shape) {
    this.x = xx;
    this.y = yy;
    this.z = zz;
    this.shape = shape;
  }
}
