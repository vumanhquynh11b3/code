#include <Wire.h>

void setup() {
  Serial.begin(9600);
  Wire.begin(21, 22);      /* join i2c bus with SDA=D1 and SCL=D2 of NodeMCU */
}

void loop() {
  Wire.beginTransmission(8);
  Wire.write(3);  /* sends hello string */
  Wire.endTransmission();  /* stop transmitting */
  Wire.requestFrom(8, 18); /* request & read data of size 13 from slave */
  while (Wire.available()) {
    char c = Wire.read();
    Serial.print(c);
  }
}
