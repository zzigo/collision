int initBoidNum = 100; //amount of boids to start the program with
BoidList flock1,flock2,flock3;
 
Draggable draggable;
NullDraggableObject nullDraggableObject;
ArrayList draggables;
 
int id;
float[] xposs= new float[10];
float[] yposs= new float[10];
 
String turn; 
 
 
void setup()
{
  size(1000,700);
  //create and fill the list of boids
  flock1 = new BoidList(150,0, 10, 100);
  flock2 = new BoidList(150,255, 10,200);
  flock3 = new BoidList(150,150, 10,300);
 
  turn = "turn";
 
 
  nullDraggableObject = new NullDraggableObject();
 draggables = new ArrayList();
 for(int i = 0; i < 10; i++)
   draggables.add(new DraggableObject(random(width), random(height/2)));
}
 
 
 
 
void draw()
{
 
    background(100, 60);
 
 
  flock1.run();
  flock2.run();
  flock3.run();
 
 
 
 
 
 
  stroke(255);
  noFill();
draggable = nullDraggableObject;
 for(id = 0; id < draggables.size(); id++)
 {
    Draggable d = (Draggable)draggables.get(id);
    d.draw();
    if(d.isBeingMouseHovered())
      draggable = d;
 
 
 }
 
}
 
void mousePressed() {
 draggable.mousePressed();
}
 
void mouseDragged() {
 draggable.mouseDragged();
}
 
void mouseReleased() {
 draggable.mouseReleased();
}
 
interface Draggable{
 boolean isBeingMouseHovered();
 boolean inside(float ix, float iy);
 void draw();
 void mousePressed();
 void mouseDragged();
 void mouseReleased();
}
 
 
class NullDraggableObject implements Draggable{
 boolean isBeingMouseHovered(){ return false;}
 boolean inside(float ix, float iy){return false;}
 void draw(){}
 void mousePressed(){}
 void mouseDragged(){}
 void mouseReleased(){}
}
public class DraggableObject implements Draggable {
 float XX, YY;
 float radius;
 boolean drag;
 float dragX, dragY;
 
 DraggableObject(float _x, float _y) {
   XX = _x; YY = _y;
   radius = 50;
   drag = false;
   dragX = 0;
   dragY = 0;
 }
 
 boolean isBeingMouseHovered()
 {
   return inside(mouseX, mouseY);
 }
 
 boolean inside(float ix, float iy) {
   return (dist(XX, YY, ix, iy) < radius);
 }
 
 void draw() {
   ellipseMode(CENTER);
   ellipse(XX, YY, 2*radius, 2*radius);
   String space = "__";
   println(id); println(XX); println(YY);
   xposs[id] = XX; 
   yposs[id] = YY;
   // String yy = "y:";
   // String xx = "x:";
   // println(xx);
   // println(xposs);
   // println(yy);
   // println(yposs);
 }
 
 void mousePressed() {
   drag = inside(mouseX, mouseY);
   if (drag) {
     dragX = mouseX - XX;
     dragY = mouseY - YY;
   }
 }
 
 void mouseDragged() {
   if (drag) {
     XX = mouseX - dragX;
     YY = mouseY - dragY;
   }
 }
 
 void mouseReleased() {
   drag = false;
 }
}
 
 
 
class Boid
{
  //fields
  PVector pos, vel, acc, ali, coh, sep; //pos, velocity, and acceleration in a vector datatype
  float neighborhoodRadius; //radius in which it looks for fellow boids
  float maxSpeed = 1; //maximum magnitude for the velocity vector
  float maxSteerForce = .05; //maximum magnitude of the steering vector
  float sMod, aMod, cMod; //modifiers for the three forces on the boid
  float h; //hue
 
  //constructors
  Boid(PVector inPos)
  {
    pos = new PVector();
    pos.set(inPos);
    vel = new PVector(random(-1, 1), random(-1, 1));
    acc = new PVector(0, 0);
    neighborhoodRadius = 20;
    sMod = 1; 
    aMod = 1; 
    cMod = 4;
  }
  Boid(PVector inPos, PVector inVel, float r)
  {
    pos = new PVector();
    pos.set(inPos);
    vel = new PVector();
    vel.set(inVel);
    acc = new PVector(0, 0);
    neighborhoodRadius = r;
  }
 
  void run(ArrayList bl)
  {
    //println(xposs[1]); 
    //println(yposs[1]);
    for (int i =0; i < 10; i++){
      acc.add(attract(new PVector(width/2, height/2), true));
      acc.add(avoid(new PVector(xposs[i], yposs[i]), true));
  if (i == 10)
  i = 0;
  }
    if (pos.x>width-10)acc.add(bounce(new PVector(width, pos.y), true));
    if (pos.x<10) acc.add(bounce(new PVector(0, pos.y), true));
    ;
    if (pos.y>height-10) acc.add(bounce(new PVector(pos.x, height), true));
    ;
    if (pos.y<10) acc.add(bounce(new PVector(pos.x, 0), true));
    ;
 
    ali = alignment(bl);
    coh = cohesion(bl);
    sep = seperation(bl);
    for (int i =0; i < 10; i++) {
      if (PVector.dist(new PVector(xposs[i], yposs[i]), pos)>180)
      {
        acc.add(PVector.mult(ali, aMod));
        acc.add(PVector.mult(coh, cMod));
        acc.add(PVector.mult(sep, sMod));
      }
      if (PVector.dist(new PVector(xposs[i], yposs[i]), pos)<80)
        maxSpeed = 1000;
        if (i == 10)
  i = 0;
    }
    if (PVector.dist(new PVector(width, height), pos)<60)
      maxSpeed = 1000;
    //println(turn);
    if (PVector.dist(new PVector(0, 0), pos)<50)
      maxSpeed = 1000;
//////
 
 
 
 
 
 
 
 
    else
      maxSpeed = 1;
    move();
    checkBounds();
    render();
  }
 
