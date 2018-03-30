import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import peasy.*;
import peasy.test.*;


import controlP5.*;

// poils
Poil[][] poils;
PImage skin ;
PImage defMap;

// 3D 
PeasyCam cam;
PMatrix3D currCameraMatrix;
PGraphics3D g3;
/// CONTROLES /////
ControlP5 cp5;

// WIND GROUP
Group Wind;
public boolean wind;
public float var = 1f;
public float windTime = 3000;
public float windSpace = 200;
public float windForce = 0.01f;
public boolean ble = false;
public boolean fColor = false;
public boolean shadow = false;
boolean damier = false;
public float details = 3;

// World GROUP
Group World;
public float absorption = 0.9f;
 
  public float standCoef = 0.01f;
public float heightCoef = 1f;
int sizeX = 200;
int sizeY = 200;
boolean update = true;
boolean showDetails = true;
boolean vecField = true;

// PHOBIC GROUP
Group Phobic;
Slider2D slider2D;
Vector2f phobic = new Vector2f(sizeX / 2, sizeY / 2);
float phobicFactor = 0.5f;
float powFactor = 0.5f;
boolean ball;
boolean pow2;
boolean isPhobic;
float ballSpeed;
float ballAtt;
Vector2f ballVelocity;

// CAM
Group Camera;
float angle = 0.7f;
float zoom = 300;

/*public String sketchRenderer() { 
   return P3D;
 }*/

void setup() {
  size(1500, 1000, P3D);
  skin = loadImage("skin.png");
  defMap = new PImage(sizeX, sizeY);
  cam = new PeasyCam(this, 150);
  cam.setRotations(-0.7f, 0, 0);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(500);
  poils = new Poil[sizeX][sizeY];
  for ( int x = 0; x < sizeX; x ++) {
    for ( int y = 0; y < sizeY; y ++) {
      poils[x][y] = new Poil(x, y, 5 + noise((float)x / 100f, (float)y / 100f) * 15f, 0.5f);
    }
  }
  ballVelocity = new Vector2f(0, 0);
  initGui();
  //frustum(-10, 10, -10, 10, 10, 200);
}

