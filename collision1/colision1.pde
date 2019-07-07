
/**
 * <b>COLISION 1</b> <br />
 *  Interactive Score Space
  *  2016 <br />
  * <br/>
 * by Luciano Azzigotti.  zztt.org <br />
 * 2016 Buenos Aires Argentina <br />
 
 /*    Licensfle (based on Flocking by Daniel Shiffman.):

      [CC2016] Luciano Azzigotti.

      This software is provided 'as-is', without any express or implied
      warranty.
      In no event will the authors be held liable for any damages arising    
      from the use of this software.
      Permission is granted to anyone to use this software for any purpose,
      including commercial applications, and to alter it and redistribute it
      freely.
*/ 

String[] notehead = {"a","f","e","c","d","b"};


PFont font1;
PFont font2;
PFont font3;

Flock flock;

boolean help_s = true;
boolean grid_s = true;

void setup() {
  
  size (720,480, OPENGL);  /// CHANGE SCREEN SIZE <<<<<<<<
  frameRate (120);
  
  frame.setResizable(false);
frame.setTitle("colisonador");
 font1 = loadFont ("KimiFont-96.vlw");
 font2 = loadFont ("SimplyMono-96.vlw");
 font3 = loadFont ("Serif-48.vlw");
 
   
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < maxBoids; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
}

void draw() {
  background(0);
  flock.run();
  if (help_s==true)helpdraw();
    if (grid_s==true)grid();
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
  help_s = false;
}


//GRIDboolean[][] rects; // twodimensional array, think rows and columns


void grid(){
 
  for(int i=0; i<width; i+= width / gridWidth ){
   line(i,0,i,height);
 }
 for(int w=0; w<height; w+=height / gridHeight){
   line(0,w,width,w);
 }
}


// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
  
   void removeBoid(Boid b) {
boids.remove(b);
 // b.kill();
  }
 
  

}
