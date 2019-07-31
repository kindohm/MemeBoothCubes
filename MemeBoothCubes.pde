/** //<>// //<>//
 Based on: https://github.com/hamoid/P5PostProcessing 
 Move your mouse in X to change focus distance.
 **/

static final float yFloor = -200;
static final float yVary = 0;
static final int rows = 1;
static final int cols = 1;
static final float cubeSize = 300;
static final float spacing = 1.5;
static final float transCubeSize = cubeSize * spacing;
static final float zTrans = (rows - 2) * transCubeSize;
static final float xTransConst = cols / 2 * cubeSize + cubeSize / 3;

boolean renderDepth = false;
float[] lightVals;
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
  cubes = new Cube[7];
  lightVals = new float[] {random(-1, 1), random(-1, 1), random(-1, 1), random(-1, 1), random(-1, 1), random(-1, 1) };
  int rowCols;

  PShape shape;
    for (int i = 0; i < 7; i++) {
      shape = createShape(BOX, cubeSize);
      if (i == 4){
        shape.setFill(color(random(100, 255), 0, random(100, 255)));
      } else {
        shape.setFill(color(0, random(100, 255), random(100, 255)));
      }
      shape.setStroke(false);
      cubes[i] = new Cube(i, 0, 0, shape);
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
    pg.directionalLight(255, 255, 255, lightVals[0], lightVals[1], lightVals[2]);
    pg.directionalLight(255, 255, 255, lightVals[3], lightVals[4], lightVals[5]);
  }

  if (cubes != null && cubes.length > 0) {
    for (int i = 0; i < cubes.length; i++) {
      pg.pushMatrix();
      pg.translate(cubes[i].x * 400 - (3.5*400/2), 1000, -3000);
      pg.rotateX (-0.2);
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
