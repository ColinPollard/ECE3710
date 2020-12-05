#include <AccelStepperWithDistance.h>

// Author: Colin Pollard
// Date: 12/3/2020
// Physical Pong arduino code. Interprets a series of bytes from serial, and parses them into stepper motor positions.

#define X_STEP_PIN         54
#define X_DIR_PIN          55
#define X_ENABLE_PIN       38
#define X_MIN_PIN           3 // Second to blue
#define X_MAX_PIN           2 // Closest to the blue connector

#define Y_STEP_PIN         60
#define Y_DIR_PIN          61
#define Y_ENABLE_PIN       56
#define Y_MIN_PIN          14 // Third to blue
#define Y_MAX_PIN          15 // Fourth to blue

#define Z_STEP_PIN         46
#define Z_DIR_PIN          48
#define Z_ENABLE_PIN       62
#define Z_MIN_PIN          18
#define Z_MAX_PIN          19

#define E_STEP_PIN         26
#define E_DIR_PIN          28
#define E_ENABLE_PIN       24

// Speed settings
#define paddleHomingSpeed -2000
#define ballXHomingSpeed -2000
#define ballYHomingSpeed -2000

// Boundaries in steps
#define paddleMax 5135
#define ballXMax 8750
#define ballYMax 6220
#define paddleMid (paddleMax / 2)
#define ballXMid (ballXMax / 2)
#define ballYMid (ballYMax / 2)

AccelStepperWithDistance Paddle1(1, X_STEP_PIN, X_DIR_PIN);
AccelStepperWithDistance Paddle2(1, Y_STEP_PIN, Y_DIR_PIN);
AccelStepperWithDistance BallY(1, Z_STEP_PIN, Z_DIR_PIN);
AccelStepperWithDistance BallX(1, E_STEP_PIN, E_DIR_PIN);

int8_t Paddle1Pos = 0;
int8_t Paddle2Pos = 0;
int8_t BallXPos = 0;
int8_t BallYPos = 0;

int serialState = 0;
byte serialIn;

// This function scales the serial input from -127 to 127 to a long value in steps
double scalePaddle(int8_t input)
{
  // Account for overflow 
  if(input == 0)
    return paddleMid;
    
  return paddleMid + (paddleMid * (double(input) / 127));
}

// Scale serial input to long value
double scaleBallX(int8_t input)
{
  if(input == 0)
    return ballXMid;

  return ballXMid + (ballXMid * (double(input) / 127));
}

// Scale serial input to long value
double scaleBallY(int8_t input)
{
  if(input == 0)
    return ballYMid;

  return ballYMid + (ballYMid * (double(input) / 127));
}

// This function manually moves each axis to the endstop, sets endstop as Potition 0.
void homePong()
{
  digitalWrite(X_ENABLE_PIN, LOW);
  digitalWrite(Y_ENABLE_PIN, LOW);
  digitalWrite(Z_ENABLE_PIN, LOW);
  digitalWrite(E_ENABLE_PIN, LOW);

  Serial.println("Homing Paddle1");
  Paddle1.setSpeed(paddleHomingSpeed);
  while(!digitalRead(X_MAX_PIN))
   Paddle1.runSpeed(); 
  Paddle1.setSpeed(0);
  Paddle1.setCurrentPosition(0);

  Serial.println("Homing Paddle2");
  Paddle2.setSpeed(paddleHomingSpeed);
  while(!digitalRead(X_MIN_PIN))
    Paddle2.runSpeed();
  Paddle2.setSpeed(0);
  Paddle2.setCurrentPosition(0);

  Serial.println("Homing Ball Y");
  BallY.setSpeed(ballYHomingSpeed);
  while(!digitalRead(Y_MIN_PIN))
    BallY.runSpeed();
  BallY.setSpeed(0);
  BallY.setCurrentPosition(0);
  
  Serial.println("Homing Ball X");
  BallX.setSpeed(ballXHomingSpeed);
  while(!digitalRead(Y_MAX_PIN))
  BallX.runSpeed();
  BallX.setSpeed(0);
  BallX.setCurrentPosition(0);

  // Ball will get lost if we go straight to loop from here, need to move out first
  BallX.moveTo(500);
  BallX.runToPosition();
  
  Serial.println("Finished homing.");
  
}

