// User configurable settings in drybox.h
#include "drybox.h"

#include <Arduino.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <ESPmDNS.h>
#include <HTTPClient.h>
#include <HX711_ADC.h>
#if defined(ESP8266)|| defined(ESP32) || defined(AVR)
#include <EEPROM.h>
#endif
#include "ESPAsyncWebServer.h"
//#include <ArduinoJson.h>
#include "AsyncJson.h"
#include "SPIFFS.h"
#include <AHTxx.h>

unsigned char h2int(char c);
String urlencode(String str);
String urldecode(String str);
boolean isCalibrated();
void setCalibrated(boolean state);
void writeCalibration();
int getScaleWeight();
float getCalibratedScaleWeight();
float getCalibratedScaleNetWeight();
void returnOK(AsyncWebServerRequest * request);
void returnOK(AsyncWebServerRequest * request, String msg);
void returnFail(AsyncWebServerRequest * request, String msg);
boolean isFromDWC(AsyncWebServerRequest * request);
void updateDWC(String postString);
void sendOptions(AsyncWebServerRequest * request);
void setSpoolWeightGet(AsyncWebServerRequest * request);
void setSpoolWeightPost(AsyncWebServerRequest * request, uint8_t *data, size_t len, size_t index, size_t total);
void doCalibrationGet(AsyncWebServerRequest * request);
void doCalibrationPost(AsyncWebServerRequest * request, uint8_t *data, size_t len, size_t index, size_t total);
void doEmptyCalibration(AsyncWebServerRequest * request);
void doTare(AsyncWebServerRequest * request);
void sendIndex(AsyncWebServerRequest * request);
void setupHX711();
void dumpHeaders(AsyncWebServerRequest * request);
void clearCalibration(AsyncWebServerRequest * request);
void sendWeight(AsyncWebServerRequest * request);
void fileNotFound(AsyncWebServerRequest * request);
void computeCalibration();
void sendRawWeight(AsyncWebServerRequest * request);
void fillPage(AsyncWebServerRequest * request, String page, String content);
void sendAllMessageClose(AsyncWebServerRequest * request, String message, boolean dwc);
boolean isAhtError();
void setAhtError(boolean error);
String formatSlope(float slope);
String formatWeight(float grams);
String formatAir(float measurement);
String getSensorReadings();

// hx711 pins:
const int HX711_dout = 18; // HX711 dout pin
const int HX711_sck = 19;  // HX711 sck pin
#define HX711_FAIL 8388608

// EEPROM Addresses and Values
const int calSlope_eeprom = 0;  // store float here
float calSlope;
const int calOffset_eeprom = calSlope_eeprom + sizeof(float);
float calOffset;
const int isCal_eeprom = calOffset_eeprom + sizeof(float);
const int isCalCode = 0xdeadbeef;
const int spool_eeprom = isCal_eeprom + sizeof(float);

// state variables
boolean calibrated = false;
boolean calibratedTare = false;

int calEmptyLoadCell;          // LC reading with no spool
float calEmptyTemp;              // Temp reading at time of calibration
boolean isCalibratedEmpty = false;
int calWeightLoadCell;        // LC reading with calibration mass
float calWeight;                // Weight of calibration mass
boolean isCalibratedWeight = false;

int calWeightMin = 500;         // Minimum calibration weight in grams

float tareOffset = 0;           // in LC uncalibrated units
float spoolWeight = 0;          // in calibrated units

String weightURL = "http://" + String(DWC_NAME) + "/rr_gcode?gcode=";
String stateURL = "http://" + String(DWC_NAME) + "/rr_gcode?gcode=set%20global.instructions=";

WiFiMulti wifiMulti;
AsyncWebServer  server(80);
HX711_ADC LoadCell(HX711_dout, HX711_sck);
AsyncEventSource events("/events");

int lastReportTime = 0;

AHTxx aht20(AHTXX_ADDRESS_X38, AHT2x_SENSOR);
float temperature=0;
float humidity=0;
int lastAhtTime = 0;
boolean ahtError = true;

