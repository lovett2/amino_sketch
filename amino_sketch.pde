import http.requests.*;

int bucketNumber = 0;
int bucketCol = 0;
int bucketRow = 0;

int counter = 0;
int[] bucketAddress = new int[55];

String tempURL;

int sendCounter = 0;

String[] program = {"ocean", "vapor", "spinner", "rainbow", "bonfire", "ctrlh", "text", "circle", "tron"};
char[] aminoDict = {'a', 'b', 'c'};
char[] aminoAcid = {'a', 'b', 'c', 'b', 'c', 'c'};
int aminoCounter = 0;
char currentChar = aminoAcid[aminoCounter];

int waitTime = 500;
int lastTime = 0;

int increment = 0;

int colors = 10;
int colorRed = 0;
int colorGreen = 0;
int colorBlue = 0;
int colorJ = 0;
int wheelPos = 0;

void setup() {
  //size(512, 424);
  smooth();
  
  int j = 201;
  for(int i = 0; i < 51; i++){
    bucketAddress[i] = j;
    j++;
  }
}

void draw() {
 
  background(0);

  if(sendCounter < 1){ //send x amount of times 
    //println(colors);
    bucketNumber = bucketCol + bucketRow;
    sendGet(bucketNumber, colorRed, colorGreen, colorBlue, program[increment]);
    delay(15);
    println("Bucket number :" + bucketNumber);
    bucketCol += 10;
    if(bucketCol == 50){  //completed sending to all 50 buckets
      sendCounter = 0;
      //if(sendCounter < 5){ //sendcounter goes to 5 and we stop sending
      //  sendCounter++;
      //}
      bucketCol = 0;
      bucketRow++;
      if(bucketRow == 10){
        bucketRow = 0;
      }
    }
    
    wheelPos = 255 - ((colorJ+bucketNumber) & 255);
    
    if(wheelPos < 85) {
      colorRed = 255 - wheelPos * 3;
      colorGreen = 0;
      colorBlue = wheelPos * 3;
    }
    if(wheelPos > 85 && wheelPos < 170) {
      wheelPos -= 85;
      colorRed = 0;
      colorGreen = wheelPos * 3;
      colorBlue = 255 - wheelPos * 3;
    }
    if(wheelPos > 170){
      wheelPos -= 170;
      colorRed = wheelPos * 3;
      colorGreen = 255 - wheelPos * 3;
      colorBlue = 0;
    }
    colorJ++;
    if(colorJ > 255){
      colorJ = 0;
    }
    
  }
  else{
    //println("finished sending");
  }
  
  switch(currentChar){
    case 'a':
      redColor = 255;
      greenColor = 0;
      blueColor = 0;
      break;
     case 'b':
       redColor = 0;
       greenColor = 255;
       blueColor = 0;
       break;
      case 'c':
        redColor = 0;
        greenColor = 0;
        blueColor = 255;
        break;
  }

if(millis() - lastTime > waitTime){  //change program every 12 seconds... reset send counter
  increment++;   //goes t next program
  //sendCounter = 0;  //restarts sending to buckets
  lastTime = millis();
  if(increment == 9){
    increment = 0;
  }
}

}

class amino {
  
}

  //send get post
void sendGet(int bucketPos, int red, int green, int blue, String currentProgram){
 
 //for(int j=201; j<251; j++){  //add addresses to all the buckets
  //int j = 201;
  //for(int i=0; i<51; i++){
    //bucketAddress[i] = j;
    //j++;
  //}
//}
  
  
  String common = "http://192.168.16."; // answer text
  int bucketUniqueAddress = bucketAddress[bucketPos];
  
  //String URL = common + bucketUniqueAddress + "/?" + "sequence=" + currentProgram;
  
  String URL = common + bucketUniqueAddress + "/?" + "r=" + red + "&g=" + green + "&b=" + blue; 
  
  println(URL);
  
  tempURL = URL;
  thread("sendGetRequest");
}

void sendGetRequest(){
  try {
    GetRequest get = new GetRequest(tempURL);
    get.send();
  } catch (Exception err) {
    // don't care lol
  }
}