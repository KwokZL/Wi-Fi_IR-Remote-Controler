#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
//#include "htmlF.h"
#include <DNSServer.h>
#include <EEPROM.h>
#include <IRremoteESP8266.h>
#include <IRsend.h>
#include <IRrecv.h>
#include <IRutils.h>
//#include <pgmspace.h>

/* Set these to your desired credentials. */
String ssid;
String psw;
ESP8266WebServer server(80);
DNSServer dnsServer;
IPAddress apIP(192, 168, 4, 1);
WiFiUDP udp;
unsigned int localUdpPort = 4210;
IRsend irsend(4);
IRrecv irrecv(14);
decode_results results;

struct config_type
{
  char stassid[32];//定义配网得到的WIFI名长度(最大32字节)
  char stapsw[64];//定义配网得到的WIFI密码长度(最大64字节)
};

config_type config;//声明定义内容



void setup() {
  
  loadConfig();
  
  int i=0;
  
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  //WiFi.setAutoConnect(true);
  WiFi.hostname("Gl IR Control");
  WiFi.begin(ssid,psw);
  Serial.println(ssid);
  Serial.println("i");
  pinMode(13, OUTPUT);
  digitalWrite(13, HIGH);
while(WiFi.status() != WL_CONNECTED){//开始连接
  delay(1000);
  Serial.println("i");
  i++;
Serial.println(i);
Serial.println(psw);
  Serial.println("i");


  if(i>=10){
  WiFi.mode(WIFI_AP); 
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("Gl Device Connect", "");
  //WiFi.mode(WIFI_STA);
  IPAddress myIP = WiFi.softAPIP();
  Serial.println(myIP);
  server.on("/WiFiList", list);
  server.on("/", mainPage);
  server.on("/css", css);
  server.on("/img1", img1);
  server.on("/connectWifi", connectWifi);

  server.onNotFound(mainPage);
  

  dnsServer.start(53, "*", apIP);
  Serial.println(WiFi.softAPIP());
  server.begin();
  break;
  }else{
}

}

if(WiFi.status() == WL_CONNECTED){//运行状态
  server.on("/IRControl", IRControl);
  server.on("/IRReSend", IRReSend);
  server.on("/ReCheck", ReCheck);
  udp.begin(localUdpPort);
  server.begin();
  String ipMsg = WiFi.localIP().toString();
  ipMsg.toUpperCase();
  udp.beginPacketMulticast(IPAddress(255, 255, 255, 255), localUdpPort, WiFi.localIP());
  udp.write(ipMsg.c_str());
  udp.endPacket();
  irsend.begin();
  irrecv.enableIRIn();
  digitalWrite(13, LOW);
  delay(200);
  digitalWrite(13, HIGH);
  delay(200);
  digitalWrite(13, LOW);
  delay(200);
  digitalWrite(13, HIGH);
  delay(200);
  digitalWrite(13, LOW);
  delay(200);
  digitalWrite(13, HIGH);
}
  server.begin();
}

void loop() {
dnsServer.processNextRequest();
server.handleClient();
if(WiFi.status() != WL_CONNECTED){
  digitalWrite(13, LOW);
  delay(1000);
  digitalWrite(13, HIGH);
  delay(1000);
}


  
}

void connectWifi(){
  WiFi.mode(WIFI_STA);
  //WiFi.setAutoConnect(true);
  WiFi.hostname("Gl IR Control");
  WiFi.begin(server.arg("ssid").c_str(),server.arg("password").c_str());
  
  Serial.println(server.arg("ssid"));
  Serial.println(server.arg("password"));
  //int jk;
  while(WiFi.status() != WL_CONNECTED){
    delay(500);
    //jk++;
      
    if(WiFi.status() == WL_CONNECTED){
      
      break;
      //ESP.restart();
    }
    
    
    // delay(500);
    //Serial.println("1234");
  }

  if(WiFi.status() == WL_CONNECTED){
      server.send(200,"text/html","Success");
      //delay(500);143
      strcpy(config.stassid,WiFi.SSID().c_str());//名称复制
      strcpy(config.stapsw,WiFi.psk().c_str());//密码复制
      saveConfig();//调用保存函数
      WiFi.setAutoConnect(true);
      // strncpy(ssids, server.arg("ssid").c_str(), 32); // 读取SSID，最大32个字符
      Serial.println("Connected");

      ESP.restart();
    }

}

void list(){
  int n = WiFi.scanNetworks();
  Serial.println("1");
  if (n>0){
    char wifilist[999] = {0};
    for (int i = 0; i < n; i++) //开始逐个打印扫描到的
    {
      sprintf(wifilist, "%s%s%s%s", wifilist,"<option>", WiFi.SSID(i).c_str(), "</option>");
    }
Serial.println("2");
server.send(200, "text/html",wifilist);
  
  }
Serial.println("3");
}

