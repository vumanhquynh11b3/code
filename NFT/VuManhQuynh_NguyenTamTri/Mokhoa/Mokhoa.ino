#include <Stepper.h>
#include <EEPROM.h>
#include <SPI.h>
#include <MFRC522.h>
#include <SoftwareSerial.h>

SoftwareSerial ArduinoUno(7,6);//Rx ; TX
boolean match = false;
boolean programMode = false;
int successRead; 
int flag = 0;
byte storedCard[4]; // Stores an ID read from EEPROM
byte readCard[4]; // Stores scanned ID read from RFID Module
byte masterCard[4]; // Stores master card's ID read from EEPROM
#define SS_PIN 10
#define RST_PIN 9
MFRC522 mfrc522(SS_PIN, RST_PIN); // Create MFRC522 instance.


const float STEPS_PER_REV = 32;              //Steps for one revolution
const float GEAR_RED = 64;                   //Gear ratio
const float FULL = STEPS_PER_REV * GEAR_RED; //Steps per rev * gear ration = one full turn for motor shaft

int StepsRequired;
Stepper steppermotor(STEPS_PER_REV, 2, 4, 3, 5);


void setup() {
  
  Serial.begin(115200);   // Initiate a serial communication
 ArduinoUno.begin(9600);

  SPI.begin();          // Initiate  SPI bus
  mfrc522.PCD_Init();   // Initiate MFRC522
  
  if (EEPROM.read(1) != 1) {
    // Look EEPROM if Master Card defined, EEPROM address 1 holds if defined
    Serial.println("Không có thẻ quản trị viên nào!!!");
    // Khi không có Master Card trong EEPROM
    Serial.println("Quét thẻ để xác định là thẻ quản trị viên");
    delay(1000);
    do {
      successRead = getID();
      // gán successRead bằng 1 when we get read from reader otherwise 0
    }
    while (!successRead);
    //Chương trình sẽ không tiếp tục nếu đọc không thành công
    for (int j = 0; j < 4; j++) {
      // Lặp 4 lần
      EEPROM.write(2 + j, readCard[j]);
      // Ghi UID đã quét vào EEPROM, bắt đầu từ vị trí thứ 3
    }
    EEPROM.write(1, 1); //Write to EEPROM we defined Master Card.
    Serial.println("Thẻ quản trị được xác định");
  }
  Serial.println("UID của quản trị viên");
  for (int i = 0; i < 4; i++) { 
    masterCard[i] = EEPROM.read(2 + i); // Write it to masterCard
    Serial.print(masterCard[i], HEX); //Master Card only view in serial
    Serial.println("Waiting PICCs to be scanned :)");
  }
  //WAITING TO SCAN THE RFID CARDS:
  Serial.println("");
  Serial.println("Hãy quét thẻ . . . :)");
  delay(1000);
}

int getID() {
  if (! mfrc522.PICC_IsNewCardPresent()) {
    //If a new PICC placed to RFID reader continue
    return 0;
  }
  if (! mfrc522.PICC_ReadCardSerial()) {
    //Since a PICC placed get Serial and continue
    return 0;
  }
  // There are Mifare PICCs which have 4 byte or 7 byte UID care if you use 7 byte PICC
  // I think we should assume every PICC as they have 4 byte UID
  // Until we support 7 byte PICCs
  Serial.println("Đang quét UID....");
  delay(1000);
  for (int i = 0; i < 4; i++) {
    readCard[i] = mfrc522.uid.uidByte[i];
    Serial.print(readCard[i], HEX);
  }
  Serial.println("");
  mfrc522.PICC_HaltA(); // Stop reading
  return 1;
}
boolean isMaster(byte test[]) {
  if (checkTwo(test, masterCard))
    return true;
  else
    return false;
}

boolean checkTwo (byte a[], byte b[]) {
  if (a[0] != NULL)
    // Make sure there is something in the array first
    match = true;
  // Assume they match at first
  for (int k = 0; k < 4; k++) {
    // Loop 4 times
    if (a[k] != b[k])
      // IF a != b then set match = false, one fails, all fail
      match = false;
  }
  if (match) {
    // Check to see if if match is still true
    return true;
  } else  {
    return false;
  }
}
boolean findID(byte find[]) {
  int count = EEPROM.read(0);
  // Read the first Byte of EEPROM that
  for (int i = 1; i <= count; i++) {
    // Loop once for each EEPROM entry
    readID(i);
    // Read an ID from EEPROM, it is stored in storedCard[4]
    if (checkTwo(find, storedCard)) {
      // Check to see if the storedCard read from EEPROM
      return true;
      break; // Stop looking we found it
    } else {
      // If not, return false
    }
  }
  return false;
}
void readID(int number) {
  int start = (number * 4) + 2;
  // Figure out starting position
  for (int i = 0; i < 4; i++) {
    // Loop 4 times to get the 4 Bytes
    storedCard[i] = EEPROM.read(start + i);
    // Assign values read from EEPROM to array
  }
}
void deleteID(byte a[]) {
  if (!findID(a)) {
    // Before we delete from the EEPROM, check to see if we have this card!
    failedWrite(); // If not
  } else {
    int num = EEPROM.read(0);
    // Get the numer of used spaces, position 0 stores the number of ID cards
    int slot;
    // Figure out the slot number of the card
    int start;
    // = (num * 4) + 6; // Figure out where the next slot starts
    int looping;
    // The number of times the loop repeats
    int j;
    int count = EEPROM.read(0);
    // Read the first Byte of EEPROM that stores number of cards
    slot = findIDSLOT(a);
    //Figure out the slot number of the card to delete
    start = (slot * 4) + 2;
    looping = ((num - slot) * 4);
    num--; // Decrement the counter by one
    EEPROM.write(0, num); // Write the new count to the counter
    for (j = 0; j < looping; j++) {
      // Loop the card shift times
      EEPROM.write(start + j, EEPROM.read(start + 4 + j));
      // Shift the array values to 4 places earlier in the EEPROM
    }
    for (int k = 0; k < 4; k++) {
      //Shifting loop
      EEPROM.write(start + j + k, 0);
    }
    successDelete();
  }
}
//For Failed to add the card:
void failedWrite() {
  Serial.println("Something wrong with Card");
  delay(2000);
}

