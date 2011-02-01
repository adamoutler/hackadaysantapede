 int WALK=46;
 int EYES=43;
 int SPEAKER=3;
 int GUNLED=53;
 int ROCKETLED=2;
 
 String Login="Santa";
 String Password="Ho";
 String Message="";
 boolean MessageWasReceived=false;
 boolean DisplaySerial=false;
 boolean DisplayReceivedMessage=false;
 boolean Hardcore=false;
 int SoundTimer=0;
 int SoundTone=50;

   
   
   ///if (SoundTimer != 0){ SoundTimer=millis()+100;}
   //if (SoundTimer = millis() ) {
     
   // }

 
 void setup() {
  pinMode(WALK, OUTPUT);  
  pinMode(EYES, OUTPUT);
  pinMode(SPEAKER, OUTPUT);
  pinMode(GUNLED, OUTPUT);
  pinMode(ROCKETLED,OUTPUT);
  
  
  
  tone(SPEAKER, 1000, 100);
  delay(500);
  
  //rampageMode();

  Serial.begin(9600);
  login();
  Serial.println("\n");
  Serial.println("Welcome to Santa OS Mother Fucker");
  systemStatus();

 }


 void loop() {
   receiveSerial();
   if ( MessageWasReceived){
     doStuff();
   }
 }

 void rampageMode(){
   int RampageWalkTimer=0;
   boolean Walking=true;
   RampageWalkTimer=millis()+1000;
   doWalk();
   int Action=0;
   ack();
   while ( 1 == 1 ) {
     receiveSerial();
     if ( Message != "" ){
       if ( Walking == true ){
         Walking=false;
         doWalk();
       }
       ack();
       return;
     }

     if ( Action == 0 ) {
       targetingSound();
       rocketSound();
     }
     if ( Action == 1 ) {
       targetingSound();
       rocketSound();     
     }
     if ( ( Walking == true ) && ( millis() > RampageWalkTimer ) ){
       doWalk();
       RampageWalkTimer=0;
       Walking=false;
     } 
     if ( ( Walking == false ) && ( Action == 2 ) ) {
       RampageWalkTimer=millis()+1000;
       Walking=true;
       doWalk();
     }
     if ( Action == 3 ){
       rocketSound();
     }
     if ( Action == 4 ){
       rocketSound();
     }
     if (Action >= 5 ){
       gunSound();
     }
     Action=random(10);
     
   }
     
}

 void badSound(){
   tone(SPEAKER, 60, 100);
   delay(200);
   tone(SPEAKER, 60, 500);
   delay(1000);
 }

void targetingSound(){
  int freq=1500;
    for (int i=0; i < 2; i++){
      digitalWrite(EYES,HIGH);
      tone(SPEAKER, freq);
      delay(200);
      digitalWrite(EYES,LOW);
      noTone(SPEAKER);
      delay(200);
    }
    int i=80;
    while (i>10){
      digitalWrite(EYES,HIGH);
      tone(SPEAKER, freq);
      delay(i);
      digitalWrite(EYES,LOW);
      noTone(SPEAKER);
      delay(i);
      i=i-10;
    }
    i=0;
    while (i<15){
    digitalWrite(EYES,HIGH);
    tone(SPEAKER, freq);
    delay(20);
    digitalWrite(EYES,LOW);
    noTone(SPEAKER);
    delay(20);
    i++;
    }

    //tone(SPEAKER, 1000);
    //delay(500);
    noTone(SPEAKER);
    digitalWrite(EYES,HIGH);
}

void rocketSound(){
    
  
   for (int y=5; y>1; y-- ){
     for (int x=0; x<=10; x++){
       int dly=random(y);
       digitalWrite(ROCKETLED,HIGH);
       digitalWrite(SPEAKER,HIGH);
       delay(dly);
       dly=random(y);
       digitalWrite(ROCKETLED,LOW);
       digitalWrite(SPEAKER,LOW);
       delay(dly);
     }
   }
   for (int y=1; y<20; y++ ){
     if ( y >= 6 ) {y++;}
     for (int x=0; x<=10; x++){
       int dly=random(y);
       digitalWrite(ROCKETLED,HIGH);
       digitalWrite(SPEAKER,HIGH);
       delay(dly);
       dly=random(y);
       digitalWrite(ROCKETLED,LOW);
       digitalWrite(SPEAKER,LOW);
       delay(dly);
     }
   }
   digitalWrite(EYES,HIGH);
   
  
}




 void gunSound() {
   for (int x=0; x <= 3; x++) {
     digitalWrite(GUNLED, HIGH);
     for (int dly=0; dly <= 11; dly++){
       digitalWrite(SPEAKER,HIGH);
       delay(dly);
       dly++;
       digitalWrite(SPEAKER,LOW);
       delay(dly);
     }
     delay(30);
     digitalWrite(GUNLED,LOW);
     delay(70);
   }
 }
     


 
 void startSound() {
   int FreqSound=40;
   int timer=100;
   for ( int Counter = 0; Counter <= 30; Counter++ ) {
     tone(SPEAKER,FreqSound);
     FreqSound=FreqSound+300;
     delay(5);
     } 
    digitalWrite(WALK,HIGH);
    delay(10);
    digitalWrite(WALK,LOW);
    delay(300);
    digitalWrite(WALK,HIGH);
    delay(10);
    noTone(SPEAKER);
    digitalWrite(WALK,LOW);
   
 }



