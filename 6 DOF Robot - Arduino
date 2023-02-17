// Seminarski rad iz Mikroprocesorskog upravljanja
// Mehatronika i robotika
// 6-stupanjski manipulator
// Karlo Kvaternik

#include <Servo.h> // uključivanje "Servo" library iz kojeg se koriste
njegove funkcije (attach)

Servo servo01; // Učitavanje servomotora
int servo1Poz; //Trenutna pozicija motora 1
int servo1PPoz; // Prethodna pozicija motora 1
int x_pin1=A5; // pin sa kojeg se očitava sa lijeve "gljive"
int x_vrijednost1; // x-vrijednost lijeve "gljive"

Servo servo02;
int servo2Poz;
int servo2PPoz;
int y_pin1=A4;
int y_vrijednost1;

Servo servo03;
int servo3Poz;
int servo3PPoz;
int x_pin2=A2;
int x_vrijednost2;

Servo servo04;
int servo4Poz;
int servo4PPoz;
int y_pin2=A3;
int y_vrijednost2;

Servo servo05;
int servo5Poz;
int servo5PPoz;

Servo servo06;
int servo6Poz;
int servo6PPoz;

int tipka1=12;
int tipka2=13;


void setup() {
// inicijalizacija po prvi put , točnije radnja koja se odvije samo jednom
kada se upali Arduino
pinMode(tipka1,INPUT); // Prepoznavanje tipkala 1 kao ulaz
pinMode(tipka2,INPUT); // Prepoznavanje tipkala 2 kao ulaz

// Učitavanje svih 6 servomotora za daljnje programiranje , te zadavanje
njene početne pozicije.

servo01.attach(3);
servo1PPoz=90;
servo01.write(servo1PPoz);

servo02.attach(5);
servo2PPoz=100;
servo02.write(servo2PPoz);

servo03.attach(6);
servo3PPoz=55;
servo03.write(servo3PPoz);

servo04.attach(9);
servo4PPoz=145;
servo04.write(servo4PPoz);

servo05.attach(10);
servo5PPoz=90;
servo05.write(servo5PPoz);

servo06.attach(11);
servo6PPoz=90;
servo06.write(servo6PPoz);

Serial.begin(9600);
}
void loop() {
// Kod koji se konstantno ponavlja sve dok je arudino pod napajanjem
//Očitvanje stanja sa tipakala (HIGH ili LOW)
int stanje_tipke1=digitalRead(tipka1);
int stanje_tipke2=digitalRead(tipka2);
// Zbog određenih poteškoća sa upravljačkim kontrolerom kao što je
"deadzone", izmijenjene su vrijednost te da budu konstante kada dođu u maksimum
rezolucije ili u  minimum

// očitavanje x-vrijednosti1
x_vrijednost1=analogRead(x_pin1);
if(x_vrijednost1>=330 && x_vrijednost1 <=470) {
 x_vrijednost1=345;
 // Vrijednosti lijeve ''gljive'' x-os
}
if(x_vrijednost1>=175 && x_vrijednost1 <=330) {
 x_vrijednost1=345;
}
if(x_vrijednost1<=5){
 x_vrijednost1=0;
}
if(x_vrijednost1>=680){
 x_vrijednost1=700;
}

// Očitavanje y-vrijednosti1
y_vrijednost1=analogRead(y_pin1);
if(y_vrijednost1>=280 && y_vrijednost1 <=405) {
 y_vrijednost1=345;
}
 // Vrijednosti lijeve ''gljive'' y-os
if(y_vrijednost1<=5){
 y_vrijednost1=0;
}
if(y_vrijednost1>=670){
 y_vrijednost1=700;
}

// Očitavanje x-vrijednosti2
x_vrijednost2=analogRead(x_pin2);
if(x_vrijednost2>=330 && x_vrijednost2 <=370) {
 x_vrijednost2=345;
}
if(x_vrijednost2<=3){
 // Vrijednosti desne ''gljive'' x-os
 x_vrijednost2=0;
}
if(x_vrijednost2>=670){
 x_vrijednost2=700;
}

// Očitavanje y-vrijednosti2
y_vrijednost2=analogRead(y_pin2);
if(y_vrijednost2>=280 && y_vrijednost2 <=405) {
 y_vrijednost2=345;
}
if(y_vrijednost2<=5){
 // Vrijednosti desne ''gljive'' y-os
 y_vrijednost2=0;
}
if(y_vrijednost2>=670){
 y_vrijednost2=700;
}

// Ovaj uvjet govori da kada tipkala nisu pritisnuta,
// Mogu funkcionirati samo 4 motora
if(stanje_tipke1 ==LOW && stanje_tipke2 ==LOW) {
if(x_vrijednost1 >=500 && servo1Poz<=180 ) {
 servo1Poz=servo1PPoz+1;
 servo1PPoz=servo1Poz;
 delay(15);
}
if(x_vrijednost1<=200 && servo1Poz>=0) {
 servo1Poz=servo1PPoz-1;
 servo1PPoz=servo1Poz;
 delay(15);
}
else {
 servo1Poz=servo1PPoz;
}
if(y_vrijednost1 >=550 && servo2Poz<180) {
 servo2Poz=servo2PPoz+1;
 servo2PPoz=servo2Poz;
 delay(10);
}
else {
 servo2Poz=servo2PPoz;
}
if(y_vrijednost1<=250 && servo2Poz>0) {
 servo2Poz=servo2PPoz-1;
 servo2PPoz=servo2Poz;
  delay(10);
}
if(servo2Poz<=50) {
 servo2Poz=50;
 servo2PPoz=servo2Poz;
}
if(servo2Poz>=140) {
 servo2Poz=140;
 servo2PPoz=servo2Poz;
}
else {
 servo2Poz=servo2PPoz;
}
if(x_vrijednost2 >=500 && servo3Poz<180) {
 servo3Poz=servo3PPoz+1;
 servo3PPoz=servo3Poz;
 delay(10);
}
else {
 servo3Poz=servo3PPoz;
}
if(x_vrijednost2<=200 && servo3Poz>0) {
 servo3Poz=servo3PPoz-1;
 servo3PPoz=servo3Poz;
 delay(10);
}
else {
 servo3Poz=servo3PPoz;
}
if(y_vrijednost2 >=500 && servo4Poz<180) {
 servo4Poz=servo4PPoz+1;
 servo4PPoz=servo4Poz;
 delay(10);
}
else {
 servo4Poz=servo4PPoz;
}
if(y_vrijednost2<=200 && servo4Poz>0) {
 servo4Poz=servo4PPoz-1;
 servo4PPoz=servo4Poz;
 delay(10);
}
if(servo4Poz<=8) {
 servo4Poz=8;
 servo4PPoz=servo4Poz;
}
else {
 servo4Poz=servo4PPoz;
 }
}
// Uvjet govori da kada je ili tipkalo 1 ili tipkalo 2 pritisnuto,
// možemo upravljati sa preostala 2 servomotora
if(stanje_tipke1==HIGH) {
if(x_vrijednost1 >=500 && servo5Poz<180) {
 servo5Poz=servo5PPoz+1;
 servo5PPoz=servo5Poz;
 delay(15);
}
if(x_vrijednost1<=200 && servo5Poz>0) {
 servo5Poz=servo5PPoz-1;
 servo5PPoz=servo5Poz;
 delay(15);
}
else {
 servo5Poz=servo5PPoz;
}
}
if(stanje_tipke2==HIGH ) {
if(x_vrijednost2 >=500 && servo6Poz<180) {
 servo6Poz=servo6PPoz+1;
 servo6PPoz=servo6Poz;
 delay(10);
}
else {
 servo6Poz=servo6PPoz;
}
if(x_vrijednost2<=200 && servo6Poz>0) {
 servo6Poz=servo6PPoz-1;
 servo6PPoz=servo6Poz;
 delay(10);
}
else {
 servo6Poz=servo6PPoz;
  }
}

// Nakon očitavanja i pretvaranja vrijednosti koje su očitane sa
upravljačkim kontrolerom te
// pretvorene u jedinicu u kojoj servomotor funkcionira ( U ovom slučaju
kut zakreta)
// možemo ih zapisati pomoću funkcije "write"
servo01.write(servo1Poz);
servo02.write(servo2Poz);
servo03.write(servo3Poz);
servo04.write(servo4Poz);
servo05.write(servo5Poz);
servo06.write(servo6Poz);

// provjera je li servo motor 6 zaista radi
Serial.println(servo6Poz);
}
