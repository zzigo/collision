
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

void helpdraw() {
  
  fill (49,147,82);
  int hx=width/2;
  int hy=height/2;
  pushMatrix();
  translate (hx,hy);
  noStroke();
  box (width/1.5,height/1.3,0); 
  fill (255,255,255);
  textFont(font2, 33 ); 
  textAlign (CENTER);
  text("COLISION Indications | zztt 2016",0, -200 );
  textFont(font2, 17);
  textAlign (LEFT);

              text("Pitched Sound (Newton'scale)\n\nHarmonic or pitched air/noise\n\nWhistlesound or Transparent\n\nAcid High Click\n\nLow Tenuto Dense\n\nNoise ",-170, -130);
              
              textFont (font2, 20);
              text("ShortCuts",-220, 20);
              textFont (font2, 17);
              text("d | D     //  Add | Substract dynamics",-200, 40);
              text("r        //  Trill",-200, 55);
              text("spacebar //  Kill one",-200, 70);
              
           //   text("\nCOMMANDS\n\nMIDI: Turn on/off sounds\nDURATION: Change Total Dur in seconds\nHEADDIN: Proportional head from dynamic\nTRANSPORT: Toggle Concert or Effect Pitch\nVEL [velocity]:\tEnter speed\nT[n] [nameinstr]:\tDefine instrument for each track.\n Available orch instruments:\n picc,fl,ob,cr_ing,cl,cl_b,fg,cfg,crfr,tp,trb,trb_b,tu,perc1-4,\nvl1,vl2,vla,vc,cb,ban_d,ban_i,pno\n\nT ALL [name1] [name2] [...]:\tDefine collective instruments\nG1,G2:\tGenerators\n",-300,-70,width/1.55,height/2,0);  
 textAlign (CENTER);
  text("PRESS THE MOUSE TO START AND ADD AN EVENT",0,200);
  textFont(font1,42);
  text("a\nf\ne\nc\nd\nb",-200,-130);
   popMatrix();
}


/// GENERAL CONFIG


int noteheadSize = 100; // CONFIG THE NOTEHEAD SIZE!!


///NOTE CONFIG
int noteND = 5; //note neigbhor dist (50)
int gMaxSpeed = 1; //
float gMaxForce = 0.03; //
int rr = 1;
int noteNDCohesion = 5; // cohesion neighbor dist (50)
int maxBoids = 0; //
boolean rotateElement = false; //rota los elementos

int gridWidth = 4;
int gridHeight = 3;



///////////////////////TXT
String TextField;
String[] TextField_h;
float[] TextSpace ;
int TextField_p=0;
int TextField_hp=0;
float TextField_off=0;
int TextField_hmax=0;
int timer_C1=1;
int timer_C2=1;
int timer_C3=1;
int timer_VELOCIDAD=2;
int timer_COUNTER=0;
int timer_STEP=0;
int timer_LOOP=0;
int txtsize = 50;


