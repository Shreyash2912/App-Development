# Experiment 3: Setting up Android Studio and Creating a Simple Counter App

## Aim
To set up *Android Studio* and create a simple *Counter App* that can *increase, decrease, and reset* a number using buttons.

## Steps Followed
1. Installed *Android Studio* and created a new project with an *Empty Activity*.
2. Named the project CounterApp and selected *Java* as the programming language.
3. Designed the *UI* in activity_main.xml:
   - Added a TextView to display the count.
   - Added three `Button`s: Increase, Decrease, Reset.
   - Used ConstraintLayout and TableLayout for alignment.
4. Implemented the logic in MainActivity.java:
   - Initialized TextView and `Button`s using findViewById.
   - Set OnClickListener for each button:
     - *Increase:* Adds 1 to the current value.
     - *Decrease:* Subtracts 1 (if value > 0).
     - *Reset:* Sets the value to 0.
5. Tested the app on an *Android emulator* or *real device* to ensure buttons work correctly.


## Source Code
- [MainActivity.java](./MainActivity.java)  
- [activity_main.xml](./activity_main.xml)  

## Expected Output
- *Initial screen:* Displays 0 in the TextView.  
- *Press "Increase":* Count increases by 1 each time.  
- *Press "Decrease":* Count decreases by 1 (minimum 0).  
- *Press "Reset":* Count resets to 0.