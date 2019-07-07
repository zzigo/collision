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
              
              
    //          text("\nCOMMANDS\n\nMIDI: Turn on/off sounds\nDURATION: Change Total Dur in seconds\nHEADDIN: Proportional head from dynamic\nTRANSPORT: Toggle Concert or Effect Pitch\nVEL [velocity]:\tEnter speed\nT[n] [nameinstr]:\tDefine instrument for each track.\n Available orch instruments:\n picc,fl,ob,cr_ing,cl,cl_b,fg,cfg,crfr,tp,trb,trb_b,tu,perc1-4,\nvl1,vl2,vla,vc,cb,ban_d,ban_i,pno\n\nT ALL [name1] [name2] [...]:\tDefine collective instruments\nG1,G2:\tGenerators\n",-300,-70,width/1.55,height/2,0);  
 textAlign (CENTER);
  text("PRESS THE MOUSE TO START AND ADD AN EVENT",0,200);
  textFont(font1,42);
  text("a\nf\ne\nc\nd\nb",-200,-130);
   popMatrix();
}