public void keyPressed() {
  
  //---------------IN TXT

// if((int)key>=32 && (int)key<65 || (int)key >96 && (int)key<255 && (int)key!=8 && (int)key!=10){
//    if(TextField_p==TextField.length()){
//      TextField+=key;
//      TextField=TextField.toUpperCase();
//      TextField_p++;
//    }
//    else{
//      String tmp="";
//      tmp+=TextField.substring(0,TextField_p);
//      tmp+=key;
//      tmp+=TextField.substring(TextField_p,TextField.length());
//      TextField=tmp;
//      TextField_p++;
//      TextField=TextField.toUpperCase();
//    }
//  }
//  else if((int)key==8 && TextField.length()>0){
//    String tmp="";
//    for(int i=0;i<TextField.length();i++){
//      if(i!=TextField_p-1){
//        tmp+=TextField.charAt(i);
//      }
//    }
//    TextField_p--;
//    TextField=tmp;
//  }
//  else if(keyCode==LEFT){
//    TextField_p--;
//    TextField_p=max(TextField_p,0);
//  }
//  else if(keyCode==RIGHT){
//    TextField_p++;
//    TextField_p=min(TextField_p,TextField.length());
//  }
//  else if((int)key==10){
//    parseTextField();
//  }
//  if(keyCode==UP && TextField_hp>0){
//    TextField_hp--;
//    TextField_off-=100;
//    TextField=TextField_h[TextField_hp];
//    TextField_p=TextField.length();
//  }
//  if(keyCode==DOWN && TextField_hp<TextField_hmax){
//
//    TextField_hp++;
//    if(TextField_hp!=TextField_h.length-1){
//      TextField_off+=100;
//      TextField=TextField_h[TextField_hp];
//      TextField_p=TextField.length();
//    }
//    else{
//      TextField_off+=100;
//      TextField=" ";
//      TextField_p=0;
//      
//    }
//  }
  
  
  
  
//------------------------------------------------
  
  

///////////////////// KEY

//else if ((int)key>=65 && (int)key<=90){  
 //if ((int)key>=65 && (int)key<=90){      
  switch(key){
    
    default:    
     break;
    
    case 'R':   
   if (!rotateElement){rotateElement=true;  }   
         else{rotateElement=false;}

        break;  
        
        case 'd':   
    flock1.addBoid(new Boid(mouseX, mouseY, "dynamics"));
//println (boids.size());
        break;  

// NOTAS
        case 'q':
      flock1.addBoid(new Boid(mouseX, mouseY, "0"));
        break;
          case 'w':
      flock1.addBoid(new Boid(mouseX, mouseY, "1"));
        break;
          case 'e':
      flock1.addBoid(new Boid(mouseX, mouseY, "2"));
        break;
          case 'r':
      flock1.addBoid(new Boid(mouseX, mouseY, "3"));
        break;
          case 't':
      flock1.addBoid(new Boid(mouseX, mouseY, "4"));
        break;
          case 'y':
      flock1.addBoid(new Boid(mouseX, mouseY, "5"));
        break;
        
        ///
        

      case 's':    //----------------CHANGE SPEED
      if ( gMaxSpeed < 100) {gMaxSpeed = gMaxSpeed + 1;} else { gMaxSpeed = 100; }
      println(gMaxSpeed);
      break;
      case 'S': 
            if ( gMaxSpeed > 0) {gMaxSpeed = gMaxSpeed - 1;} else {gMaxSpeed = 0; }
            println (gMaxSpeed);
      break;
           case 'f':    //----------------CHANGE SPEED
      if ( gMaxForce < 10000000) {gMaxForce = gMaxForce + 100;} else { gMaxForce = 1000000; }
      println(gMaxForce);
      break;
      case 'F': 
            if ( gMaxForce > 0) {gMaxForce = gMaxForce - 100;} else {gMaxForce = 0; }
            println (gMaxForce);
      break;
      case 'H': 
       break;
        case 'U': 
       break;
     case 'M': 

        break;
     case 'p':
//     if(!movie) {
//       movie = true;
//       print ("recording");
//   //   mm = new MovieMaker (this, width,height,"spam####.mov", 30, MovieMaker.ANIMATION, MovieMaker.HIGH);
//     } else {
//       
//       
//       movie = false;
//   //   mm.finish();
//       print("stop recording");
//     }
     case 'z':
//     zoom = constrain(zoom+.1,0, 10);
//     cam.setDistance(zoom);
     break;
     case 'Z':
//     zoom = constrain(zoom-1.,0, 10);
//      endRecord();
     break;
     
     case ' ':
        flock.removeFirst();
        flock1.removeFirst();
  
       break;
       
        case '1':
        flock.setNumber(3);
  
       break;
       
        case '2':
        flock.setNumber(10);
  
       break;
       
        case '3':
        flock.setNumber(20);
  
       break;
        
        case '4':
        flock.killEmAll();
  
       break;
 // }
}
  }  
  
  

  
