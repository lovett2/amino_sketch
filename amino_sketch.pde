import http.requests.*;

int bucketNumber = 0;
int bucketCol = 0;
int bucketRow = 0;
int[] bucketAddress = new int[55];

//variables used by setBucketColor function
String common = "http://192.168.16.";
String tempURL;
String URL;
int bucketUniqueAddress;

//variables involving amino acid sequence
HashMap<String, Integer> aminoColors = new HashMap<String, Integer>();
String adenosineReceptor = "00000000000000000000000000000000000000000000000000GSSVYITVELAIAVLAILGNVLVCWAVWLNSNLQNVTNYFVVSLAAADIAVGVLAIPFAITISTGFCAACHGCLFIACFVLVLTQSSIFSLLAIAIDRYIAIRIPLRYNGLVTGTRAKGIIAICWVLSFAIGLTPMLGWNNCGQPKEGKNHSQGCGEGQVACLFEDVVPMNYMVYFNFFACVLVPLLLMLGVYLRIFLAARRQLKQMESQPLPGERARSTLQKEVHAAKSLAIIVGLFALCWLPLHIINCFTFFCPDCSHAPLWLMYLAIVLSHTNSVVNPFIYAYRIREFRQTFRKIIRSHVLRQQEPFKAAGTSARVLAAHGSDGEQVSLRLNGHPPGVWANGSAPHPERRPNGYALGLVSGGSAQESQGNTGLPDVELLSHELKGVCPEPPGLDDPLAQDGAGVSMGSSVYITVELAIAVLAILGNVLVCWAVWLNSNLQNVTNYFVVSLAAADIAVGVLAIPFAITISTGFCAACHGCLFIACFVLVLTQSSIFSLLAIAIDRYIAIRIPLRYNGLVTGTRAKGIIAICWVLSFAIGLTPMLGWNNCGQPKEGKNHSQGCGEGQVACLFEDVVPMNYMVYFNFFACVLVPLLLMLGVYLRIFLAARRQLKQMESQPLPGERARSTLQKEVHAAKSLAIIVGLFALCWLPLHIINCFTFFCPDCSHAPLWLMYLAIVLSHTNSVVNPFIYAYRIREFRQTFRKIIRSHVLRQQEPFKAAGTSARVLAAHGSDGEQVSLRLNGHPPGVWANGSAPHPERRPNGYALGLVSGGSAQESQGNTGLPDVELLSHELKGVCPEPPGLDDPLAQDGAGVS0000000000";
int aminoCounter = 0;
char currentChar;

HashMap<String, Integer> elementColors = new HashMap<String, Integer>();
int aminoIndex = 50;

color bucketColor;

void setup() {
  smooth();
  
  int j = 201;
  for(int i = 0; i < 51; i++){
    bucketAddress[i] = j;
    j++;
  }
  
  aminoColors.put("G", #A93226);
  aminoColors.put("A", #CB4335);
  aminoColors.put("L", #884EA0);
  aminoColors.put("M", #7D3C98);
  aminoColors.put("F", #2471A3);
  aminoColors.put("W", #2E86C1);
  aminoColors.put("K", #17A589);
  aminoColors.put("Q", #138D75);
  aminoColors.put("E", #229954);
  aminoColors.put("S", #28B463);
  aminoColors.put("P", #D4AC0D);
  aminoColors.put("V", #D68910);
  aminoColors.put("I", #CA6F1E);
  aminoColors.put("C", #BA4A00);
  aminoColors.put("Y", #641E16);
  aminoColors.put("H", #78281F);
  aminoColors.put("R", #512E5F);
  aminoColors.put("N", #4A235A);
  aminoColors.put("D", #154360);
  aminoColors.put("T", #1B4F72);
  aminoColors.put("U", #0E6251);
  aminoColors.put("0", #000000);
}

void draw() {
  String aminoChars = adenosineReceptor.substring(aminoIndex-50, aminoIndex);
  //aminoChars = reverse(aminoChars);
  //println(aminoChars);
  //println(aminoChars.length());
  String reversed = "";
  int i = 49;
  while(i >= 0){
    println(i);
    reversed += str(aminoChars.charAt(i));
    //println(reversed);
    --i;
  }
  println(reversed);
  
  for(int row = 0; row < 5; row++) {
    for(int col = 0; col < 10; col++) {
      currentChar = reversed.charAt((row*10)+col);
      bucketColor = aminoColors.get(str(currentChar));
      setBucketColor(row, col, bucketColor);
      delay(15);
    }
  }
  
  delay(50);
  aminoIndex++;
  
  if(aminoCounter == adenosineReceptor.length()){
    aminoCounter = 0;
    //exit();
  }
}

  //send get post
void setBucketColor(int bucketRow, int bucketCol, color bucketColor){
  fill(bucketColor);
  rect(bucketCol * 10, bucketRow * 10, 10, 10);
  
  bucketNumber = bucketCol + (bucketRow * 10);
  bucketUniqueAddress = bucketAddress[bucketNumber];
    
  URL = common + bucketUniqueAddress + "/?" + "r=" + int(red(bucketColor)) + "&g=" + int(green(bucketColor)) + "&b=" + int(blue(bucketColor)); 
  
  tempURL = URL;
  requestThread request = new requestThread(tempURL);
  request.start();
  //thread("sendGetRequest");
}

void sendGetRequest(){
  try {
    GetRequest get = new GetRequest(tempURL);
    get.send();
    get = null;
  } catch (Exception err) {
    // don't care lol
  }
}

public class requestThread implements Runnable {
  Thread thread;
  String requesturl;
  public requestThread(String url) { requesturl = url; }
  public void start() {
    thread = new Thread(this);
    thread.start();
  }
  public void dispose() { stop(); }
  public void stop() { thread = null; }
  
  public void run() {
    println(requesturl);
    try {
      GetRequest get = new GetRequest(requesturl);
      get.send();
      get = null;
    } catch (Exception err) {
      // don't care lol
    }
    this.dispose();
  }
}