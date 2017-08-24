/*##################################################################################################
 Author: Carl Malmstroem
 SFUID:301294715
 ###################################################################################################*/
class photo {
  private PImage ctrlImg;
  private int camX;
  private int camY;
  private int colorLevels;
  /* #################### Constructor #################################################################*/
  photo (int frameX, int frameY, int camX, int camY, int colorLevels) {
    ctrlImg = createImage(frameX, frameY, ARGB);
    this.camX = camX;
    this.camY = camY;
    this.colorLevels = colorLevels;
  }
  /* #################### Methods #######################################################################*/
  void setCtrl (Capture capture) {
    ctrlImg.set(-(camX-ctrlImg.width)/2, -(camY-ctrlImg.height)/2, capture);
    ctrlImg = applyEffects(ctrlImg);
  }
  PImage applyEffects (PImage input) {
    input.loadPixels();
    for (int i=0; i<input.pixels.length; i++) {                // Greyscale
      input.pixels[i] = color(brightness(input.pixels[i]));
    }
    for (int i=0; i<input.pixels.length; i++) {                // Posterize
      for (int j=1; j<= colorLevels; j++) {
        if (input.pixels[i] > color((j-1)*255/colorLevels) && input.pixels[i] < color(j*255/colorLevels)) {
          if (j == 1)
            input.pixels[i] = color(0);
          else
            input.pixels[i] = color(j*255/colorLevels);
        }
      }
    }
    input.updatePixels();
    return input;
  }
  ArrayList getPaths () {
    ArrayList<ArrayList<Integer>> colorpaths = new ArrayList<ArrayList<Integer>>();
    for (int i=0; i<colorLevels; i++) {
      ArrayList<Integer> path = new ArrayList<Integer>();
      colorpaths.add(path);
    }
    ctrlImg.loadPixels();
    int w = ctrlImg.width;
    int h = ctrlImg.height;
    for (int w1=0; w1<w; w1+=w/2) {
      for (int h1=0; h1<h; h1+=h/2) {
        for (int w2=w1; w2<w1+w/2; w2+=w/4) {
          for (int h2=h1; h2<h1+h/2; h2+=h/4) {
            for (int w3=w2; w3<w2+w/4; w3+=w/8) {
              for (int h3=h2; h3<h2+h/4; h3+=h/8) {
                for (int w4=w3; w4<w3+w/8; w4+=w/16) {
                  for (int h4=h3; h4<h3+h/8; h4+=h/16) {
                    for (int w5=w4; w5<w4+w/16; w5+=w/32) {
                      for (int h5=h4; h5<h4+h/16; h5+=h/32) {
                        for (int w6=w5; w6<w5+w/32; w6+=w/160) {
                          for (int h6=h5; h6<h5+h/32; h6+=h/160) {
                            for (int wi=0; wi<w/160; wi++) {
                              for (int hi=0; hi<h/160; hi++) {
                                for (int col=0; col<colorLevels; col++) {
                                  if (ctrlImg.pixels[w6+wi+(h6+hi)*w] == color(col*255/colorLevels))
                                    colorpaths.get(col).add(w6+wi+(h6+hi)*w);
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return colorpaths;
  }
  boolean motion (Capture capture) {
    float tolerance = 50;
    PImage newImg = createImage(ctrlImg.width, ctrlImg.height, ARGB);
    newImg.set(-(camX-newImg.width)/2, -(camY-newImg.height)/2, capture);
    newImg = applyEffects(newImg);
    newImg.loadPixels();
    ctrlImg.loadPixels();
    int variation = 0;
    float limit = ctrlImg.pixels.length*tolerance/100;
    for (int i=0; i<ctrlImg.pixels.length; i++) {
      if (ctrlImg.pixels[i] != newImg.pixels[i])
        variation++;
    }
    if (variation > limit)
      return true;
    else
      return false;
  }
}

