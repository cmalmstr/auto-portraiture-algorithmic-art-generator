/*##################################################################################################
 Author: Carl Malmstroem
 SFUID:301294715
 ###################################################################################################*/
import processing.video.*;
photo mainPhoto;
drawing mainSketch;
int frameX = 800;               //Window size
int frameY = 800;               //Window size
Capture cam;                    //Capture device
int camID = 28;                 //ID of camera to use
int camX = 1280;                //Set to the camera's resolution
int camY = 800;                 //Set to the camera's resolution
int colorLevels = 5;            //Levels for posterization
int intervalSet = 30;           //Interval (in frames) to check for motion
int interval = 0;
int limitSet = 200;             //Time limit (in frames) to allow for erase
int limit = limitSet;
int imgNo = 0;
boolean erasing = false;
/* #################### Setup #######################################################################*/
void setup() {
  frameRate(60);
  size(frameX, frameY);
  cam = new Capture(this, Capture.list()[camID]);
  mainPhoto = new photo(frameX, frameY, camX, camY, colorLevels);
  mainSketch = new drawing(mainPhoto.getPaths(), colorLevels, frameX, frameY);
  cam.start();
}
/* #################### Draw ########################################################################*/
void draw() {
  image(mainSketch, 0, 0);
  if (cam.available()) {
    if (interval == 0) {
      cam.read();
      if (!erasing && mainPhoto.motion(cam))
        erasing = true;
      else if (mainSketch.erased()) {
        erasing = false;
        limit = limitSet;
        mainPhoto.setCtrl(cam);
        mainSketch = new drawing(mainPhoto.getPaths(), colorLevels, frameX, frameY);
      } else if (mainSketch.painted()) {
        PImage tempImage = createImage(mainSketch.width, mainSketch.height, ARGB);
        tempImage.set(0, 0, mainSketch);   //Need to generate a new PImage that is aware of the location of the application
        tempImage.save("output-"+ imgNo + ".png");
        imgNo++;
      }
      interval = intervalSet;
    }
    interval--;
    if (erasing) {
      if (limit > 0) {
        mainSketch.erasestep();
        limit--;
      } else {
        mainSketch.eraseAll();
        interval = 0;
      }
    } else {
      mainSketch.paintstep();
    }
  }
}