void setup() {
  Serial.begin(115200);
  Serial.println();

  pinMode(FLASH_LED, OUTPUT);  // TODO: take out
  int led_mode = LOW;

  for(uint8_t t = 4; t > 0; t--) {
      Serial.printf("[SETUP] WAIT %d...\n", t);
      Serial.flush();
      digitalWrite(FLASH_LED, led_mode);  // TODO: take out
      if (led_mode==HIGH) led_mode = LOW;  
      else led_mode= HIGH;
      delay(1000);
  }

  WiFi.config(INADDR_NONE, INADDR_NONE, INADDR_NONE, INADDR_NONE);
  WiFi.setHostname(DRYBOX_NAME); 
  wifiMulti.addAP(ssid, password);
  digitalWrite(FLASH_LED, LOW);  // TODO: take out

  Serial.println("Waiting for WiFi to connect.");
  while(wifiMulti.run() != WL_CONNECTED) {
      Serial.print(".");
      delay(500);
  }
  Serial.println();
  Serial.println("Wifi connected.");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  if (!MDNS.begin(DRYBOX_NAME)) {
      Serial.println("Error setting up MDNS responder!");
  }
  Serial.print("mDNS responder started, hostname: ");
  Serial.println(DRYBOX_NAME);

  // read eeprom and setup hx711 lib
  setupHX711();  

  // Initialize SPIFFS
  if(!SPIFFS.begin(true)){
    Serial.println("An Error has occurred while mounting SPIFFS");
    return;
  }
  // aht25 setup
  int ahtTries = 0;
  while (!aht20.begin() && ahtTries<10)
  {
    Serial.println("AHT2x not ready."); 
    delay(1000);
    ahtTries++;
  }
  if (ahtTries>=10){
    Serial.println("AHT25 failed, giving up.");
    setAhtError(true);
  }
  else{
    Serial.println("AHT25 ready.");
    setAhtError(false);
  }

  // setup default headers to handle CORS requests
  DefaultHeaders::Instance().addHeader("Allow", "GET,POST,OPTIONS");
  DefaultHeaders::Instance().addHeader("Access-Control-Allow-Origin", "*");
  DefaultHeaders::Instance().addHeader("Access-Control-Allow-Headers", "content-type");
  DefaultHeaders::Instance().addHeader("Access-Control-Allow-Method", "POST, GET, OPTIONS");
  DefaultHeaders::Instance().addHeader("Access-Control-Max-Age", "86400");

  //TODO add caching to proper pages
  events.onConnect([](AsyncEventSourceClient *client){
    if(client->lastId()){
      Serial.printf("Client reconnected! Last message ID that it got is: %u\n", client->lastId());
    }
    // send event with message "hello!", id current millis
    // and set reconnect delay to 1 second
    client->send("hello!", NULL, millis(), 10000);
  });
  //events.setAuthentication("user", "pass");
  server.addHandler(&events);

  server.on("/readings", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(200, "text/json", getSensorReadings());
  });
  server.on("/chartscript.js", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(SPIFFS, "/chartscript.js", "application/javascript");
    Serial.println("chartscript.js served.");
  });
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    fillPage(request, "/index.html", "text/html");
    Serial.println("Index served.");
  });
      server.on("/status.json", HTTP_GET, [](AsyncWebServerRequest *request){
    fillPage(request, "/status.json", "text/json");
    Serial.println("json served.");
  });
  server.on("/troubleshooting.html", HTTP_GET, [](AsyncWebServerRequest *request){
    fillPage(request, "/troubleshooting.html", "text/html");
    Serial.println("Troubleshooting served.");
  });
  server.on("/troubleshooting.json", HTTP_GET, [](AsyncWebServerRequest *request){
    fillPage(request, "/troubleshooting.json", "text/json");
    Serial.println("troubleshooting json served.");
  });
  server.on("/style.css", HTTP_GET, [](AsyncWebServerRequest *request){
    AsyncWebServerResponse *response = request->beginResponse(SPIFFS, "/style.css", "text/css");
    //response->addHeader("Cache-Control", "max-age=86400;");
    request->send(response);
    Serial.println("Style served.");
  });
  server.on("/Valkyrie Logo 21.png", HTTP_GET, [](AsyncWebServerRequest *request){
    AsyncWebServerResponse *response = request->beginResponse(SPIFFS, "/Valkyrie Logo 21.png", "image/png");
    response->addHeader("Cache-Control", "max-age=86400;");
    request->send(response);
    Serial.println("Logo served.");
  });
  server.on("/calibration.html", HTTP_GET, [](AsyncWebServerRequest *request){
    fillPage(request, "/calibration.html", "text/html");
  });
  server.on("/favicon.ico", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(SPIFFS, "/favicon.ico", "image/png");
    Serial.println("Favicon.ico served.");
  });
  server.on("/calibrate", HTTP_GET, doCalibrationGet);
  server.on("/calibrate", HTTP_POST, [](AsyncWebServerRequest * request){}, NULL, doCalibrationPost);
  server.on("/spool", HTTP_GET, setSpoolWeightGet);
  server.on("/spool", HTTP_POST, [](AsyncWebServerRequest * request){}, NULL, setSpoolWeightPost);
  server.on("/emptycalibrate", HTTP_GET, doEmptyCalibration);
  server.on("/emptycalibrate", HTTP_POST, doEmptyCalibration);
  server.on("/tare", HTTP_POST, doTare);
  server.on("/tare", HTTP_GET, doTare);
  server.on("/weight", HTTP_GET, sendWeight);
  server.on("/weight", HTTP_POST, sendWeight);
  server.on("/rawweight", HTTP_GET, sendRawWeight);
  server.on("/rawweight", HTTP_POST, sendRawWeight);
  server.onNotFound(fileNotFound);
  server.begin();
}

