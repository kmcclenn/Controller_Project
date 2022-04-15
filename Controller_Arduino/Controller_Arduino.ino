const int button_pin = 2;

const int horizontal_pin = 1;
const int vertical_pin = 0;

String output_data = "";

void setup() {
  // put your setup code here, to run once:
  pinMode(button_pin, INPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
 output_data = "[";
 add_data_to_output(analogRead(horizontal_pin));
 add_data_to_output(analogRead(vertical_pin));
 add_data_to_output(digitalRead(button_pin));
 output_data += "]";
 Serial.print(output_data);
 
}
void add_data_to_output(int data){
  output_data += data;
  output_data += ",";
}
