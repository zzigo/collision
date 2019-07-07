
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

String[] notehead = {
  "a", "f", "e", "c", "d", "b"
};

String[] dynamics = {
  "s", "u", "v"
};


PFont font1;
PFont font2;
PFont font3;

Flock flock,flock1;

boolean help_s = true;
boolean grid_s = true;

void setup() {

  size (720, 480, OPENGL);  /// CHANGE SCREEN SIZE <<<<<<<<
  frameRate (120);

  frame.setResizable(false);
  frame.setTitle("colisonador");
  font1 = loadFont ("KimiFont-96.vlw");
  font2 = loadFont ("SimplyMono-96.vlw");
  font3 = loadFont ("Serif-48.vlw");


  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < maxBoids; i++) {
    flock.addBoid(new Boid(width/2, height/2, "pitches"));
  }
  
    flock1 = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < maxBoids; i++) {
    flock1.addBoid(new Boid(width/2, height/2, "dynamics"));
  }
}

void draw() {
  background(0);
  flock.run();
  flock1.run();
  if (help_s==true)helpdraw();
  if (grid_s==true)grid();
  
  //// DECAIMIENTO
//  
//    for (int i = flock.size()-1; i >= 0; i--) { 
//    // An ArrayList doesn't know what it is storing so we have to cast the object coming out
//  
//    if (flock.finished()) {
//      // Items can be deleted with remove()
//      boids.remove(i);
//    }
//    
//  }  
    
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX, mouseY, "pitches"));
  help_s = false;
}

//// fijate que te lo meti en tus keys
//void keyPressed(){
//  if(KEY == ' ') removeFirstBoid();
//}

//GRIDboolean[][] rects; // twodimensional array, think rows and columns


void grid() {

  for (int i=0; i<width; i+= width / gridWidth ) {
    line(i, 0, i, height);
  }
  for (int w=0; w<height; w+=height / gridHeight) {
    line(0, w, width, w);
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

  private int MAX_QTY = 20;

  void addBoid(Boid b) {    
    println("new boid added. boids qty: " + boids.size());
    boids.add(b);    
    if (boids.size() > MAX_QTY) removeFirst();
  }

  public void removeFirst() {
    if (boids.size() > 0) removeBoid(boids.get(0));
  }

  void removeBoid(Boid b) {
    println("boid " + b.toString() + " removed. boids qty: " + boids.size());
    boids.remove(b);    
    b.kill();
  }
  
  void setNumber(int newQty){
    MAX_QTY = newQty;
    //TODO 
    // y aca vendria el quilombo porque tenes que agregar o quitar segun cuantos tengas.
    // yo los haria mierda todos y crearia todos nuevos con la nueva cantidad
    killEmAll();
    for(int i = 0; i < MAX_QTY; i++) boids.add(new Boid(random(0, width), random(0, height), "pitches"));
  
  }
  
  public void killEmAll(){
    while(boids.size() > 0) removeFirst(); // vacio...  
  }
  
}