void setup() {
  Serial.begin(500000,SERIAL_8N1); 
  Serial.println("Starting.");
  
  // Configure Endstops
  pinMode(X_MAX_PIN, INPUT_PULLUP);
  pinMode(X_MIN_PIN, INPUT_PULLUP);
  pinMode(Y_MAX_PIN, INPUT_PULLUP);
  pinMode(Y_MIN_PIN, INPUT_PULLUP);
  
  // Configure enables
  pinMode(X_ENABLE_PIN, OUTPUT);
  pinMode(Y_ENABLE_PIN, OUTPUT);
  pinMode(Z_ENABLE_PIN, OUTPUT);
  pinMode(E_ENABLE_PIN, OUTPUT);
  
  // Configure Stepper Motors
  Paddle1.setMaxSpeed(2000);
  Paddle1.setAcceleration(5000);
  Paddle1.setMicroStep(1);
  Paddle1.setStepsPerRotation(200);
  Paddle1.setDistancePerRotation(40);

  Paddle2.setMaxSpeed(2000);
  Paddle2.setAcceleration(5000);
  Paddle2.setMicroStep(1);
  Paddle2.setStepsPerRotation(200);
  Paddle2.setDistancePerRotation(40);
  
  BallX.setMaxSpeed(2000);
  BallX.setAcceleration(5000);
  BallX.setMicroStep(1);
  BallX.setStepsPerRotation(200);
  BallX.setDistancePerRotation(40);

  BallY.setMaxSpeed(2000);
  BallY.setAcceleration(5000);
  BallY.setMicroStep(1);
  BallY.setStepsPerRotation(200);
  BallY.setDistancePerRotation(40);
  
  // Home axis
  homePong();

  Serial.println("Done with homing. Moving onto loop.");
}

void loop() {
  //delay(100);
  //Serial.println("Current State: " + String(serialState));
  
  // Set target positions.
  if (Serial.available() > 0)
  {
    int serialIn = Serial.read();
    
    if (serialIn > 127){
      serialIn = serialIn - 256;
    }  
    
    // Serial.println("Read Byte: " + String(serialIn));
    
    // Check for starting bit, set the state to zero.
    if(serialIn == -128)
    {
      serialState = 0;
      // Serial.println("Start Byte");
    }
    
    // Paddle1 receiving
    else if(serialState == 1)
    {
      Paddle1Pos = serialIn;
      // Serial.println("Paddle1");
      // Serial.println("Paddle1 Scaled Position: " + String(scalePaddle(Paddle1Pos)));
    }
    
    // Paddle2 receiving
    else if(serialState == 2)
    {
      Paddle2Pos = serialIn;
      // Serial.println("Paddle2");
    }
    
    // BallX receiving
    else if(serialState == 3)
    {
      BallXPos = serialIn;
      // Serial.println("BallX");
    }
    
    // BallY receiving
    else if(serialState == 4)
    {
      BallYPos = serialIn;
      // Serial.println("BallY");
    }
    
   else
      return;
      
    // Increment serialState
    serialState++;
  }

  /*
  Serial.println("Paddle1: " + String(scalePaddle(Paddle1Pos)));
  Serial.println("Paddle2: " + String(scalePaddle(Paddle2Pos)));
  Serial.println("Ball X: " + String(scaleBallX(BallXPos)));
  Serial.println("Ball Y: " + String(scaleBallY(BallYPos)));
  */
  // Set desired position
  Paddle1.moveTo(scalePaddle(Paddle1Pos));
  Paddle2.moveTo(scalePaddle(Paddle2Pos));
  BallX.moveTo(scaleBallX(BallXPos));
  BallY.moveTo(scaleBallY(BallYPos));
  
  // Continuously drive motors to position
  Paddle1.run();
  Paddle2.run();
  BallX.run();
  BallY.run();
}
