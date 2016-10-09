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

//HashMap of amino acids to colors
HashMap<String, Integer> aminoColors = new HashMap<String, Integer>();

//protein receptor that is connected to sleepiness (blocked by caffeine)
String adenosineReceptor = "00000000000000000000000000000000000000000000000000GSSVYITVELAIAVLAILGNVLVCWAVWLNSNLQNVTNYFVVSLAAADIAVGVLAIPFAITISTGFCAACHGCLFIACFVLVLTQSSIFSLLAIAIDRYIAIRIPLRYNGLVTGTRAKGIIAICWVLSFAIGLTPMLGWNNCGQPKEGKNHSQGCGEGQVACLFEDVVPMNYMVYFNFFACVLVPLLLMLGVYLRIFLAARRQLKQMESQPLPGERARSTLQKEVHAAKSLAIIVGLFALCWLPLHIINCFTFFCPDCSHAPLWLMYLAIVLSHTNSVVNPFIYAYRIREFRQTFRKIIRSHVLRQQEPFKAAGTSARVLAAHGSDGEQVSLRLNGHPPGVWANGSAPHPERRPNGYALGLVSGGSAQESQGNTGLPDVELLSHELKGVCPEPPGLDDPLAQDGAGVSMGSSVYITVELAIAVLAILGNVLVCWAVWLNSNLQNVTNYFVVSLAAADIAVGVLAIPFAITISTGFCAACHGCLFIACFVLVLTQSSIFSLLAIAIDRYIAIRIPLRYNGLVTGTRAKGIIAICWVLSFAIGLTPMLGWNNCGQPKEGKNHSQGCGEGQVACLFEDVVPMNYMVYFNFFACVLVPLLLMLGVYLRIFLAARRQLKQMESQPLPGERARSTLQKEVHAAKSLAIIVGLFALCWLPLHIINCFTFFCPDCSHAPLWLMYLAIVLSHTNSVVNPFIYAYRIREFRQTFRKIIRSHVLRQQEPFKAAGTSARVLAAHGSDGEQVSLRLNGHPPGVWANGSAPHPERRPNGYALGLVSGGSAQESQGNTGLPDVELLSHELKGVCPEPPGLDDPLAQDGAGVS0000000000";

//protein p53 is a tumor antogen (attacks tumors) - mutations mean tumors likely
String pFiftyThree = "00000000000000000000000000000000000000000000000000MEEPQSDPSVEPPLSQETFSDLWKLLPENNVLSPLPSQAMDDLMLSPDDIEQWFTEDPGPDEAPRMPEAAPRVAPAPAAPTPAAPAPAPSWPLSSSVPSQKTYQGSYGFRLGFLHSGTAKSVTCTYSPALNKMFCQLAKTCPVQLWVDSTPPPGTRVRAMAIYKQSQHMTEVVRRCPHHERCSDSDGLAPPQHLIRVEGNLRVEYLDDRNTFRHSVVVPYEPPEVGSDCTTIHYNYMCNSSCMGGMNRRPILTIITLEDSSGNLLGRNSFEVHVCACPGRDRRTEEENLRKKGEPHHELPPGSTKRALSNNTSSSPQPKKKPLDGEYFTLQIRGRERFEMFRELNEALELKDAQAGKEPGGSRAHSSHLKSKKGQSTSRHKKLMFKTEGPDSD00000000000000000000000000000000000000000000000000";

String currentProtein;
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
  
  //nonpolar letters - shades of blue
  aminoColors.put("G", #0092c7);
  aminoColors.put("A", #0077c7);
  aminoColors.put("V", #005ac7);
  aminoColors.put("I", #0035c7);
  aminoColors.put("L", #0007c7);
  aminoColors.put("M", #4900c7);
  
  //polar uncharged letters - shades of orange
  aminoColors.put("S", #c75300); 
  aminoColors.put("T", #c76300); 
  aminoColors.put("C", #c77700); 
  aminoColors.put("P", #c78b00); 
  aminoColors.put("Q", #c79500);
  
  //positively charged - shades of red
  aminoColors.put("K", #ff008c);
  aminoColors.put("H", #ff0062);
  aminoColors.put("N", #ff002f);
  aminoColors.put("R", #ff0004);
  
  //negatively charged - green
  aminoColors.put("E", #5ac700);
  aminoColors.put("D", #00ff59);
  
  //aromatic - shades of yellow
  aminoColors.put("W", #ffbf00);
  aminoColors.put("F", #ffd900);
  aminoColors.put("Y", #0d9e00);
  aminoColors.put("U", #00bd5e);
  
  //blank
  aminoColors.put("0", #000000);
  
  currentProtein = pFiftyThree;
}

void draw() {

  ArrayList<requestThread> threads = new ArrayList<requestThread>();
  String aminoChars = pFiftyThree.substring(aminoIndex - 14, aminoIndex);
  //String aminoChars = adenosineReceptors.substring(aminoIndex - 14, aminoIndex);
  
  String reversed = "";
  int i = aminoChars.length()-1;
  while(i >= 0){
    println(i);
    reversed += str(aminoChars.charAt(i));
    //println(reversed);
    --i;
  }
  println(reversed);
  int[] rows = {2,3,1,4,0};
  for(int col = 9; col >= 0; col--) {
    for(int rowi = 4; rowi >= 0; rowi--) {
      int row = rows[rowi];
      if(row == 2) {
        currentChar = reversed.charAt(col);
      } else if (row == 1 || row == 3) {
        currentChar = reversed.charAt(col + 1);
      } else {
        currentChar = reversed.charAt(col + 2);
      }
      bucketColor = aminoColors.get(str(currentChar));
      threads.add(buildUpdateRequest(row, col, bucketColor));
    }
  }

  for (int x = 0; x < threads.size(); x++) {
    requestThread request = threads.get(x);
    request.start();
  }
  
  delay(20);
  aminoIndex++;
  
  if(aminoCounter == currentProtein.length()){
    aminoCounter = 0;
    if(currentProtein == pFiftyThree){
      currentProtein = adenosineReceptor;
    }
    else{
      currentProtein = pFiftyThree;
    }
  }
}

  //send get post
requestThread buildUpdateRequest(int bucketRow, int bucketCol, color bucketColor){
  fill(bucketColor);
  rect(bucketCol * 10, bucketRow * 10, 10, 10);
  
  bucketNumber = bucketCol + (bucketRow * 10);
  bucketUniqueAddress = bucketAddress[bucketNumber];
    
  URL = common + bucketUniqueAddress + "/?" + "r=" + int(red(bucketColor)) + "&g=" + int(green(bucketColor)) + "&b=" + int(blue(bucketColor)); 
  
  tempURL = URL;
  requestThread request = new requestThread(tempURL);
  return request;
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