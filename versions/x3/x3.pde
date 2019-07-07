
int initBoidNum = 100; //amount of boids to start the program with
BoidList flock1;//,flock2;//,flock3;
float zoom=800;
boolean smoothEdges = false;
 
void setup()
{
  size(800,600,P3D);
  //create and fill the list of boids
  flock1 = new BoidList(initBoidNum,0);
  //flock2 = new BoidList(0,0);
  //flock3 = new BoidList(100,128);
}
 
void draw()
{
  //clear screen
  beginCamera();
  camera();
  rotateX(map(mouseY,0,height,0, TWO_PI));
  rotateY(map(mouseX,width,0,0, TWO_PI));
  translate(0,0,zoom);
  endCamera();
  background(#75E8ED);
  noFill();
  stroke(#75E8ED);
   
  line(0,0,300,0,height,300);
  line(0,0,900,0,height,900);
  line(0,0,300,width,0,300);
  line(0,0,900,width,0,900);
   
  line(width,0,300,width,height, 300);
  line(width,0,900,width,height, 900);
  line(0,height,300,width, height,300);
  line(0,height,900,width, height,900);
   
  line(0,0,300,0,0,900);
  line(0,height,300,0,height, 900);
  line(width,0,300,width,0,900);
  line(width,height,300,width, height,900);
   
  flock1.run();
  //flock2.run();
  //flock3.run();
  if(smoothEdges)
    smooth();
  else
    noSmooth();
}
 
void keyPressed()
{
  switch (keyCode)
  {
    case UP: zoom-=10; break;
    case DOWN: zoom+=10; break;
  }
  switch (key)
  {
    case 's': smoothEdges = !smoothEdges; break;
  }
}

//new tab 

class Boid
{
  //fields
  PVector pos,vel,acc,ali,coh,sep; //pos, velocity, and acceleration in a vector datatype
  float neighborhoodRadius; //radius in which it looks for fellow boids
  float maxSpeed = 4; //maximum magnitude for the velocity vector
  float maxSteerForce = .1; //maximum magnitude of the steering vector
  float h; //hue
   
  //constructors
  Boid(PVector inPos)
  {
    pos = new PVector();
    pos.set(inPos);
    vel = new PVector(random(-1,1),random(- 1,1),random(1,-1));
    acc = new PVector(0,0,0);
    neighborhoodRadius = 200;
  }
  Boid(PVector inPos,PVector inVel,float r)
  {
    pos = new PVector();
    pos.set(inPos);
    vel = new PVector();
    vel.set(inVel);
    acc = new PVector(0,0);
    neighborhoodRadius = r;
  }
   
  void run(ArrayList bl)
  {
    //acc.add(steer(new PVector(mouseX,mouseY,300), true));
    flock(bl);
    move();
    checkBounds();
    render();
  }
   
  /////-----------behaviors----- ----------
  void flock(ArrayList bl)
  {
    ali = alignment(bl);
    coh = cohesion(bl);
    sep = seperation(bl);
    acc.add(PVector.mult(ali,1));
    acc.add(PVector.mult(coh,3));
    acc.add(PVector.mult(sep,1));
  }
   
  void scatter()
  {
     
  }
  ////-------------------------- ----------
     
  void move()
  {
    vel.add(acc); //add acceleration to velocity
    vel.limit(maxSpeed); //make sure the velocity vector magnitude does not exceed maxSpeed
    pos.add(vel); //add velocity to position
    acc.mult(0); //reset acceleration
  }
   
  void checkBounds()
  {
    if(pos.x>width) pos.x=0;
    if(pos.x<0) pos.x=width;
    if(pos.y>height) pos.y=0;
    if(pos.y<0) pos.y=height;
    if(pos.z>900) pos.z=300;
    if(pos.z<300) pos.z=900;
  }
   
  void render()
  {
     
    pushMatrix();
    translate(pos.x,pos.y,pos.z);
    rotate(atan2(vel.y,vel.x)); //rotate drawing matrix to direction of velocity
    //rotateZ(asin(vel.z/vel.mag() ));
    stroke(#FF2E78, 100);
    noFill();
    //ellipse(0,0, neighborhoodRadius*.5, neighborhoodRadius*1.25); //circling each boid
    noStroke();
    fill(#FFB700, 100);
    //draw triangle
    beginShape(TRIANGLES);
    vertex(3,0);
    vertex(-3,2);
    vertex(-3,-2);
    endShape();
    box(10);
    popMatrix();
  }
   
  //steering. If arrival==true, the boid slows to meet the target. Credit to Craig Reynolds
  PVector steer(PVector target,boolean arrival)
  {
    PVector steer = new PVector(); //creates vector for steering
    if(!arrival)
    {
      steer.set(PVector.sub(target, pos)); //steering vector points towards target (switch target and pos for avoiding)
      steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    }
    else
    {
      PVector targetOffset = PVector.sub(target,pos);
      float distance=targetOffset.mag();
      float rampedSpeed = maxSpeed*(distance/100);
      float clippedSpeed = min(rampedSpeed,maxSpeed);
      PVector desiredVelocity = PVector.mult(targetOffset,( clippedSpeed/distance));
      steer.set(PVector.sub( desiredVelocity,vel));
    }
    return steer;
  }
   
  //avoid. If weight == true avoidance vector is larger the closer the boid is to the target
  PVector avoid(PVector target,boolean weight)
  {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(pos, target)); //steering vector points away from target
    if(weight)
      steer.mult(1/sq(PVector.dist( pos,target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }
   
  PVector seperation(ArrayList boids)
  {
    PVector posSum = new PVector(0,0,0);
    PVector repulse;
    for(int i=0;i<boids.size();i++)
    {
      Boid b = (Boid)boids.get(i);
      float d = PVector.dist(pos,b.pos);
      if(d>0&&d<=neighborhoodRadius)
      {
        repulse = PVector.sub(pos,b.pos);
        repulse.normalize();
        repulse.div(d);
        posSum.add(repulse);
      }
    }
    return posSum;
  }
   
  PVector alignment(ArrayList boids)
  {
    PVector velSum = new PVector(0,0,0);
    int count = 0;
    for(int i=0;i<boids.size();i++)
    {
      Boid b = (Boid)boids.get(i);
      float d = PVector.dist(pos,b.pos);
      if(d>0&&d<=neighborhoodRadius)
      {
        velSum.add(b.vel);
        count++;
      }
    }
    if(count>0)
    {
      velSum.div((float)count);
      velSum.limit(maxSteerForce);
    }
    return velSum;
  }
   
  PVector cohesion(ArrayList boids)
  {
    PVector posSum = new PVector(0,0,0);
    PVector steer = new PVector(0,0,0);
    int count = 0;
    for(int i=0;i<boids.size();i++)
    {
      Boid b = (Boid)boids.get(i);
      float d = dist(pos.x,pos.y,b.pos.x,b. pos.y);
      if(d>0&&d<=neighborhoodRadius)
      {
        posSum.add(b.pos);
        count++;
      }
    }
    if(count>0)
    {
      posSum.div((float)count);
    }
    steer = PVector.sub(posSum,pos);
    steer.limit(maxSteerForce);
    return steer;
  }
}

//new tab

class BoidList
{
  ArrayList boids; //will hold the boids in this BoidList
  float h; //for color
   
  BoidList(int n,float ih)
  {
    boids = new ArrayList();
    h = ih;
    for(int i=0;i<n;i++)
      boids.add(new Boid(new PVector(width/2,height/2,600)) );
  }
   
  void add()
  {
    boids.add(new Boid(new PVector(width/2,height/2)));
  }
   
  void addBoid(Boid b)
  {
    boids.add(b);
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
