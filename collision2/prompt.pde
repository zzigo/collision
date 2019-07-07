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
  

