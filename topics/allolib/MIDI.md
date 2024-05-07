# Basic MIDI Input Program
The following is based on the tutorial file *midiIn.cpp* which can be found under [allolib/examples/io/midiIn.cpp](https://github.com/AlloSphere-Research-Group/allolib/blob/master/examples/io/midiIn.cpp) 

Let's begin by taking a look at the main function:

```
#include <stdio.h>
#include "al/io/al_MIDI.hpp"
using namespace al;
int main() {
  RtMidiIn RtMidiIn;

  // Check available ports vs. specified
  unsigned portToOpen = 0;
  unsigned numPorts = RtMidiIn.getPortCount();

  if (portToOpen >= numPorts) {
    printf("Invalid port specifier!\n");
  }

  try {
    // Print out names of available input ports
    for (unsigned i = 0; i < numPorts; ++i) {
      printf("Port %u: %s\n", i, RtMidiIn.getPortName(i).c_str());
    }

    // Open the port specified above
    RtMidiIn.openPort(portToOpen);
  } catch (RtMidiError &error) {
    error.printMessage();
    return 1;
  }
  // Set our callback function.  This should be done immediately after
  // opening the port to avoid having incoming messages written to the
  // queue instead of sent to the callback function.
  RtMidiIn.setCallback(&midiCallback);

  // Don't ignore sysex, timing, or active sensing messages.
  RtMidiIn.ignoreTypes(false, false, false);

  printf("\nReading MIDI input ... press <enter> to quit.\n");
  getchar();
}
```

All this code does, is attempt to open MIDI connection with a connected device. The try block is handy because it'll print out an error instead of just crashing if there is something wrong - for example your MIDI device not being connected properly

**Note:** On my version of Windows at least, the program will immediately terminate - ignoring ```getchar()```. A simple workaround would be to create an empty AlloLib app that has a window. The window will make the app stay alive and thus you can read MIDI messages

The second part of this application is the ```midiCallback``` function, which gets called every time your computer receives a MIDI input:
```
void midiCallback(double deltaTime, std::vector<unsigned char> *msg, void *userData) {
  unsigned numBytes = msg->size();

  if (numBytes > 0) {
    // The first byte is the status byte indicating the message type
    unsigned char status = msg->at(0);

    printf("%s: ", MIDIByte::messageTypeString(status));

    // Check if we received a channel message
    if (MIDIByte::isChannelMessage(status)) {
      unsigned char type = status & MIDIByte::MESSAGE_MASK;
      unsigned char chan = status & MIDIByte::CHANNEL_MASK;

      // Here we demonstrate how to parse to common channel messages
      switch (type) {
        case MIDIByte::NOTE_ON:
          printf("Note %u, Vel %u", msg->at(1), msg->at(2));
          break;

        case MIDIByte::NOTE_OFF:
          printf("Note %u, Vel %u", msg->at(1), msg->at(2));
          break;

        case MIDIByte::PITCH_BEND:
          printf("Value %u",
                 MIDIByte::convertPitchBend(msg->at(1), msg->at(2)));
          break;

        // Control messages need to be parsed again...
        case MIDIByte::CONTROL_CHANGE:
          printf("%s ", MIDIByte::controlNumberString(msg->at(1)));
          switch (msg->at(1)) {
            case MIDIByte::MODULATION:
              printf("%u", msg->at(2));
              break;
          }
          break;
        default:;
      }

      printf(" (MIDI chan %u)", chan + 1);
    }

    printf("\n");

    printf("\tBytes = ");
    for (unsigned i = 0; i < numBytes; ++i) {
      printf("%3u ", (int)msg->at(i));
    }
    printf(", stamp = %g\n", deltaTime);
  }
}
```

The code itself is well commented and pretty self-explanatory. One of the key things to understand is the ```msg``` parameter. This is what the MIDI device sent to your computer and includes which note was played, which can be accessed by writing ```msg->at(0)```
You can now use this note to play your sounds with AlloLib.

In the switch statement, you will see the 2 most important cases: ```NOTE_ON``` and ```NOTE_OFF```, which will trigger whenever a note is pressed down or released respectively.

## Custom callback arguments
Since we set the callback function in ```main``` with ```RtMidiIn.setCallback(&midiCallback);```, you might wonder how we can pass our own information to the callback function.

Notice that ```midiCallBack``` takes a ```void* userData``` parameter. The fact that it's a ```void*``` basically means that it can be of any type we like!

```RtMidiIn.setCallback``` takes an optional second argument that will be passed into the userData parameter of the callback function.

Since the callback function can only take 1 userData argument, we need to utilize the power of ```void*``` if we want to pass multiple values into the callback function. One way to do this is to declare a struct/class that holds whatever information you want to pass:

An example could be: 
```
struct CallbackData
{
    SynthGUIManager<SineEnv> *synthManager;
    std::string foo;
};
```
Now, we can pass 2 variables into the callback function as such in main:
```
int main(){
    SynthGUIManager<SineEnv> synthManager{"SineEnv_Piano"};
    CallbackData callbackData;
    callbackData.synthManager = &synthManager;
    callbackData.foo = "bar";

    RtMidiIn.setCallback(&midiCallback, &callbackData);
    ...
}


```
And then inside ```midiCallback``` you can cast the ```void*``` to a CallbackData in order to retrieve your original arguments:
```
void midiCallback(double deltaTime, std::vector<unsigned char> *msg, void *userData) {
    CallbackData *data = static_cast<CallbackData *>(userData);
    SynthGUIManager<SineEnv> *synthManager = data->synthManager;
    std::string foo = data->foo;
    ...
}
```