void systemStatus() {
  Serial.println("Status: Online");
  Serial.print("System runtime: ");
  long time=millis()/1000;
  Serial.print( time );
  Serial.println( "Seconds \n" );
  Serial.print(">");
}

   
 void ack(){
   Message="";
   MessageWasReceived=false;
 }
 
 void login (){
   digitalWrite(EYES, LOW);
   boolean Authenticated=false;
   boolean LoginVerified=false;

   while ( Message == "" ) { receiveSerial(); }
   ack();
   DisplaySerial=true;
   while ( ! Authenticated ) {
     Serial.println("sOS 1.0");
     Serial.print("Login:");   
     while ( ! LoginVerified ) {
       receiveSerial();
       if ( ( MessageWasReceived ) && ( Message == Login ) ) {
         ack();
         LoginVerified=true;
        } else if( ( MessageWasReceived ) && ( Message != Login ) ) {
         LoginVerified=false;
         Serial.println("\nInvalid Username");
         badSound();
         ack();
         break;
       }
     }
     if ( LoginVerified ) {
       Serial.print("\nPassword:");
     }  

     while ( LoginVerified ) {
        receiveSerial();
        if ( ( MessageWasReceived ) && ( Message == Password ) ){
          ack();
           startSound();
           Authenticated=true;
           LoginVerified=false;
           digitalWrite(EYES, HIGH);
          } else if ( ( MessageWasReceived ) && ( Message != Password ) ) {
          ack();
          LoginVerified=false;
          Serial.println("\nInvalid Password.");
          badSound();
        }
     }
   }
 }
 
 
 void receiveSerial (){
     char CharacterReceived=0;
   if ( Serial.available() > 0 ) {
     CharacterReceived=Serial.read();
     if ( DisplaySerial ){ Serial.print(CharacterReceived); }
     if ( CharacterReceived == 13 ) {
       if ( DisplayReceivedMessage ) {
         Serial.print("Command Received: ");
         Serial.println(Message);
       }
       MessageWasReceived=true;
     } else {
       Message= ( Message + CharacterReceived );
     }
   } 
 }
 
 void doWalk(){
   digitalWrite(WALK, HIGH);
   delay(20);
   digitalWrite(WALK, LOW);
 }
   
 
 void doStuff(){
   int SwitchCommand=0;
   if ( Message == "walk" ){ SwitchCommand=1;}
   if ( Message == "stop" ){ SwitchCommand=2;}
   if ( Message == "obj" ){ SwitchCommand=3;}
   if ( Message == "shoot" ){ SwitchCommand=4;}
   if ( Message == "hohoho" ){ SwitchCommand=5;}
   if ( Message == "help" ){ SwitchCommand=6;}
   if ( Message == "rocket" ){ SwitchCommand=7;}
   if ( Message == "logoff" ){ SwitchCommand=8;}
   if ( Message == "logout" ){ SwitchCommand=8;}
   if ( Message == "rampage" ){ SwitchCommand=9;}

   switch (SwitchCommand) {
     case 1:
       Serial.println("Walking..");
       doWalk();
       break;
     case 2:
       Serial.println("Stopping...");
       doWalk();      
       break;
     case 3:
       if ( ! Hardcore ){
         Serial.println("Prime Objectives:  ");
         Serial.println("1. Ho Ho Ho  ");
         Serial.println("2. Merry Christmas ");
         Serial.println("3. Feed Rudolph"); 
       } else {
         Serial.println("Prime Objectives:  ");  
         Serial.println("1.Enforce Niceness");
       }
       break;
     case 4:
       Serial.println("firing");
       gunSound();
       break;
     case 5:
       Serial.println("Ho Ho Ho, Merry Christmas");
       break;
     case 6:
       Serial.println("displaying help");
       doHelp();
       break;
     case 7:
       Serial.println("");
       targetingSound();
       rocketSound();
       break;
     case 8:
       Serial.println("logging off");
       setup();
       break;  
     case 9:
       Serial.println("rampage... press any key to stop");
       rampageMode();
       break;     
     default: 
       Serial.println("Unrecognized command");
       break;
   }
   ack;
   MessageWasReceived=false;
   Message="";
   Serial.print(">");
 }

 void doHelp(){
   Serial.println("Commands:");
   Serial.println("help     - displays a helpful message");
   Serial.println("walk     - tells Santa to walk");
   Serial.println("shoot    - shoot guns");
   Serial.println("rocket   - fires rockets");
   Serial.println("stop     - stops all actions");
   Serial.println("obj      - show objectives");
   Serial.println("rampage - go into hardcore mode");
   
  
  
 }




 
/*
Commented out method of returning what was written


   int NumberToReceive=Serial.available();
   char ReceiveString[255]="";
   int CharPosition=0;
   while (NumberToReceive != 0 ){
     ReceiveString[CharPosition]=Serial.read();
     CharPosition++;
     NumberToReceive=Serial.available();
   }
   if ( CharPosition != 0 ){
     Serial.print(ReceiveString);
     NumberToReceive=Serial.available();
     if ( NumberToReceive == 0 ){
       delay(2);
       NumberToReceive=Serial.available();
       if ( NumberToReceive == 0 ){
         Serial.println("");
       }
     }
   }
 }
*/