void initGui() {
  cp5 = new ControlP5(this);
    Wind = cp5.addGroup("Herbe")
      .setPosition(10, 20)
          .setBackgroundHeight(160)
            .setWidth(300)
              .setBackgroundColor(color(255, 80))
                ;

    cp5.addSlider("var")
        .setPosition(10, 40)
          .setSize(200, 15)
            .setRange(0.1f, 3f)
              .setValue(1)
                .setGroup(Wind)
                  ;
    cp5.addSlider("windTime")
        .setPosition(10, 65)
          .setSize(200, 15)
            .setRange(2000, 5000)
              .setValue(3000)
                .setGroup(Wind)
                  ;
    cp5.addSlider("windSpace")
        .setPosition(10, 90)
         .setSize(200, 15)
            .setRange(50, 500)
              .setValue(200)
                .setGroup(Wind)
                  ;
    cp5.addSlider("windForce")
        .setPosition(10, 115)
          .setSize(200, 15)
            .setRange(0.001f, 0.02f)
              .setValue(0.01f)
                .setGroup(Wind)
                  ;
    cp5.addToggle("wind")
        .setPosition(10, 10)
          .setSize(40, 15)
            .setValue(true)
              .setMode(ControlP5.SWITCH)
                .setGroup(Wind)
                  ;
  cp5.addToggle("ble")
        .setPosition(70, 10)
          .setSize(40, 15)
            .setValue(true)
              .setMode(ControlP5.SWITCH)
                .setGroup(Wind)
                  ;
  cp5.addToggle("fColor")
    .setPosition(130, 10)
    .setSize(40, 15)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    .setGroup(Wind)
    ;
  cp5.addToggle("shadow")
    .setPosition(190, 10)
    .setSize(40, 15)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    .setGroup(Wind)
    ;
  cp5.addToggle("damier")
    .setPosition(250, 10)
    .setSize(40, 15)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    .setGroup(Wind)
    ;

    World = cp5.addGroup("World")
        .setPosition(10, 190)
          .setBackgroundHeight(220)
            .setWidth(300)
              .setBackgroundColor(color(255, 80))
                ;
    cp5.addSlider("absorption")
        .setPosition(10, 10)
          .setSize(200, 15)
        .setRange(0f, 1f)
              .setValue(0.9f)
                .setGroup(World)
                  ;
    cp5.addSlider("standCoef")
        .setPosition(10, 35)
          .setSize(200, 15)
            .setRange(0f, 0.015f)
              .setValue(0.01f)
                .setGroup(World)
                  ;
    cp5.addSlider("sizeX")
        .setPosition(10, 60)
          .setSize(200, 15)
            .setRange(0, sizeX * 2)
              .setValue( 150 )
                .setGroup(World)
                  ;
    cp5.addSlider("sizeY")
        .setPosition(10, 85)
          .setSize(200, 15)
            .setRange(0, sizeY * 2)
              .setValue( 150 )
                .setGroup(World)
                  ;
    cp5.addSlider("heightCoef")
        .setPosition(10, 110)
          .setSize(200, 15)
            .setRange(0f, 1.0f)
             .setValue(1f)
                .setGroup(World)
            ;
  cp5.addToggle("update")
    .setPosition(10, 130)
    .setSize(40, 15)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    .setGroup(World)
    ;
  cp5.addToggle("showDetails")
    .setPosition(70, 130)
    .setSize(40, 15)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    .setGroup(World)
    ;
  cp5.addToggle("vecField")
    .setPosition(130, 130)
    .setSize(40, 15)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    .setGroup(World)
    ;
  cp5.addSlider("details")
    .setPosition(10, 160)
    .setSize(200, 15)
    .setRange(2, 5)
    .setValue(3)
    .setGroup(World);

    Phobic = cp5.addGroup("Phobic")
        .setPosition(10, 420)
          .setBackgroundHeight(160)
            .setWidth(300)
              .setBackgroundColor(color(255, 80))
                ;
    cp5.addToggle("ball")
        .setPosition(130, 10)
          .setSize(50, 20)
            .setValue(false)
              .setMode(ControlP5.SWITCH)
                .setGroup(Phobic)
                  ;
    cp5.addToggle("pow2")
        .setPosition(70, 10)
          .setSize(50, 20)
            .setValue(true)
              .setMode(ControlP5.SWITCH)
                .setGroup(Phobic)
                  ;
    cp5.addToggle("isPhobic")
        .setPosition(10, 10)
          .setSize(50, 20)
            .setValue(true)
              .setMode(ControlP5.SWITCH)
                .setGroup(Phobic)
                  ;
    slider2D = cp5.addSlider2D("pos")
        .setPosition(10, 45)
          .setSize(100, 100)
           .setArrayValue(new float[] {
            50, 50
         
    }
      )
        .setGroup(Phobic)
          //.disableCrosshair()
          ;
    cp5.addSlider("phobicFactor")
        .setPosition(120, 45)
          .setSize(170, 20)
            .setRange(0.00001f, 3f)
              .setValue(1)
                .setGroup(Phobic)
             ;
    cp5.getController("phobicFactor").getCaptionLabel().align(ControlP5.BOTTOM_OUTSIDE, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    cp5.addSlider("powFactor")
        .setPosition(120, 75)
          .setSize(170, 20)
            .setRange(0.00001f, 5f)
              .setValue(2)
                .setGroup(Phobic)
                  ;
    cp5.getController("powFactor").getCaptionLabel().align(ControlP5.BOTTOM_OUTSIDE, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    cp5.addSlider("ballSpeed")
        .setPosition(120, 105)
          .setSize(170, 20)
            .setRange(0.00001f, 7)
              .setValue(5)
        .setGroup(Phobic)
                  ;
  cp5.getController("ballSpeed").getCaptionLabel().align(ControlP5.BOTTOM_OUTSIDE, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.addSlider("ballAtt")
    .setPosition(120, 135)
    .setSize(170, 20)
    .setRange(0.8f, 1f)
    .setValue(0.95f)
    .setGroup(Phobic)
    ;
    cp5.getController("ballAtt").getCaptionLabel().align(ControlP5.BOTTOM_OUTSIDE, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    cp5.setAutoDraw(false);
}

void slider(float theColor) {
    //myColor = color(theColor);
      println("a slider event. setting background to "+theColor);
}

void draw() {
    background(127);
  //translate(displayWidth/2, displayHeight /2, 0);
  if ( mouseX < 300) {
        cam.setActive(false);
     
  }
     
      else {
        cam.setActive(true);
     
  }

  translate(-sizeX / 2, -sizeY / 2, 0);
  beginShape(QUADS);
  stroke(0);
  fill(#5D3000);
  vertex(0, 0, 0);
  vertex(sizeX, 0, 0);
  vertex(sizeX, sizeY, 0);
  vertex(0, sizeY, 0);

  vertex(0, 0, 0);
  vertex(sizeX, 0, 0);
  fill(#311900);
  vertex(sizeX, 0, -7.5f);
  vertex(0, 0, -7.5f);
  
  fill(#5D3000);
  vertex(0, sizeY, 0);
  vertex(sizeX, sizeY, 0);
  fill(#311900);
  vertex(sizeX, sizeY, -7.5f);
  vertex(0, sizeY, -7.5f);

  fill(#5D3000);
  vertex(sizeX, 0, 0);
  vertex(sizeX, sizeY, 0);
  fill(#311900);
  vertex(sizeX, sizeY, -7.5f);
  vertex(sizeX, 0, -7.5f);

  fill(#5D3000);
  vertex(0, 0, 0);
  vertex(0, sizeY, 0);
  fill(#311900);
  vertex(0, sizeY, -7.5f);
  vertex(0, 0, -7.5f);

  vertex(0, 0, -7.5f);
  vertex(sizeX, 0, -7.5f);
  vertex(sizeX, sizeY, -7.5f);
  vertex(0, sizeY, -7.5f);
  endShape();
  if (update) {
    for ( int x = 0; x < sizeX; x ++) {
      for ( int y = 0; y < sizeY; y ++) {
        poils[x][y].update();
      }  
    }
  }
    drawHerbe();
    if ( isPhobic) {
        updatePhobic();
     
  }
      //camera();
    //perspective(PI / 3f, float(width)/float(height), -1, 1000);
      pushMatrix();
    camera();
    hint(DISABLE_DEPTH_TEST);
    cp5.draw();
  drawGui();
    hint(ENABLE_DEPTH_TEST);
    popMatrix();

  perspective(PI / 3f, float(width)/float(height), 1, 1000);
}

void drawHerbe() {
  if (ball) {
    translate(phobic.x, phobic.y, 10);
    fill(0, 0, 255);
    noStroke();
    sphere(5);
    stroke(0);
    translate(-phobic.x, -phobic.y, -10);
  }
  if ( !vecField) {
    beginShape(LINES);
    if ( showDetails) {
      for ( int x = 0; x < sizeX - 1; x ++) {
        for ( int y = 0; y < sizeY - 1; y ++) {
          for (float dx = 0; dx < 1.0f; dx += 1.0f / details) {
            for (float dy = 0; dy < 1.0f; dy += 1.0f / details) {
              float medPosX = (dx * poils[x+1][y].pos.x + (1.0f - dx) * poils[x][y].pos.x ) ;
              float medPosY = (dy * poils[x][y+1].pos.y + (1.0f - dy) * poils[x][y].pos.y ) ;
              float medAddX = (dx * poils[x+1][y].addX + (1.0f - dx) * poils[x][y].addX ) ;
              float medAddY = (dy * poils[x][y+1].addY + (1.0f - dy) * poils[x][y].addY ) ;
              float tmpH = ((dx * poils[x+1][y].tmpH + (1.0f - dx) * poils[x][y].tmpH ) + (dy * poils[x][y+1].tmpH + (1.0f - dy) * poils[x][y].tmpH ) ) / 2.0f;
              if ( shadow) {
                stroke(0);
              }
              vertex(medPosX, medPosY, 0);
              if ( fColor) {
                float fC = sqrt(poils[x][y].force.x * poils[x][y].force.x + poils[x][y].force.y * poils[x][y].force.y) * 150;
                stroke( fC, 255 - fC, 0);
              } else if (damier) {
                if ( x % 2 == 1 && y % 2 == 1||x % 2 == 0 && y % 2 == 0) {
                  stroke(0);
                } else {
                  stroke(255);
                }
              } else if (ble) {
                stroke(200, 200, 0);
              } else {
                stroke(0, 200, 0);
              }
              vertex(medPosX + medAddX * heightCoef, medPosY + medAddY * heightCoef, tmpH * heightCoef);
              //vertex(medPosX + addX * heightCoef, medPosY + addY * heightCoef, tmpH * heightCoef);
              //vertex(pos.x, pos.y, 0);
            }
          }
        }
      }
    } else {
      defMap.loadPixels();
      for ( int x = 0; x < sizeX; x ++) {
        for ( int y = 0; y < sizeY; y ++) {
          if ( shadow) {
            stroke(0);
          }
          vertex(poils[x][y].pos.x, poils[x][y].pos.y, 0);
          if ( fColor) {
            float fC = sqrt(poils[x][y].force.x * poils[x][y].force.x + poils[x][y].force.y * poils[x][y].force.y) * 150;
            stroke( fC, 255 - fC, 0);
          } else if (ble) {
            stroke(200, 200, 0);
          } else {
            color col = skin.get(int(float(x) / float(sizeX) * 500), int(float(y) / float(sizeY) * 500));
            stroke(col);
          }
          vertex(poils[x][y].pos.x + poils[x][y].addX * heightCoef, poils[x][y].pos.y + poils[x][y].addY * heightCoef, poils[x][y].tmpH * heightCoef);
          defMap.pixels[x * 200 + y] = color( 125f + (poils[x][y].addX / poils[x][y].h ) * 125 ,0, 125f + (poils[x][y].addY / poils[x][y].h ) * 125 );
          //vertex(medPosX + addX * heightCoef, medPosY + addY * heightCoef, tmpH * heightCoef);
          //vertex(pos.x, pos.y, 0);
        }
      }
      defMap.updatePixels();
    }
    endShape();
  } else {
    beginShape(QUADS);
    noStroke();
    for ( int x = 0; x < sizeX; x ++) {
      for ( int y = 0; y < sizeY; y ++) {

        float fC = sqrt(poils[x][y].force.x * poils[x][y].force.x + poils[x][y].force.y * poils[x][y].force.y) * 150;
        fill( fC, 255 - fC, 0);
        vertex(x-0.5f, y-0.5f, 0.1f);
        vertex(x+0.5f, y-0.5f, 0.1f);
        vertex(x+0.5f, y+0.5f, 0.1f);
        vertex(x-0.5f, y+0.5f, 0.1f);


        //vertex(medPosX + addX * heightCoef, medPosY + addY * heightCoef, tmpH * heightCoef);
        //vertex(pos.x, pos.y, 0);
      }
    }
    fill(0, 0, 0);
    stroke(0);
    endShape();
  }
}

void updatePhobic() {
    if ( ball) {
        Vector2f d = new Vector2f((float)slider2D.getArrayValue()[0] / 100f * sizeX - phobic.x, (float)slider2D.getArrayValue()[1] / 100f * sizeY - phobic.y);
    if ( d.x != 0 && d.y != 0) {
          ballVelocity.x += d.x / d.norm / 100;
          ballVelocity.y += d.y / d.norm / 100;
      ballVelocity.x *= ballAtt;
      ballVelocity.y *= ballAtt;
          phobic.x += ballVelocity.x * ballSpeed;
          phobic.y += ballVelocity.y * ballSpeed;
    }
     
  }   else {
        phobic.x = (float)slider2D.getArrayValue()[0] / 100f * sizeX;
        phobic.y = (float)slider2D.getArrayValue()[1] / 100f * sizeY;
        ballVelocity = new Vector2f(0, 0);
     
  }
      for ( int x = 0; 
    x < sizeX; 
    x ++) {
        for ( int y = 0; 
      y < sizeY; 
      y ++) {
            float dist = phobic.getDist(poils[x][y].pos);
            Vector2f dir = new Vector2f(poils[x][y].pos.x - phobic.x, poils[x][y].pos.y - phobic.y).normalize();
            float fact;
            if ( pow2) {
                fact = 1 / pow(dist, powFactor) * phobicFactor;
             
      }
         
              else {
                fact = 1 / dist * phobicFactor;
             
      }

              poils[x][y].addVelocity(new Vector2f(dir.x * fact, dir.y * fact));
        
    }
       
  }
}

void drawGui() {
  text(frameRate, 320, 20);
  image(defMap, width - 300, 0, 300, 300);
}