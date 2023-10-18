---
parent: Allolib
grand_parent: Topics
layout: default
title: "Allolib: Scores"
description:  ".synthsequence files"
---

Many of the example programs in {{site.ap}} have a feature where you can record sequences.

For example, when you do [`run.sh tutorials/synthesis/01_SineEnv_Piano.cpp`](https://github.com/AlloSphere-Research-Group/allolib_playground/blob/master/tutorials/synthesis/01_SineEnv_Piano.cpp) you get this control panel:

<img width="509" alt="image" src="https://github.com/ccs-allolib/ccs-allolib.github.io/assets/1119017/e2347a69-589b-4fb5-a97e-71690a7a7fe7">

The part we want to focus on is the part near the bottom:

<img width="492" alt="image" src="https://github.com/ccs-allolib/ccs-allolib.github.io/assets/1119017/e3445730-2732-4f07-bb3d-a53621500163">

This provides a sequencer feature where you can press `Record` and record a sequence of notes
that you play on the keyboard.  You can then play back these sequences.

The sequences are stored in a file with the name you give it, and the extension `.synthsequence`.  They are
stored in a `bin` subdirectory in the same directory where the source code is found.   Under that directory,
you'll find a subdirectory with the same name as the instrument (e.g. `SineEnv`) followed by the suffix `-data`.  

So, for example, for any file under `tutorials/synthesis` that use the instrument name `SineEnv`, the directory will be `tutorials/synthesis/bin/SineEnv-Data` and the files will be `piece1.synthsequence`, `piece2.synthsequence` etc.

Inside this file, you'll find data such as this:

```
@  0   3.5 SineEnv 0.3 260   .011 .2 0.0
@  0   3.5 SineEnv 0.3 510   .011 .2 0.0
@  3.5 3.5 SineEnv 0.3 233   .011 .2 0.0
@  3.5 3.5 SineEnv 0.3 340   .011 .2 0.0
@  3.5 7.5 SineEnv 0.3 710 1, 2 0.0
# etc.
```
 
* The `@` means a command (to play a note).
* The `#` means a comment.
* For lines with `@`, the first four columns are always fixed:
  - Column 1 is `@`
  - Column 2 is the start time for the note
  - Column 3 is the duration of the note
  - Column 4 is the instrument name
* The remaining columns are the parameters of the specific instrument

For example, for the SineEnv instrument, the columns are:
* amplitude
* frequency
* attackTime
* releaseTime
* pan 

You can see this in the C++ source code here, inside the `init` function for the `SineEnv` instrument:

```
    createInternalTriggerParameter("amplitude", 0.3, 0.0, 1.0);
    createInternalTriggerParameter("frequency", 60, 20, 5000);
    createInternalTriggerParameter("attackTime", 1.0, 0.01, 3.0);
    createInternalTriggerParameter("releaseTime", 3.0, 0.1, 10.0);
    createInternalTriggerParameter("pan", 0.0, -1.0, 1.0);
```

You typically see a comment in the file to remind you of what these parameters mean:

```
# SineEnv amplitude frequency attackTime releaseTime pan 
```

# Other symbols

Other symbols have meanings: `>, ::, =, +, t` (documentation is missing for these)

