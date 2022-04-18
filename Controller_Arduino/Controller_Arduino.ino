const int button_pin = 2;

const int horizontal_pin = 1;
const int vertical_pin = 0;
const int trigPin = 11;
const int echoPin = 6;

long duration;
int distance;

String output_data = "";

void setup() {
  // put your setup code here, to run once:
  pinMode(button_pin, INPUT);
  pinMode(trigPin, OUTPUT); 
  pinMode(echoPin, INPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
 // Clears the trigPin
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  // Calculating the distance
  distance = duration * 0.034 / 2;
  // Prints the distance on the Serial Monitor

 
 output_data = "[";
 add_data_to_output(analogRead(horizontal_pin));
 add_data_to_output(analogRead(vertical_pin));
 add_data_to_output(digitalRead(button_pin));
 add_data_to_output (distance);
 output_data += "]";
 

 
 Serial.print(output_data);
 
}
void add_data_to_output(int data){
  output_data += data;
  output_data += ",";
}