void setupHX711(){
  LoadCell.begin();
  #if defined(ESP8266)|| defined(ESP32)
    EEPROM.begin(512); 
  #endif
  int isCalCodeRead;
  EEPROM.get(isCal_eeprom, isCalCodeRead);
  if(isCalCodeRead == isCalCode){
    EEPROM.get(calSlope_eeprom, calSlope);
    EEPROM.get(calOffset_eeprom, calOffset);
    EEPROM.get(spool_eeprom, spoolWeight);
    if(isnan(calSlope) || isnan(calOffset)){
      Serial.println("Bad calibration value read from EEPROM.  Clearing calibration.");
      setCalibrated(false);
    }
    else{
      setCalibrated(true);
    }
    Serial.print("Calibration slope: ");
    Serial.println(formatSlope(calSlope));
    Serial.print("Calibration offset: ");
    Serial.println(calOffset);
    Serial.print("Empty spool weight: ");
    Serial.println(spoolWeight);
    Serial.println("HX711 ready.");
  }
  else{
    Serial.println("No calibration info in EEPROM.");
    setCalibrated(false);
  }
  LoadCell.setCalFactor(1.0);  // raw values from hx711 lib
  LoadCell.start(0, false);    // no wait, no tare
  LoadCell.setSamplesInUse(1);
}

boolean isAhtError(){ return ahtError; }
void setAhtError(boolean error){ ahtError = error; return; }

void readAHT(){
  if(isAhtError()) return;
  temperature = aht20.readTemperature();
  humidity = aht20.readHumidity(AHTXX_USE_READ_DATA);
  
  int error = 0;
  while (temperature == AHTXX_ERROR || humidity == AHTXX_ERROR){
    error++;
    setAhtError(true);
    Serial.println("Error reading from AHT25.  Trying again.");
    temperature = aht20.readTemperature();
    humidity = aht20.readHumidity(AHTXX_USE_READ_DATA);
    if(error > 5) return;
  } 
  setAhtError(false);
  return;
}

void runTest(AsyncWebServerRequest* request, uint8_t* data, size_t len, size_t index, size_t total) {
    Serial.println("No test defined.");
    returnOK(request, "No test defined.");
    return;
}

String getSensorReadings(){
    DynamicJsonDocument doc(1024);
    //doc["Temperature"] = "10";
    //doc["Humidity"] = "20";
    doc["Temperature"] = !isAhtError()? formatAir(temperature) : "Error";
    doc["Humidity"] = !isAhtError()? formatAir(humidity) : "Error";
    String jsonString;
    serializeJson(doc, jsonString);
    return jsonString;
}

int getScaleWeight(){
  int i = 0;
  while (true) {
      if(LoadCell.update()){
          float i = LoadCell.getData();
          return round(i);
      }
      if(i<9) delay (10);
      else delay (5);
      i++;
  }
}

float getCalibratedScaleWeight(){
  float calibratedWeight;
  if(isCalibrated()){
     int uncalibratedWeight = getScaleWeight();
     calibratedWeight = (uncalibratedWeight - calOffset + tareOffset)* calSlope;    
     return calibratedWeight;
  }
  else{
    Serial.println("Scale uncalibrated, error.");
    return -1;
  }
}

float getCalibratedScaleNetWeight(){
  return getCalibratedScaleWeight() - spoolWeight;
}

String quoteAndUrlencode(String str){
  return urlencode("\""+str+"\"");
}

