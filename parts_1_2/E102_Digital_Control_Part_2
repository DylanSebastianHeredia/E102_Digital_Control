// E102: Digital Control of RC Circuit
// Sebastian Heredia & Alexis Silva
// dheredia@g.hmc.edu & asilva@g.hmc.edu
// May 8, 2026

/*
Step response of RC circuit after
a switched 2.5V step reference input.

The circuit:
* switch connected from pin 2 to GND
* input Vin from pin 9
* output of circuit read at analog pin A0
*/

// PIN SETTINGS
const int yPin = A0;      // Analog read pin
const int uPin = 9;       // Analog write pin (PWM)
// const int switchPin = 2;  // input pin for the switch
// boolean switchVal = HIGH; // declare initial switch pin state

// Parameter Settings
int currentTime = 0;             // initialize time
const float uin = 2.5;    // 2.5V input

// Initial Values for internal signals
float y = 0;
float uCurrent = 0;

void setup() {
  // pinMode(switchPin, INPUT);     // set switch pin to input mode
  // digitalWrite(switchPin, HIGH); // initialize to start with pull up voltage
  analogWrite(uPin, 0);             // Set LOW initially
  Serial.begin(9600);
  delay(20000);                      // Allow time for CoolTerm
}

void loop() {
  //WAIT FOR SWITCH
  /*
  while(switchVal == HIGH)  // repeat this loop until switch is turned on
  {                         // (switchVal will go LOW when switch is turned on)
  analogWrite(uPin,0);
  switchVal = digitalRead(switchPin); // read switch state
  }
  */
  if (currentTime > 10) {
    uCurrent = uin;
  } 
  else {
    uCurrent = 0;
  }
  // WRITE CIRCUIT INPUT
  int uVal = uCurrent * (255. / 5.0);
  analogWrite(uPin,uVal);

  // READ CIRCUIT OUTPUT
  int sensorVal = analogRead(yPin);

  // convert to volts
  y = sensorVal * (5.0 / 1023.0);

  // print the results to the serial monitor:
  Serial.print(currentTime);
  Serial.print (" ");
  Serial.println (y);
  
  currentTime++;                      // Increment
  // WAIT FOR NEXT SAMPLE
  delay(100); //sample frequency 10Hz
  // switchVal = digitalRead(switchPin); // read switch state
}
