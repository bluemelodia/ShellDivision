# Testudo
'''
2-player game where your goal is to survive to the modern era as the dominant species
Gameplay takes place on a small grid, where you can lay down one organism per turn (5 turns = 1 era)
If you can completely surround an opposing piece with your pieces, all of the opposing pieces will die (outcompeted), this includes invasive and competing species but not predators

Organism 
Newest organisms are eggs, they can be killed by pretty much anything
Survive 1 turn = infant, small % chance of defending against preddator
Survive 2 turns = juveniles, some % chance of defending against predator
Survive 3 turns = adult, immune to bird, crab, and racoon predation, moderate chance of defending against the remaining predators, also less vulnerable to diseases and habitat-altering disasters

Environment
There are three zones in the beginning: grasslands, desert, beach, and ocean
The terrain will stay the same, but certain areas may become inhabitable due to random events

Events
1) Mass exinction, which will trigger randomly, but at most once every three eras - a high percentage of organisms on the board wiped out
  Possibilities: supervolcano, meteorite impact, ice age, alien invasion
2) Disaster, which may affect anywhere from one to all terrains
  a) Famine - organisms take 2x the time to mature into adults 
  b) Disease - organisms in a certain age bracket have higher mortality 
  c) Competition - a third species will appear to compete with the players and stay for some period of time
  d) Invasive Species - an invasive species starts taking over one of the terrain areas, will last for maximum 3 eras
  e) Predation - birds (teleport), crabs/racoons (moves to adjacent spaces only, and only vertically or horizontally), and sharks/crocodiles (swim in any direction, the latter will hunt turtles on land) appear and start to move around the grid randomly, eating any organisms that they encounter
  f) Habitat-altering disasters such as algal blooms/oil spills (ocean), litter (beach),  rendering certain portions of the board temporarily uninhabitable
  g) Geographical barriers - these can arise randomly, but at most once every 10 eras, which will kill any organisms that were on the squares where the barrier arises, they will dissipate after 10 eras
'''
