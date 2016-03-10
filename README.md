# Testudo
```
Progress: 
iOS -> Stage 1 DONE!
Android -> Interface configured


Game Plan - Do NOT proceed to the next stage until the current stage is on both devices
1) Implement basic game logic on both iOS and Android
  - if an organism is surrounded by 5 or more members of a different species, it "defects" to the other species
  - the basic win conditions must be implemented
        - board full, winner is the one with more organisms (can tie)
        - you can also win by having the population advantage when modern era is reached
  - restart feature must be implemented 
  - game state saved across multiple runs (board state, turn state, any event messages, era state)
  - era is just a counter from 160mya to 0 at this stage
  - turn indicator must be implemented
  
2) Implement eras and the mass extinctions
  - add the era boundaries and broadcast extinctions
  - game state now includes extinction messages as well
  - certain extinctions will trigger on era boundaries
      - one of the extinctions randomly chosen every 30 turns
  - they kill indiscriminately
  - in the subsequent steps you must take care to not trigger certain ones too often
  
  - mass extinctions that can trigger at this stage:
      - meteor: 60-90% of species wiped out, randomly pick that number of organisms to remove
      - volcanic eruption: between 10-20 piles of ash hits random spots on the board, rendering them impassable and killing any 
          organisms residing on it
          - the ash will stay until the next extinction event or game over
      - alien invasion: complete board flip!!! all Sea -> Snapper, all Snapper -> Sea!
      - disease: now, you can convert a species just by surrounding it by 4 instead of 5 organisms
      - overcompetition: now, you need to surround an organism with 6 of your own to convert it

3) Implement all of the predator types, they differ in their traversal
4) Implement the invasive species
  - they are mindless and will just spread adjacently, making them rather easy to destroy
5) Implement the competitors, which behave just like the organisms and are affected by everything that affects them
  - the competitors are smarter than the invasive species, and will spread out more
6) Different levels of difficulty -> increased incidences of certain obstacles

Realistically probably will not get past #2 or 3.

Discarded ideas:
8) Add in the habitat-altering disasters
9) Add in geographical barriers
10) Add in the different organism types, and their perks
11) Add in different game modes
  Normal mode: default 8x8 board
  Predation mode: 13x13 board, predators never disappear from the screen
  Extinction mode: 19x19 board, competitors and invasive species will remain on the board until wiped out, plus predators never disappear
3) Implement state of organism with matching visuals (egg, infant, juvenile, adult)
 and the four biomes
  - first, get them to eat indiscriminately

2-player game where your goal is to survive to the modern era as the dominant species
Gameplay takes place on a small grid, where you can lay down one organism per turn (5 turns = 1 era)
Organism can be placed pretty much anywhere that's habitable
If you can completely surround an opposing piece with your pieces, all of the opposing pieces will die (outcompeted), this includes invasive and competing species but not predators
Game will end if one of the 2 players die, or when there are no spaces left on the grid
How to win: survive to the modern era with more organisms on the board than your rival, you become the dominant species 

Organism 
Newest organisms are eggs, they can be killed by pretty much anything
Survive 1 turn = infant, small % chance of defending against preddator
Survive 2 turns = juveniles, some % chance of defending against predator
Survive 3 turns = adult, immune to bird, crab, and racoon predation, moderate chance of defending against the remaining predators, also less vulnerable to diseases and habitat-altering disasters

Environment
There are four zones in the beginning: grasslands, desert, beach, and ocean
The terrain will stay the same, but certain areas may become inhabitable due to random events

Time Periods
These will just give you a good idea of how close you are to the end of the game, but besides the extinction events there will be no guarantee of scientific accuracy
Upper Jurassic
Lower Cretaceous
Upper Cretaceous - guaranteed massive extinction event (bye bye dinosaurs)
Paleocene
Eocene
Oligocene
Miocene
Pliocene
Pleistocene
Holocene - guaranteed massive extinction event (humans)

Events
1) Mass exinction, which will trigger randomly, but at most once every three eras - a high percentage of organisms on the board wiped out
  Possibilities: supervolcano, meteorite impact, ice age, alien invasion
    Alien invasion will WIPE THE ENTIRE BOARD!
2) Disaster, which may affect anywhere from one to all terrains
  a) Famine - organisms take 2x the time to mature into adults 
  b) Disease - organisms in a certain age bracket have higher mortality 
  c) Competition - a third species will appear to compete with the players and stay for some period of time
  d) Invasive Species - an invasive species starts taking over one of the terrain areas, will last for maximum 3 eras
  e) Predation - birds (teleport), crabs/racoons (moves to adjacent spaces only, and only vertically or horizontally), and sharks/crocodiles (swim in any direction, the latter will hunt turtles on land) appear and start to move around the grid randomly, eating any organisms that they encounter
  f) Habitat-altering disasters such as algal blooms/oil spills (ocean), litter (beach), rendering certain portions of the board temporarily uninhabitable
  g) Geographical barriers - these can arise randomly, but at most once every 10 eras, which will kill any organisms that were on the squares where the barrier arises, they will dissipate after 10 eras
  
Species - if I get to this part, it's cause everything else was done
Snapping turtle
  Advantage: 100% immune to predation upon reaching adulthood
  Disadvantage: all age brackets take on the highest possible disease mortality
Sea turtle
  Advantage: can mature in 3 turns instead of 4
  Disadvantage: confined to the beach and ocean habitats
Galapagos tortoise
  Advantage: can convert invasive species into their own kind the invader is surrounded by 3 tortoises
  Disadvantage: competitors can kill this tortoise by surrounding them with 3 of their members only 
Softshell turtle
  Advantage: not affected by algal blooms, oil spills, and litter, can convert them into pristine habitat by being adjacent to it
  Disadvantage: 25% lower chance of defending against all predators
Cocurtle 
  Advantage: they will not die when surrounded
  Disadvantage: takes 4x the time to mature to adults during famines
```