  void move()
  {
    vel.add(acc); //add acceleration to velocity
    vel.limit(maxSpeed); //make sure the velocity vector magnitude does not exceed maxSpeed
    pos.add(vel); //add velocity to position
    acc.mult(0); //reset acceleration
  }
 
  void checkBounds()
  {
    // if(pos.x>width) pos.x=0;
    // if(pos.x<0) pos.x=width;
    // if(pos.y>height) pos.y=0;
    // if(pos.y<0) pos.y=height;
  }
 
  void render()
  {
 
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(atan2(vel.y, vel.x)); //rotate drawing matrix to direction of velocity
    stroke(0);
    noFill();
    ellipse(0,0,neighborhoodRadius/2,neighborhoodRadius/2);
    noStroke();
    fill(h);
    //draw triangle
    beginShape(TRIANGLES);
    rect(0,0,6,2);
    // vertex(6, 0);
    //vertex(-6, 2);
    //vertex(-6, -2);
    endShape();
    popMatrix();
  }
 
  //steering. If arrival==true, the boid slows to meet the target. Credit to Craig Reynolds
  PVector steer(PVector target, boolean arrival)
  {
    PVector steer = new PVector(); //creates vector for steering
    if (!arrival)
    {
      steer.set(PVector.sub(target, pos)); //steering vector points towards target (switch target and pos for avoiding)
      steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    } else
    {
      PVector targetOffset = PVector.sub(target, pos);
      float distance=targetOffset.mag();
      float rampedSpeed = maxSpeed*(distance/100);
      float clippedSpeed = min(rampedSpeed, maxSpeed);
      PVector desiredVelocity = PVector.mult(targetOffset, (clippedSpeed/distance));
      steer.set(PVector.sub(desiredVelocity, vel));
    }
    return steer;
  }
 
  //avoid. If weight == true avoidance vector is larger the closer the boid is to the target
  PVector avoid(PVector target, boolean weight)
  {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(pos, target)); //steering vector points away from target
    if (weight)
      steer.mult(1/sq(PVector.dist(pos, target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }
 
    PVector attract(PVector target, boolean weight)
  {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(target, pos)); //steering vector points away from target
    if (weight)
      steer.mult(1/sq(PVector.dist(target, pos)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }
 
  PVector bounce(PVector target, boolean weight)
  {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(pos, target)); //steering vector points away from target
    if (weight)
      steer.mult(1/sq(PVector.dist(pos, target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }
 
  PVector seperation(ArrayList boids)
  {
    PVector posSum = new PVector(0, 0);
    PVector repulse;
    for (int i=0; i<boids.size (); i++)
    {
      Boid b = (Boid)boids.get(i);
      float d = PVector.dist(pos, b.pos);
      if (d>0&&d<=neighborhoodRadius)
      {
        repulse = PVector.sub(pos, b.pos);
        repulse.normalize();
        repulse.div(d);
        posSum.add(repulse);
      }
    }
    return posSum;
  }
 
 
 
  PVector alignment(ArrayList boids)
  {
    PVector velSum = new PVector(0, 0);
    int count = 0;
    for (int i=0; i<boids.size (); i++)
    {
      Boid b = (Boid)boids.get(i);
      float d = PVector.dist(pos, b.pos);
      if (d>0&&d<=neighborhoodRadius)
      {
        velSum.add(b.vel);
        count++;
      }
    }
    if (count>0)
    {
      velSum.div((float)count);
      velSum.limit(maxSteerForce);
    }
    return velSum;
  }
 
  PVector cohesion(ArrayList boids)
  {
    PVector posSum = new PVector(0, 0);
    PVector steer = new PVector(0, 0);
    int count = 0;
    for (int i=0; i<boids.size (); i++)
    {
      Boid b = (Boid)boids.get(i);
      float d = dist(pos.x, pos.y, b.pos.x, b.pos.y);
      if (d>0&&d<=neighborhoodRadius)
      {
        posSum.add(b.pos);
        count++;
      }
    }
    if (count>0)
    {
      posSum.div((float)count);
    }
    steer = PVector.sub(posSum, pos);
    steer.limit(maxSteerForce); 
    return steer;
  }
}
 
 
 
 
class BoidList
{
  ArrayList boids; //will hold the boids in this BoidList
  float h; //for color
 
  BoidList(int n,float ih, int xstart, int ystart)
  {
    boids = new ArrayList();
    h = ih;
    for(int i=0;i<n;i++)
      boids.add(new Boid(new PVector(xstart,ystart)));
  }
 
 
 
  void run()
  {
    for(int i=0;i<boids.size();i++) //iterate through the list of boids
    {
      Boid tempBoid = (Boid)boids.get(i); //create a temporary boid to process and make it the current boid in the list
      tempBoid.h = h;
      tempBoid.run(boids); //tell the temporary boid to execute its run method
    }
  }
}