// https://circuits4you.com/2019/03/21/esp8266-url-encode-decode-example/
unsigned char h2int(char c)
{
    if (c >= '0' && c <='9'){
        return((unsigned char)c - '0');
    }
    if (c >= 'a' && c <='f'){
        return((unsigned char)c - 'a' + 10);
    }
    if (c >= 'A' && c <='F'){
        return((unsigned char)c - 'A' + 10);
    }
    return(0);
}

// https://circuits4you.com/2019/03/21/esp8266-url-encode-decode-example/
String urlencode(String str)
{
    String encodedString="";
    char c;
    char code0;
    char code1;
    //char code2;
    for (int i =0; i < str.length(); i++){
      c=str.charAt(i);
      if (c == ' '){
        encodedString+= '+';
      } else if (isalnum(c)){
        encodedString+=c;
      } else{
        code1=(c & 0xf)+'0';
        if ((c & 0xf) >9){
            code1=(c & 0xf) - 10 + 'A';
        }
        c=(c>>4)&0xf;
        code0=c+'0';
        if (c > 9){
            code0=c - 10 + 'A';
        }
        //code2='\0';
        encodedString+='%';
        encodedString+=code0;
        encodedString+=code1;
        //encodedString+=code2;
      }
      yield();
    }
    return encodedString;
}

// https://circuits4you.com/2019/03/21/esp8266-url-encode-decode-example/
String urldecode(String str)
{
    String encodedString="";
    char c;
    char code0;
    char code1;
    for (int i =0; i < str.length(); i++){
        c=str.charAt(i);
      if (c == '+'){
        encodedString+=' ';
      }else if (c == '%') {
        i++;
        code0=str.charAt(i);
        i++;
        code1=str.charAt(i);
        c = (h2int(code0) << 4) | h2int(code1);
        encodedString+=c;
      } else{
        encodedString+=c;
      }
      yield();
    }
   return encodedString;
}

void returnOK(AsyncWebServerRequest * request) {
  request->send(200, "text/plain", "");
}

void returnOK(AsyncWebServerRequest * request, String msg) {
  request->send(200, "text/plain", msg + "\r\n");
}

void returnHTTP(AsyncWebServerRequest * request, String msg) {
  request->send(200, "text/html", msg + "\r\n");
}

void returnFail(AsyncWebServerRequest * request, String msg) {
  request->send(500, "text/plain", msg + "\r\n");
}

String formatAir(float measurement){
  char buf [16];
  snprintf(buf,16,"%.1f", round(measurement*10)/10);
  return String(buf);
}

String formatWeight(float grams){
  char buf [16];
  snprintf(buf,16,"%.0f", round(grams));
  return String(buf);
}

String formatSlope(float slope){
  char buf [16];
  snprintf(buf,16,"%.10f", round(slope));
  return String(buf);
}

void fillPage(AsyncWebServerRequest * request, String page, String content){
  String refreshStr;
  if (request->hasArg("refresh")){
    refreshStr = urldecode(request->arg("refresh"));
  }
  else refreshStr = refreshTime;
  
  AwsTemplateProcessor atp = 
    [refreshStr](const String& var){
      float totalWeight = isCalibrated()?getCalibratedScaleWeight(): -1;
      // order chosen for speed, most used are at top of list
      if(var == "EMPTY_SPOOL_WEIGHT") return formatWeight(spoolWeight);
      // not using getCalibratedScaleNetWeight() here because I don't want a 2nd reading
      if(var == "FILAMENT_WEIGHT") return isCalibrated()? formatWeight(totalWeight-spoolWeight) : "Uncalibrated";
      if(var == "TOTAL_WEIGHT") return isCalibrated()? formatWeight(totalWeight) : "Uncalibrated";
      if(var == "TEMPERATURE") return !isAhtError()? formatAir(temperature) : "Error";
      if(var == "HUMIDITY") return !isAhtError()? formatAir(humidity) : "Error";
      if(var == "REFRESH") return refreshStr;
      if(var == "CALIBRATION_SLOPE") return isCalibrated()? formatSlope(calSlope) : "Uncalibrated";
      if(var == "CALIBRATION_OFFSET") return isCalibrated()? String(calOffset) : "Uncalibrated";
      if(var == "TARE_OFFSET") return isCalibrated()? String(tareOffset) : "Uncalibrated";
      if(var == "DRYBOX_NAME") return String(DRYBOX_NAME);
      if(var == "DWC_REPORT_TIME") return String(reportTime);
      return String();
    };

  AsyncWebServerResponse *response = request->beginResponse(SPIFFS, page, content, false, atp);
  request->send(response);
}

