// E102: Digital Control of RC Circuit
// Sebastian Heredia & Alexis Silva
// dheredia@g.hmc.edu & asilva@g.hmc.edu
// May 11, 2026

/////////////// (Part 8) ///////////////

// Pin Settings
const int yPin = A0;      // Analog read pin
const int uPin = 9;       // Analog write pin (PWM)

// Parameter Settings
int currentTime = 0;      // initialize time
const float uin = 2.5;    // 2.5V input

// Initial Values for internal signals
float y = 0;
float u = 0;
float r = 0; 
float xhat[2] = {0, 0};             // 1x2 Matrix 
float xhat_next[2] = {0, 0};        

// DISCRETE: State-Space matrices. Float for precision (could use double)
float Ad[2][2] = {{0.9512, 0.0442}, {0, 0.8187}};   // 2x2 Matrix
float Bd[2] = {0.0046, 0.1813};                     // 1x2 Matrix 
float Cd[2] = {1.0, 0.0};
// Recall: Dd = 0

// Observer parameters
float K[2]  = {6.5014, 1.2697};      // 1x2 Matrix 
float L[2]  = {0.6651, 2.5080};
float Kr = 8.7711;

/////////////// MAIN CODE ///////////////

void setup() {
  analogWrite(uPin, 0);    // Set LOW initially
  Serial.begin(9600);
  delay(20000);            // Allow time for CoolTerm + capacitors to decharge 
}

void loop() {

  // Allow CoolTerm to settle before logging
  if (currentTime > 10) r = uin;     // Additional settling block, hold 0 until 10sec then send 2.5V
  else r = 0;

  // READ PHYSICAL CIRCUIT OUTPUT
  int sensorVal = analogRead(yPin);
  y = sensorVal * (5.0 / 1023.0);    // Convert to volts

  /////////////// OBSERVER Block ///////////////
  // y_hat
  float yhat = Cd[0] * xhat[0] + Cd[1] * xhat[1];

  // Next state logic. Recall: x[n+1] = Ad*x[n] + Bd*u[n] + L*(y[n] - yhat[n])
  // Error difference junction
  float error = y - yhat;

  // Large summing block before Unit Delay
  xhat_next[0] = Ad[0][0]*xhat[0] + Ad[0][1]*xhat[1] + Bd[0]*u + L[0]*error;
  xhat_next[1] = Ad[1][0]*xhat[0] + Ad[1][1]*xhat[1] + Bd[1]*u + L[1]*error;

  // DT Unit Delay block (1/z)
  xhat[0] = xhat_next[0];
  xhat[1] = xhat_next[1];
  // xhat must be defined for full system loop, Observer code must be before full system

  /////////////// FULL SYSTEM ///////////////
  // Control Input. Recall: u[n] = (Kr*r) - (K*xhat)
  u = (Kr*r) - (K[0]*xhat[0] + K[1]*xhat[1]);

  // Note: Zero-order hold is accounted for by sampling time! delay(100) = 0.1sec

  // Saturation block (0V to 5V)
  if (u > 5.0) u = 5.0; // Max value
  if (u < 0.0) u = 0.0; // Min value
  
  // Note: Plant is accounted for in the physical circuit
  // The state space plant in the simulation is representative of the physical circuit 

  // WRITE CIRCUIT INPUT
  int uVal = u * (255.0 / 5.0);       // For VDD = 5V
  analogWrite(uPin, uVal);            // (Pin, Duty Cycle % from 0-255)

  // print the results to the serial monitor:
  Serial.print(currentTime * 0.1);    // Time [sec]
  Serial.print (" ");
  Serial.print (y);                   // Measured output y(t)
  Serial.print (" ");
  Serial.println (u);                 // Control effort u(t)
  
  currentTime++;
  
  // WAIT FOR NEXT SAMPLE
  delay(100); //sample frequency 10Hz = 1/0.1sec
}



