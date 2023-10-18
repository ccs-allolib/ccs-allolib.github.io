---
parent: Allolib
grand_parent: Topics
layout: default
title: "Allolib: Basic Code Structure"
description:  "The parts of a typical allolib playground program"
---

The example files in {{site.ap}} have a typical structure; understanding this big picture structure can be helpful
when getting started.

1. `#include` and `using namespace ...` statements, plus global variables and utility functions
2. definition of an instrument, e.g. `class SineEnv : public SynthVoice {`
3. definition of an app, e.g. `class MyApp : public App {`
4. a main program, e.g. `int main() {`

For example, here's [`tutorials/synthesis/01_SineEnv_Piano.cpp`](https://github.com/AlloSphere-Research-Group/allolib_playground/blob/master/tutorials/synthesis/01_SineEnv_Piano.cpp), with the last three of these sections "collapsed" in VSCode.  The first part doesn't completely appear on the screen.

<img width="891" alt="image" src="https://github.com/ccs-allolib/ccs-allolib.github.io/assets/1119017/2db1d0bb-f2df-421e-8031-da94a6aeb8b5">

Here are some more explanations of each of these sections.

# 1. `#include` and `using namespace ...`

# 2. Define instrument (`SynthVoice`)

* header file for SynthVoice: [`allolib/include/al/scene/al_SynthVoice.hpp`](https://github.com/AlloSphere-Research-Group/allolib/blob/master/include/al/scene/al_SynthVoice.hpp)
* [documentation for `SynthVoice`](https://allosphere-research-group.github.io/allolib-doc/classal_1_1_synth_voice.html)

# 3. Define `App` (user interface)

We typically define a subclass of `App`, e.g. called `MyApp` which provides a user interface to 
interact with our instrument.

The first line looks like this, and indicates that `MyApp` inherits from `App` which is the `App` class
of Allolib.  For documentation of this, you can see:
* header file source code in file [`allolib/include/al/app/al_App.hpp`](https://github.com/AlloSphere-Research-Group/allolib/blob/master/include/al/app/al_App.hpp)
* [allolib documentation for App](https://allosphere-research-group.github.io/allolib-doc/classal_1_1_app.html)


```cpp
class MyApp : public App {
```


# 4. a main program

The `main` program is typically not modified unless you want to:
* change the size of the initial window that appears on the screen
* change the default audio parameters: bit rate, block size, number of channels, number of audio inputs.

```cpp
int main() {
  // Create app instance
  MyApp app;
  
  // Set window size
  app.dimensions(1200, 600);
  
  // Set up audio
  app.configureAudio(48000., 512, 2, 0);
  app.start();
  return 0;
}
```
