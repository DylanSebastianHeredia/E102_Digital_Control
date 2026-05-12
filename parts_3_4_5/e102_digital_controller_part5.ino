/* 
Step response of PI control RC circuit after  
a switched 2.5V step reference input.  
The circuit: 
* switch connected from pin 2 to GND 
* input Vin from pin 9  
* output of circuit read at analog pin A0   
*/ 
//PIN SETTINGS 
const int yPin = A0;  // Analog read pin   
const int uPin = 9;    // Analog write pin (PWM) 

const int switchPin = 2;     // input pin for the switch  
boolean switchVal = HIGH;    // declare initial switch pin state 
 
// Parameter Settings 
int time = 0;  // initialize time 
int uVal = 0;  // initialize control input 
const float Kp = 2.34923; 
const float Ki = 0.85505;
float ref = 0; 
 
// Initial Values for internal signals 
float y=0; 
float u=0; 
float e=0; 
float u_prev=0;
float e_prev=0;
const float T=0.1; // Sample time
 
void setup() {

  pinMode(switchPin, INPUT);
  digitalWrite(switchPin, HIGH);

  pinMode(uPin, OUTPUT);
  analogWrite(uPin, 0);

  Serial.begin(9600);

  delay(20000);
}
 
void loop() {    
    ref = 2.5;

// READ CIRCUIT OUTPUT 
    int sensorVal = analogRead(yPin); 
    // convert to volts 
    y=sensorVal*(5.0/1023.0); 
    // calculate error 
    e=ref-y; 
       
  // CONTROLLER 
     
     u = u_prev + (Kp + Ki*T)*e - Kp*e_prev;

    e_prev = e;
    u_prev = u; 

     // check that control signal is in range 
     if (u>5) 
     { 
       u=5; 
     } 
     if (u<0) 
     { 
     u=0; 
     } 

      
  // WRITE CIRCUIT INPUT  
     uVal = (int)(u * 255.0 / 5.0); 
     analogWrite(uPin,uVal); 
   
 // print the results to the serial monitor:  
  Serial.print(time++); 
  Serial.print (" "); 
  Serial.print (y); 
  Serial.print (" "); 
  Serial.println(u); 
   
  // WAIT FOR NEXT SAMPLE 
  delay(100); //sample frequency 10Hz 
  switchVal = digitalRead(switchPin);  // read switch state 
} 