boolean isFromDWC(AsyncWebServerRequest * request){
   if (!request->hasArg("dwc")){
      Serial.println("Not from DWC.");
      return false;
   }
   return true;
}

void dumpHeaders(AsyncWebServerRequest * request){
  Serial.println("Dumping Headers:");
  int headers = request->headers();
  int i;
  for(i=0;i<headers;i++){
    AsyncWebHeader* h = request->getHeader(i);
    Serial.printf("HEADER[%s]: %s\n", h->name().c_str(), h->value().c_str());
  }
}

void fileNotFound(AsyncWebServerRequest * request) {
  if (request->method() == HTTP_OPTIONS) {
    sendOptions(request);
    return;
  }
  dumpHeaders(request);
  String message = "File not found\n";
  message += "URL: ";
  message += request->url();
  message += "\nMethod: ";
  message += request->methodToString();
  message += "\nArguments: ";
  message += request->args();
  message += "\n";
  for (uint8_t i = 0; i < request->args(); i++) {
    message += " NAME:" + request->argName(i) + "\n VALUE:" + request->arg(i) + "\n";
  }
  request->send(404, "text/plain", message);
  Serial.print(message);
}

void sendOptions(AsyncWebServerRequest * request) {
  Serial.println("handling options request.");
  // Put special OPTIONS request handling here or add to default headers in setup()
  returnOK(request);
}

boolean isCalibrated(){
  return calibrated;
}

void setCalibrated(boolean state){
  calibrated = state;
  return;
}

void writeCalibration(){
  if(isnan(calSlope)){
    Serial.println("Slope is nan, not saving calibration data.");
    return;
  }
  EEPROM.put(calSlope_eeprom, calSlope);
  EEPROM.put(calOffset_eeprom, calOffset);
  EEPROM.put(isCal_eeprom, isCalCode);
  EEPROM.put(spool_eeprom, spoolWeight);
#if defined(ESP8266)|| defined(ESP32)
  EEPROM.commit();
#endif
}

void doEmptyCalibration(AsyncWebServerRequest * request){
  Serial.println("Clearing calibration.");
  setCalibrated(false);
  isCalibratedEmpty = false;
  isCalibratedWeight = false;
  tareOffset = 0;
  Serial.println("Reading load cell without spool.");
  boolean dwc = isFromDWC(request);
  if(dwc) updateDWC(stateURL+"\"Please%20wait.\"");
  LoadCell.refreshDataSet();  // flush readings just in case
  calEmptyLoadCell = getScaleWeight();
  if (calEmptyLoadCell == HX711_FAIL){
    sendAllMessageClose(request, "Check connection to HX711.", dwc);
    return;
  }
  isCalibratedEmpty = true;
  String message = "Raw load cell value without spool: ";
  message += calEmptyLoadCell;
  returnOK(request, message);
  Serial.println(message);
  if(dwc) updateDWC(stateURL+"\"Empty%20calibration%20complete.\"");
  return;
}

void doTare(AsyncWebServerRequest * request){
    Serial.println("Attempting to tare scale.");
    boolean dwc = isFromDWC(request);
    if(!isCalibrated()){
      String message = "Please calibrate scale.";
      if(dwc) updateDWC(stateURL+quoteAndUrlencode(message));
      Serial.println(message);
      returnOK(request, message);
      return;
    }  
    else{
      if(dwc) updateDWC(stateURL+"\"Please%20wait.\"");
      LoadCell.refreshDataSet();  // flush readings just in case
      tareOffset = calOffset - getScaleWeight();
      String message = "Tare completed.";
      if(dwc) updateDWC(stateURL+quoteAndUrlencode(message));
      returnOK(request, message);
    }
}

