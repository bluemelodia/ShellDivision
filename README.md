# Testudo
```
Functionality: I built a two-player strategy game, Shell Division, on both iOS (using XCode) and Android (using Android Studio). The player takes control of either the Snapping Turtle or Sea Turtle species, and their goal is to make their species into the dominant species. The hardware used was iOS6 device and the corresponding simulator for iOS6, and an Xiaomi HM Note 1 LTE. Because the Android emulator was unable to support multiple images without incurring an out-of-memory error, I decided to run the final product on the actual mobile devices only. 

For each version of the game, the following functionality was implemented:
•	Basic game mechanics: the goal of the game is to become the dominant species (you have more organisms on the board than the other player does) in the habitat (8x8 grid).
•	The game ends when the time period reaches the modern era (it starts at 300mya and decrements by 1 million years per turn), or when the grid is completely full. 
•	When a member of your species is surrounded by 5 or more members of the other player’s species, your piece “defects” to the other player and has its species changed accordingly. This can lead to cascades of “defection” events, where large numbers of a player’s pieces are lost to the other player, and forces players to be strategic about how they arrange their organisms on the grid. 
•	The game’s state will be saved (persistent game state storage). 
•	There is an option to restart the game. 
•	The user interface is complete.
```