//--------------------------------PARSEADOR DE TXTIN  
  public void parseTextField(){
    
  String[] acc = splitTokens(TextField);
  if(acc.length==0){return;}
  
//  if(acc[0].equals("VEL")){
//      speed = float(acc[1]);
//    }  
//     
//     
//  //------------------------------TRK OPERATOR
//  
//   else if(acc[0].substring(0,1).equals("T")){
//            String tr1= acc[0].substring(1,2);
//             if (tr1 != " " || int(tr1) <= tracks){    //if is individual T1 or T2 ...
//                      
//                      trkname[int(tr1)-1]= acc[1]; // name set individual
//                    //  println(acc[1]);
//                     // sendclaves(int(tr1)-1);
//                      
//                       
//                      
//                      // for (int i=0; i < maxpulses; i++){memory[i][int(tr1)][0]=0;} //del track content
//                       
//                      
//                       }
//                
//                 else
//                
//                //--------------------------------name set all
//                
//                if (acc[1].equals("ALL")){
//                         for(int j=0;j<acc.length-2;j++){
//                         trkname[j]=(acc[j+2]);
//                                                        }
//                                          }
//                                      
//                    //--------------------------------delete ALL CONTENT                       
//               }
//        
//       else   if(acc[0].substring(0,1).equals("G")){     
//              String tr1= "gen"+acc[0].substring(1);
//             
//               cil.add(new ci(tr1,pulse,100,1,0,0,0));
//          }
//   
//        else  if(acc[0].substring(0,2).equals("GG")){     
//            String tr1= "gen"+acc[0].substring(2,3);
//             cil.add(new ci(tr1,pulse,float (acc[1]),int (acc[2]),int (acc[3]),int (acc[4]),int (acc[5])));
//    }
//    
//    
//   else  if(acc[0].substring(0).equals("0")){
//      pulse=0;
//    }
//   
//    
//   else  if (acc[0].equals("Q")) {
//      
//      reset();
//    }
//    
//  else  if(acc[0].substring(0).equals("DIM")){
//     resize(int(acc[1]), int(acc[2]));
//    }
//    
// else if (acc[0].equals("HEADDIN")) {
//     if (cabezasdin_s) cabezasdin_s = false; else cabezasdin_s = true;
//  }
//  
// else if (acc[0].equals("MIDI")) {
//     if (midi_s) midi_s = false; else midi_s = true;
//  }
//  
//  else if (acc[0].equals("DURATION")) {
//       condicionesiniciales("DURATION",acc[1]);
//  }
//  
// else  if (acc[0].equals("SECTIONS")) {
//       condicionesiniciales( "SECTIONS",acc[1]);
//  }
//   
//  else  if (acc[0].equals("TRANSPORT")) {
//     if (!transport_s) transport_s = true; else transport_s = false;
//  }
//  
//  else if (acc[0].equals("MEL")) {
//                int[] melodia= new int[acc.length];
//     for (int i = 1; i < acc.length; i ++){
//       println(acc[i]);
//       
//       melodia[i]= int(acc[i]);
//       //if  (acc[i].equals(" ")) break;
//       println(melodia[i]);
//     }
//  }
//  
//    
//   else if (acc[0].equals("SAVE")) {
//      
//         saveStrings(Starttime + "_KIMI.txt", logFile);
//
//      String[] linesnames = new String[trkname.length+10];
//        linesnames[0] = "TRACKS"+ "\t" + tracks;
//        
//      for (int i =1; i < trkname.length+1;i++) {
//       linesnames[i] =  "T"+(i-1) + "\t" +  trkname[i-1];
//      }
//      
//      linesnames[trkname.length+1]= "DURATION"+ "\t" + looper;
//      linesnames[trkname.length+2]= "SECTIONS"+ "\t" + cantidaddesecciones;
//      
//      String melodiastring = join(nf(melodia,1), " ");
//      println(melodiastring);
//      linesnames[trkname.length+3]= "MEL"+ "\t" + melodiastring.substring(0,10);
//     saveStrings(acc[1] + ".txt", linesnames);
//      
//      }
//      
//       if (acc[0].equals("OPEN")) {
//      String[] linesnames = loadStrings (acc[1] + ".txt");
//      int linelength = linesnames.length;
// 
//      for (int i =0; i < linelength;i++) {
//        String[]parser=split(linesnames[i],'\t');
//        condicionesiniciales(parser[0],parser[1]);
//    
//      }
//        }
//     
//     
// 
//      
//
//        
//   else     if (acc[0].equals("LOOP")) {
//          
//          looper = int(acc[1]);
//        }
//        
//      // else {;TextField = "";return;}
//      
//      
//  else if (acc[0].equals("PDF")) {  beginRecord(PDF, Starttime + "_kimi.pdf");}
//  else if (acc[0].equals("MAKEPDF")) endRecord();
// //  else if (acc[0].equals("TRACKS")) {endOfGenerations(); condicionesiniciales("TRACKS",acc[1]);}
//
//
//else return;
//       
////-----------------------------------      
 
      if(TextField_hmax==TextField_hp){

    if(TextField_hmax<TextField_h.length-1){
      TextField_h[TextField_hp]=TextField;
      TextField_hp++;
      TextField="";
      TextField_p=0;
      TextField_off=100.0;
      TextField_hmax++;
    }
    else{
      //println(TextField_hp+":"+TextField_hmax+":"+TextField_h[TextField_hp]);
      TextField_h[TextField_hp]=TextField;
      TextField="";
      TextField_p=0;
      TextField_off=100.0;
      for(int i=0;i<TextField_h.length-1;i++){
        TextField_h[i]=TextField_h[i+1];
      }

    }
  }

  else if(TextField_hp<TextField_hmax){
    TextField_h[TextField_hp]=TextField;
    TextField_hp++;
    TextField=TextField_h[TextField_hp];
    TextField_p=TextField.length();
    TextField_off=100.0;
  }
}
  
//-----------------------------------------------------DRAW TEXT  
  
  public void renderTextField(){
  pushMatrix();
  //translate(width/2,height-60,TextField_off);
  scale(.3);
  float p=txtsize/4;
  float y=120;
  for(int i=0;i<TextField.length();i++){
    if(TextField_p-1==i){
      fill(255,10,10);
    }
    else{
      fill(0);
    }
    textAlign (CENTER);
   textFont(font2,50);
    text(TextField.charAt(i),p,y);
    p+=TextSpace[(int)TextField.charAt(i)];
    //println(p);
    if(p>=(width)){
      
      y+=40;
      p=10;
    }
  }
  popMatrix();
  TextField_off*=.8;
}
  


