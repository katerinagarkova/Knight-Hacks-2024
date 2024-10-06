#include "ESP32Servo.h"
#include <math.h>

Servo servoL;
Servo servoR;

//SERVO STUFF
int pos1 = 90;
int pos2 = 0;
int servoP1 = 2;
int servoP2 = 13;

//MOISTURE SENSOR
int val = 0;
const int soilPin = 27;
const int soilPower = 14; //D5

//TEMPERATURE SENSOR
const int B = 4275;
const int R0 = 100000;
const int pinTempSensor = 32;

//LIGHT SENSOR
const int lightPin = 33;

void setup() {
  //SERVO SETUP
  servoL.attach(servoP1);
  servoR.attach(servoP2);

  //MOISTURE SETUP
  Serial.begin(9600); //open serial over USB to send instructions
  pinMode(soilPower, OUTPUT);
  digitalWrite(soilPower, LOW);
}

void loop() {

  Serial.print("Soil Moisture = ");
  Serial.println(readSoil()); //get soil moisture value from function and print it
  //TEMPERATURE STUFF
  int a  = analogRead(pinTempSensor);

  float R = 1023.0/((float)a-1467)-1.0;
  R = R0*R;

  float temperature = 1.0/(log(R/R0)/B+1/298.15)-273.15; // convert to temperature via datasheet

  Serial.print("temperature = ");
  Serial.println(temperature);

  //LIGHT VALUES
  int value = analogRead(lightPin);
  Serial.print("Light Sensor = ");
  Serial.println(value);

  delay(1000); //takes a reading every second //just to test make it much less freq after

  if((val < 3000) || 0){
    //SOIL LOOP
    for(pos1=45;pos1<=150;pos1+=1){
      servoL.write(pos1);
      delay(15);
    }
    delay(10000);
    for(pos1=150;pos1>=45;pos1-=1){
      servoL.write(pos1);
      delay(15);
    }
  }
}

int readSoil(){
  digitalWrite(soilPower, HIGH); //turn D5 on
  delay(10); //wait 10 miliseconds
  val = analogRead(soilPin); //Reads the SIG analog value from sensor
  digitalWrite(soilPower, LOW); //turn D5 off
  return val; //send current moisture value
}