void doCalibrationGet(AsyncWebServerRequest * request){
  Serial.println("Reading load cell with calibration mass.");
  boolean dwc = isFromDWC(request);
  if(!isCalibratedEmpty){
    String message = "Remove spool weight from scale and do empty calibration.";
    Serial.println(message);
    if(dwc) updateDWC(stateURL+quoteAndUrlencode(message));
    returnOK(request, message);
    return;
  }
  String message = "Weight value required for calibration.";
  if (!request->hasArg("weight")){
    Serial.println(message);
    if(dwc) updateDWC(stateURL+quoteAndUrlencode(message));
    returnOK(request, message);
    return;
  }
  else{
    String strWeight = urldecode(request->arg("weight"));
    Serial.print("Calibration weight: ");
    Serial.println(strWeight);
    char *ending;
    calWeight = strtof(strWeight.c_str(), &ending);
    if (*ending != 0){
      Serial.println("Error converting calibration value to float.");
      Serial.println(message);
      if(dwc) updateDWC(stateURL+quoteAndUrlencode(message));
      returnOK(request, message);
      return;
    }
  }
  if(dwc) updateDWC(stateURL+"\"Please%20wait.\"");
    LoadCell.refreshDataSet();  // flush readings just in case
    calWeightLoadCell = getScaleWeight();
    isCalibratedWeight = true;
    message = "Load cell value with weight of ";
    message += calWeight;
    message += ": ";
    message += calWeightLoadCell;
    returnOK(request, message);
    Serial.println(message);
    computeCalibration();
    if(dwc) updateDWC(stateURL+"\"Weighted%20calibration%20complete.\"");
    return;
}

void doCalibrationPost(AsyncWebServerRequest * request, uint8_t *data, size_t len, size_t index, size_t total){
    Serial.println("Reading load cell with calibration mass.");
    //boolean dwc = isFromDWC(request);
    boolean dwc = true;
    if(!isCalibratedEmpty){
      String message = "Remove spool weight from scale and do empty calibration.";
      Serial.println(message);
      if(dwc) updateDWC(stateURL+quoteAndUrlencode(message));
      returnOK(request, message);
      return;
    }
    String message = "Weight value required for calibration.";
    if(request->method() == HTTP_GET){    
      if (!request->hasArg("weight")){
        Serial.println(message);
        if(dwc) updateDWC(stateURL+quoteAndUrlencode(message));
        returnOK(request, message);
        return;
      }
      else{
        String strWeight = urldecode(request->arg("weight"));
        Serial.print("Calibration weight: ");
        Serial.println(strWeight);
        char *ending;
        calWeight = strtof(strWeight.c_str(), &ending);
        if (*ending != 0){
          Serial.println("Error converting calibration value to float.");
          Serial.println(message);
          if(dwc) updateDWC(stateURL+quoteAndUrlencode(message));
          returnOK(request, message);
          return;
        }  
      }
    }
    else{
      Serial.println();
      Serial.println("Scanning JSON post");
      DynamicJsonDocument bodyJSON(1024);
      deserializeJson(bodyJSON, data, len);
      String strWeight = bodyJSON["weight"];
      Serial.print("weight: ");
      Serial.println(strWeight);
      char *ending;
      calWeight = strtof(strWeight.c_str(), &ending);
      if (*ending != 0){
        Serial.println("Error converting calibration value to float.");
        Serial.println(message);
        if(dwc) updateDWC(stateURL+quoteAndUrlencode(message));
        returnOK(request, message);
        return;
      }
    }
    if(dwc) updateDWC(stateURL+"\"Please%20wait.\"");
    LoadCell.refreshDataSet();  // flush readings just in case
    calWeightLoadCell = getScaleWeight();
    isCalibratedWeight = true;
    message = "Load cell value with weight of ";
    message += calWeight;
    message += ": ";
    message += calWeightLoadCell;
    returnOK(request, message);
    Serial.println(message);
    computeCalibration();
    if(dwc) updateDWC(stateURL+"\"Weighted%20calibration%20complete.\"");
    return;
}

void computeCalibration(){
  calOffset = calEmptyLoadCell;
  calSlope = calWeight/(calWeightLoadCell-calOffset);
  Serial.print(calWeight); Serial.print("/(");
  Serial.print(calWeightLoadCell); Serial.print("-");
  Serial.print(calOffset); 
  Serial.print(")=");
  Serial.println(calSlope);
  writeCalibration();
  setCalibrated(true);
  return;
}

void sendWeight(AsyncWebServerRequest * request){
  String message;
  if(isCalibrated())
    message = String(getCalibratedScaleNetWeight());
  else
    message = "Please calibrate the scale.";
  request->send(200, "text/plain", message);
  Serial.println(message);
}

void sendRawWeight(AsyncWebServerRequest * request){
  String message;
  message = String(getScaleWeight());
  request->send(200, "text/plain", message);
  Serial.println(message);
}