void mainPage(){
server.send(200, "text/html","\
<html>\
\
<head>\
    <meta charset='utf-8'>\
    <title>连接Wi-Fi以继续</title>\
    <link rel='stylesheet' type='text/css' href='/css'>\
</head>\
\
<body>\
    <div>\
        <div style='line-height:90px' id='mainDiv'>\
            <h1><img id='img1'><br>连接Wi-Fi<br><span id='span1'>感谢您使用Gl Wi-Fi Remote Control套件，现在请您连接您的Wi-Fi以继续：</span>\
            </h1>\
            <form action='/connectWifi' method='get'>\
                <div style='line-height:35px'><span><span class='red'>*</span>选择您的Wi-Fi：</span><select name='ssid'\
                        required='' id='sleSsid'>\
                        <option style='dispaly: none'></option>\
                        <option>请稍后，正在获取Wi-Fi列表</option><!--<option></option>-->\
                    </select><br><span id='js'>未找到您的Wi-Fi？请<a href='/'>点此刷新</a>后再试一次</span></div>\
                <div style='line-height:35px'><span><span class='red'>*</span>密码：</span><input type='password' name='password' required=''><br></div><br><button type='submit'> 连接 </button>\
            </form><span id='c'>(C) 2024 Glinc.top</span>\
        </div>\
    </div>\
    <script>var httpRequest = new XMLHttpRequest(); httpRequest.open('GET', '/WiFiList', true); httpRequest.send(); httpRequest.onreadystatechange = function () { if (httpRequest.status == 200) { var sls = document.getElementById('sleSsid'); sls.innerHTML = '<option style=dispaly: none></option>' + httpRequest.responseText; } };</script>\
    <script src='/img1'></script>\
    <script></script>\
</body>\
\
</html>\
");
}

void css(){
  server.send(200,"text/css","\
  #mainDiv {\
    text-align: center\
}\
\
button {\
    border-radius: 30px;\
    height: 60px;\
    background: rgb(0, 132, 255);\
    color: white;\
    font-size: 30px;\
    -webkit-appearance: none;\
    outline: none;\
    border: 0;\
    display: inline-block;\
}\
\
h1 {\
    font-size: 55px;\
    line-height: 70px;\
}\
\
button:hover {\
    background: rgb(0, 164, 255);\
}\
\
#div2 {\
    /*text-align:left*/\
}\
\
#span1 {\
    font-size: 20px\
}\
\
#js {\
    font-size: 20px;\
    position: relative;\
    left: 140px;\
}\
\
.red {\
    color: red;\
    vertical-align: super;\
    font-size: 22px;\
}\
\
span {\
    font-size: 35px;\
}\
\
input,\
select {\
    font-size: 25px;\
}\
\
@media (prefers-color-scheme: dark) {\
    body {\
        background-color: #1e1e1e;\
        color: #FFF;\
    }\
\
    p {\
        color: #FFFFFF;\
    }\
\
    span {\
        color: #FFF;\
    }\
\
    .div1:hover {\
        background: rgb(55, 55, 55);\
    }\
\
    #h {\
        color: #FFFFFF\
    }\
\
    a {\
        color: rgb(108, 212, 255);\
    }\
}\
  ");
}

void img1(){
  server.send(200,"text/javascript","var img2=document.getElementById('img1');img2.src='\
  data:image/png;base64,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\
  ';");
}

void saveConfig()//保存函数
{
 EEPROM.begin(1024);//向系统申请1024kb ROM
 //开始写入
 uint8_t *p = (uint8_t*)(&config);
  for (int i = 0; i < sizeof(config); i++)
  {
    EEPROM.write(i, *(p + i)); //在闪存内模拟写入
  }
  EEPROM.commit();//执行写入ROM
}

void loadConfig()//读取函数
{
  EEPROM.begin(1024);
  uint8_t *p = (uint8_t*)(&config);
  for (int i = 0; i < sizeof(config); i++)
  {
    *(p + i) = EEPROM.read(i);
  }
  EEPROM.commit();
  ssid = config.stassid;
  psw = config.stapsw;
}

void IRControl(){
  Serial.println(server.arg("IRSign"));
  unsigned long hexValue = strtoul(server.arg("IRSign").c_str(), NULL, 16);

Serial.println(hexValue);
  // 发送红外信号
  irsend.sendNEC(hexValue);
  //irsend.sendNEC(0x00FFE01F);
server.send(200,"text/html","Success");
}


void IRReSend(){
  if (irrecv.decode(&results)) {
    // print() & println() can't handle printing long longs. (uint64_t)
    serialPrintUint64(results.value, HEX);
    char irCodeStr[21]; // 假设红外代码不会超过21位数字
    snprintf(irCodeStr, sizeof(irCodeStr), "%016llX", results.value);
    server.send(200,"text/html",irCodeStr);
    Serial.println(irCodeStr);
    //irCodeStr={20};
    irrecv.resume();  // Receive the next value
  }else{
    server.send(200,"text/html","");
  }
  
  //delay(100);
  
}

void ReCheck(){
  server.send(200,"text/html","Success");
}
