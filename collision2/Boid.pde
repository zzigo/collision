class Boid {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  int altura = int(random (0, 10));
  boolean alive;
  String btype;
  String nhtype;
  float symbolSize;
  float life = 255;


  int colorNH = 12;
  color[] noteheadColor = {
    color(255, 0, 0), // C red
    color(255, 0, 50), // C# dark magenta
    color(250, 120, 0), // D orange
    color(165, 80, 10), // D# dark orange
    color(255, 255, 0), // E yellow
    color(0, 255, 0), // F green
    color(50, 220, 220), // F# cyan
    color(0, 0, 255), // G blue
    color(150, 5, 200), // G# dark violet
    color(100, 0, 250), // A violet
    color(20, 160, 190), // A# dark cyan
    color(255, 0, 255), // B magenta
    color(255, 255, 255)
  }; // White Noise



  Boid(float x, float y, String type) {
    acceleration = new PVector(0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    btype = type;
    location = new PVector(x, y);
    r = rr;
    maxspeed = gMaxSpeed;
    maxforce = gMaxForce;
    alive = true;
    nhtype = notehead[1];


    if (btype == "pitches" || btype=="0" || btype=="1" || btype=="2" || btype=="3" || btype=="4" || btype=="5") {

      if (btype == "pitches") nhtype = notehead[(int)random(0, 5)];
      else {
        nhtype = notehead[ Integer.parseInt(btype)];
      }

        if (( nhtype.equals("a")) || ( nhtype.equals("f"))) {
          colorNH =altura;
        } else colorNH = 12;

        symbolSize = noteheadSize;
      }

      if (btype == "dynamics") {

        nhtype = dynamics[(int)random(0, 3)];
        colorNH =  12;
        symbolSize = noteheadSize/3;
      }
    }

    void run(ArrayList<Boid> boids) {

      if (alive) {
        flock(boids);
        update();
        borders();
        render();
      }
    }

    void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      acceleration.add(force);
    }

    // We accumulate a new acceleration each time based on three rules
    void flock(ArrayList<Boid> boids) {
      PVector sep = separate(boids);   // Separation
      PVector ali = align(boids);      // Alignment
      PVector coh = cohesion(boids);   // Cohesion
      // Arbitrarily weight these forces
      sep.mult(1.5);
      ali.mult(1.0);
      coh.mult(1.0);
      // Add the force vectors to acceleration
      applyForce(sep);
      applyForce(ali);
      applyForce(coh);
    }

    // Method to update location
    void update() {
      // Update velocity
      velocity.add(acceleration);
      // Limit speed
      velocity.limit(maxspeed);
      location.add(velocity);
      // Reset accelertion to 0 each cycle
      acceleration.mult(0);
    }

    // A method that calculates and applies a steering force towards a target
    // STEER = DESIRED MINUS VELOCITY
    PVector seek(PVector target) {
      PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
      // Scale to maximum speed
      desired.normalize();
      desired.mult(maxspeed);

      // Above two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // desired.setMag(maxspeed);

      // Steering = Desired minus Velocity
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);  // Limit to maximum steering force
      return steer;
    }

    void render() {
      // Draw a triangle rotated in the direction of velocity
      float theta = velocity.heading2D() + radians(90);
      // heading2D() above is now heading() but leaving old syntax until Processing.js catches up

      fill(200, 100);
      stroke(255);
      pushMatrix();
      translate(location.x, location.y);
      if (rotateElement) rotate(theta);


      /////SHAPE
      //   beginShape(TRIANGLES);
      //    vertex(0, -r*2);
      //   vertex(-r, r*2);
      //  vertex(r, r*2); 
      //  endShape();

      //////NOTEHEAD

      fill (noteheadColor[colorNH]);
      textFont (font1, symbolSize);  //draw head
      text(nhtype, location.x/100, location.y/100);

      popMatrix();
    }

    // Wraparound

    void kill() {    
      alive = false;
    }

    boolean finished() {
      // Balls fade out
      life--;
      if (life < 0) {
        return true;
      } else {
        return false;
      }
    }





    void borders() {
      if (location.x < -r) location.x = width+r;
      if (location.y < -r) location.y = height+r;
      if (location.x > width+r) location.x = -r;
      if (location.y > height+r) location.y = -r;
    }

    // Separation
    // Method checks for nearby boids and steers away
    PVector separate (ArrayList<Boid> boids) {
      float desiredseparation = 25.0f;
      PVector steer = new PVector(0, 0, 0);
      int count = 0;
      // For every boid in the system, check if it's too close
      for (Boid other : boids) {
        float d = PVector.dist(location, other.location);
        // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation)) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(location, other.location);
          diff.normalize();
          diff.div(d);        // Weight by distance
          steer.add(diff);
          count++;            // Keep track of how many
        }
      }
      // Average -- divide by how many
      if (count > 0) {
        steer.div((float)count);
      }

      // As long as the vector is greater than 0
      if (steer.mag() > 0) {
        // First two lines of code below could be condensed with new PVector setMag() method
        // Not using this method until Processing.js catches up
        // steer.setMag(maxspeed);

        // Implement Reynolds: Steering = Desired - Velocity
        steer.normalize();
        steer.mult(maxspeed);
        steer.sub(velocity);
        steer.limit(maxforce);
      }
      return steer;
    }

    // Alignment
    // For every nearby boid in the system, calculate the average velocity
    PVector align (ArrayList<Boid> boids) {
      float neighbordist = noteND;
      PVector sum = new PVector(0, 0);
      int count = 0;
      for (Boid other : boids) {
        float d = PVector.dist(location, other.location);
        if ((d > 0) && (d < neighbordist)) {
          sum.add(other.velocity);
          count++;
        }
      }
      if (count > 0) {
        sum.div((float)count);
        // First two lines of code below could be condensed with new PVector setMag() method
        // Not using this method until Processing.js catches up
        // sum.setMag(maxspeed);

        // Implement Reynolds: Steering = Desired - Velocity
        sum.normalize();
        sum.mult(maxspeed);
        PVector steer = PVector.sub(sum, velocity);
        steer.limit(maxforce);
        return steer;
      } else {
        return new PVector(0, 0);
      }
    }

    // Cohesion
    // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
    PVector cohesion (ArrayList<Boid> boids) {
      float neighbordist = noteNDCohesion;
      PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
      int count = 0;
      for (Boid other : boids) {
        float d = PVector.dist(location, other.location);
        if ((d > 0) && (d < neighbordist)) {
          sum.add(other.location); // Add location
          count++;
        }
      }
      if (count > 0) {
        sum.div(count);
        return seek(sum);  // Steer towards the location
      } else {
        return new PVector(0, 0);
      }
    }
  }

