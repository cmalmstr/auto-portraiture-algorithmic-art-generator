/*##################################################################################################
 Fine sketching drawing transformation. Extends the abstract class drawing which in turn is an
 extension of PImage.
 Author: Carl Malmstroem
 SFUID:301294715
 ###################################################################################################*/
class drawing extends PImage {
  private ArrayList<ArrayList<Integer>> sketchpaths;
  private ArrayList<Integer> erasepaths;
  private int level;
  private int step;
  private int colorLevels;
  private float maxLength;
  private boolean done = false;
  /* #################### Constructor #################################################################*/
  drawing (ArrayList sketchpaths, int colorLevels, int w, int h) { 
    this.width = w;
    this.height = h;
    this.sketchpaths = sketchpaths;
    this.colorLevels = colorLevels;
    erasepaths = new ArrayList<Integer>();
    level = 0;
    step = int(random(0, this.sketchpaths.get(level).size()));
    maxLength = 6;
    this.loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = color(255);
    this.updatePixels();
  }
  /* #################### Methods #######################################################################*/
  void paintstep () {
    if (level < sketchpaths.size()) {
      PGraphics pg = createGraphics( this.width, this.height );
      pg.set(0, 0, this);
      pg.beginDraw();
      pg.strokeWeight(0.5);
      if (random(-30, 1) > 0)
        step = int(random(0, sketchpaths.get(level).size()));
      if (sketchpaths.get(level).size() > 0) {
        int steps = 300;
        for (int i=0; i<steps; i++) {
          if (step >=0 && step<sketchpaths.get(level).size()) {
            int pixel = sketchpaths.get(level).get(step);
            sketchpaths.get(level).remove(step);
            erasepaths.add(pixel);
            int x = pixel%this.width;
            int y = (pixel-x)/this.width;
            pg.stroke(level*255/colorLevels, 100);
            pg.pushMatrix();
            pg.translate(x, y);
            if (random(-1, 1) < 0)
              pg.line(-random(maxLength), -random(maxLength), random(maxLength), random(maxLength));
            else
              pg.line(-random(maxLength), -random(maxLength/2), random(maxLength), random(maxLength));
            pg.popMatrix();
            if (step>0)
              step--;
          }
        }
      } else {
        level++;
        if (level < sketchpaths.size())
          step = int(random(0, sketchpaths.get(level).size()));
      }
      pg.endDraw();
      pg.loadPixels();
      this.loadPixels();
      arrayCopy(pg.pixels, this.pixels);
      this.updatePixels();
    }
  }
  void erasestep() {
    if (erasepaths.size() > 0) {
      PGraphics pg = createGraphics( this.width, this.height );
      pg.set(0, 0, this);
      pg.beginDraw();
      pg.stroke(255, 180);
      pg.strokeWeight(20);
      int steps = 200;
      for (int i=0; i<steps; i++) {
        if (erasepaths.size() > 0) {
          int id = int(random(0, erasepaths.size()));
          int pixel = erasepaths.get(id);
          erasepaths.remove(id);
          int x = pixel%this.width;
          int y = (pixel-x)/this.width;
          pg.point(x, y);
        }
      }
      pg.endDraw();
      pg.loadPixels();
      this.loadPixels();
      arrayCopy(pg.pixels, this.pixels);
      this.updatePixels();
    }
  }
  void eraseAll() {
    erasepaths = new ArrayList<Integer>();
  }
  boolean painted () {
    if (!done && level == sketchpaths.size()) {
      done = true;
      return true;
    }
    return false;
  }
  boolean erased () {
    if (erasepaths.size() == 0)
      return true;
    return false;
  }
}