void sendAllMessageClose(AsyncWebServerRequest * request, String message, boolean dwc){
  Serial.println(message);
  if(dwc) updateDWC(stateURL+quoteAndUrlencode(message));
  returnOK(request, message);
  return;
}

void setSpoolWeightPost(AsyncWebServerRequest * request, uint8_t *data, size_t len, size_t index, size_t total){
    Serial.println("Attempting to set spool weight.");
    //boolean dwc = isFromDWC(request);
    boolean dwc = true;
    String message = "Weight value required.";
    DynamicJsonDocument bodyJSON(1024);
    deserializeJson(bodyJSON, data, len);
    //TODO check for presence of weight tag, error if not found
    String strWeight = bodyJSON["weight"];
    Serial.println("weight: " + String(strWeight));
    char *ending;
    spoolWeight = strtof(strWeight.c_str(), &ending);
    if (*ending != 0){
      Serial.println("Error converting weight value to float.");
      sendAllMessageClose(request, message, dwc);
      return;
    }
    if(!isCalibrated()){
      sendAllMessageClose(request, "Calibrate scale before setting empty spool weight.", dwc);
      return;
    }
    message = "Setting spool weight to: "+ String(spoolWeight);
    writeCalibration();
    sendAllMessageClose(request, message, dwc);
    return;
}

void setSpoolWeightGet(AsyncWebServerRequest * request){
    Serial.println("Attempting to set spool weight.");
    boolean dwc = isFromDWC(request);
    String message = "Weight value required.";
    if(request->method() == HTTP_GET){    
      if (!request->hasArg("weight")){
        sendAllMessageClose(request, message, dwc);
        return;
      }
      else{
        String strWeight = urldecode(request->arg("weight"));
        Serial.println("Spool weight: " + strWeight);
        char *ending;
        spoolWeight = strtof(strWeight.c_str(), &ending);
        if (*ending != 0){
          Serial.println("Error converting weight value to float.");
          sendAllMessageClose(request, message, dwc);
          return;
        }  
      }
    }
    if(!isCalibrated()){
      sendAllMessageClose(request, "Calibrate scale before setting empty spool weight.", dwc);
      return;
    }
    writeCalibration();
    message = "Setting spool weight to: "+ String(spoolWeight);
    sendAllMessageClose(request, message, dwc);
    return;
}

void updateDWC(String postString){
  if(wifiMulti.run() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(postString);
    int httpCode = http.GET();
    if(httpCode > 0) {
        if(httpCode == HTTP_CODE_OK) {
            String payload = http.getString();
            //Serial.println(payload);
        }
    } else {
        Serial.printf("[HTTP] GET failed, error: %s\n", http.errorToString(httpCode).c_str());
    }
    http.end();
  }
}

String buildPostData(){
  String str;
  str+="set global.filamentWeight=\"";
  if(isCalibrated()){
    str+=formatWeight(getCalibratedScaleNetWeight())+"g\"";
  }
  else{
    str+="Uncalibrated\"";
  }
  str+="\nset global.totalWeight=\"";
  if(isCalibrated()){
    str+=formatWeight(getCalibratedScaleWeight())+"g\"";
  }
  else{
    str+="Uncalibrated\"";
  }

  str+="\nset global.dryBoxRH=";
  str+="\"";
  str+= !ahtError? formatAir(humidity) : "Error";
  str+= !ahtError? "%RH\"" : "\"";
  str+="\nset global.dryBoxTC=";
  str+="\"";
  str+= !ahtError? formatAir(temperature) : "Error";
  str+= !ahtError? "C\"" : "\"";
  str+="\nset global.preSpoolWeight=";
  str+="\"";
  str+= formatWeight(spoolWeight);
  str+= "g\"";

  //Serial.println("Post data:"+ urlencode(str));
  return urlencode(str);
}

void loop() {

    // TODO: does esp32 have time rollover issue like arduino?
    if(lastAhtTime+ahtReadTime<millis()){
       readAHT();
       lastAhtTime = millis();
       // update chart
       events.send("ping",NULL,millis());
       events.send(getSensorReadings().c_str(),"new_readings" ,millis());
    }
    // wait for WiFi connection
    if((lastReportTime+reportTime<millis())
        &&(wifiMulti.run() == WL_CONNECTED)) {
       #ifndef STANDALONE
       updateDWC(weightURL+buildPostData());
       #endif
       lastReportTime = millis();
    }
}