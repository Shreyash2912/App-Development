# Experiment 8

## Aim
To implement tab-based navigation and drawer navigation in an app, enabling users to switch between screens using both bottom tabs and a side drawer menu.

## Steps Followed
1. Created a new Flutter project.  
2. Designed the *HomeScreen* with Scaffold, AppBar, Drawer, and BottomNavigationBar.  
3. Defined multiple pages: Home, Search (with filter), Settings, and Profile.  
4. Implemented *tab-based navigation* using BottomNavigationBar and _currentIndex state.  
5. Configured *drawer navigation* using Drawer and ListTile items, linking Profile page with Navigator.push.  
6. Added a *search functionality* in the Search page using TextField and filtering a list of items.  
7. Tested the app to ensure smooth navigation and UI consistency.

## Expected Output
1. *Home Screen (Tab-Based & Drawer):*  
   - Displays a centered text: "HOME PAGE".  
   - Accessible via *bottom tab* and *drawer menu*.  

2. *Search Screen (Tab-Based & Drawer):*  
   - Contains a search bar at the top.  
   - Displays a list of items (Books, Pens, Goodies) filtered dynamically as the user types.  
   - Accessible via *bottom tab* and *drawer menu*.  

3. *Settings Screen (Tab-Based & Drawer):*  
   - Displays a centered text: "SETTINGS PAGE".  
   - Accessible via *bottom tab* and *drawer menu*.  

4. *Profile Screen (Drawer Only):*  
   - Opens from the *drawer menu* only.  
   - Displays a centered text: "👤 This is your profile!".  

5. *Navigation:*  
   - *BottomNavigationBar (Tab-Based Navigation):* Switches between Home, Search, and Settings tabs.  
   - *Drawer Navigation:* Switches between Home, Search, Settings, and Profile pages.  
   - Smooth transitions between all screens without app crashes.
     
     The output for this experiment can be accessed [here](output1.png).


## Source Code
The full main Dart code for this experiment can be accessed [here](main.dart).

## Notes
- BottomNavigationBar handles tab-based navigation.  
- Drawer allows navigation to additional screens like Profile.  
- The Search page demonstrates a dynamic list filter.