//For Sucessfully Deleted:
void successDelete() {
  Serial.println("Xóa thành công !!!");
  delay(2000);
}

int findIDSLOT(byte find[]) {
  int count = EEPROM.read(0);
  // Read the first Byte of EEPROM that
  for (int i = 1; i <= count; i++) {
    // Loop once for each EEPROM entry
    readID(i);
    // Read an ID from EEPROM, it is stored in storedCard[4]
    if (checkTwo(find, storedCard)) {
      // Check to see if the storedCard read from EEPROM
      // is the same as the find[] ID card passed
      return i;
      // The slot number of the card
      break;
      // Stop looking we found it
    }
  }
}
//For Sucessfully Added:
void successWrite() {
  Serial.println("Thêm thành công");
  delay(2000);
}

//For Adding card to EEPROM:
void writeID(byte a[]) {
  if (!findID(a)) {
    // Before we write to the EEPROM, check to see if we have seen this card before!
    int num = EEPROM.read(0);
    // Get the numer of used spaces, position 0 stores the number of ID cards
    int start = (num * 4) + 6;
    // Figure out where the next slot starts
    num++;
    // Increment the counter by one
    EEPROM.write(0, num);
    // Write the new count to the counter
    for (int j = 0; j < 4; j++) {
      // Loop 4 times
      EEPROM.write(start + j, a[j]);
      // Write the array values to EEPROM in the right position
    }
    successWrite();
  } else {
    failedWrite();
  }
}
void open() {
if (flag==0)               // Door is locked
    {
      StepsRequired = FULL / 2;                   // Full turn / 2 = Half turn
      steppermotor.setSpeed(1000);
      steppermotor.step(StepsRequired);
      flag=1;
    } else                                        // When door is unlocked 
    {
      StepsRequired = FULL / -2;                  // Thistime we divide full turn with -2 because we want motor turns this time the opposite way
      steppermotor.setSpeed(1000);
      steppermotor.step(StepsRequired);
      flag=0;
      delay(2000);                                 // 2 sec delay

    }
}
void loop() {

  if(ArduinoUno.available()>0){
    ArduinoUno.write(flag);
    delay(1000);
  }

  do {
    successRead = getID(); // sets successRead to 1 when we get read from     reader otherwise 0
    if (programMode) {
      // Program Mode cycles through RGB waiting to read a new card
    } else {
    }
  }
  while (!successRead);
  //the program will not go further while you not get a successful read
  if (programMode) {
    if (isMaster(readCard)) {
      //If master card scanned again exit program mode
      Serial.println("Thoát khỏi chế độ ADMIN");
      delay(1000);
      programMode = false;
      return;
    } else {
      if (findID(readCard)) {
        //Nếu thẻ đã quét đã tồn tại,chương trình sẽ xóa nó
        Serial.println("Đã tồn tại, đang xóa . . .");
        delay(1000);
        deleteID(readCard);
        Serial.println("-----------------------------");
      } else {
        // Nếu thẻ đã quét chưa tồn tại,chương trình sẽ thêm nó
        Serial.println("Đang thêm thẻ ...");
        delay(1000);
        writeID(readCard);
        Serial.println("-----------------------------");
      }
    }
  } else {
    if (isMaster(readCard)) {
      // Nếu ID của thẻ được quét khớp với ID của Master Card, sẽ vào program mode
      programMode = true;
      Serial.println("Chào mừng đến với chế độ Administrator");
      delay(1000);
      int count = EEPROM.read(0);
      // Read the first Byte of EEPROM that
      Serial.print("Có ");
      // stores the number of ID's in EEPROM
      Serial.print(count);
      Serial.print(" thẻ trong EEPROM");
      Serial.println("");
      Serial.println("Quét để THÊM hoặc XÓA");
      Serial.println("-----------------------------");
      delay(1000);
    } else {
      if (findID(readCard)) {
        // If not, see if the card is in the EEPROM
        Serial.println("Chấp nhận quyền truy cập");
        open();
        delay(2000);
      } else {
        // If not, show that the ID was not valid
        Serial.println("Từ chối quyền truy cập");
        delay(1000);
      }

    }
  }
}
