# Maze Game

A tense 3D horror maze game created in Godot Engine 4.x. 

You find yourself trapped in a dark, sprawling maze with only a few matchsticks and an unlit lantern. Your objective is to navigate the winding corridors, find, and ring **7 hidden bells** to escape. But you are not alone. A relentless entity patrols the darkness, and the very sound of the bells you must ring will draw it to your location. Manage your light sources, watch your stamina, and survive the maze.

## Features

- **Tense 3D Horror Gameplay**: Navigate a claustrophobic, dark environment with limited visibility.
- **Resource Management**: Collect and carefully manage matchsticks. Use them to briefly illuminate your path or to ignite your lantern.
- **Dynamic Enemy AI**: A patrolling ghost that chases you on sight, investigates loud noises (like bell rings), and can be temporarily stunned with a lit lantern.
- **Atmospheric Visuals**: Custom retro shaders including camera pixelation, vignette, and a proximity-based glitch effect that intensifies as danger approaches.
- **Immersive Audio**: Ambient sounds, eerie footsteps, and terrifying proximity cues and jumpscares build a deeply unsettling atmosphere.
- **Complete Menu System**: Fully functional main menu, pause menu, and options for volume, mouse sensitivity, and screen resolution.

## Prerequisites

- **Godot Engine 4.x** (Configured for the GL Compatibility renderer).

## How to Play

1. Download or clone this repository to your local machine.
2. Open Godot Engine 4.
3. Click **Import** and select the `project.godot` file located in the root directory.
4. Press `F5` or click the **Play** button in the top right of the editor to run the game.

## Controls

* **W, A, S, D**: Move
* **Shift**: Sprint (Drains stamina)
* **Mouse**: Look around
* **Left Mouse Button / Q**: Light a Matchstick
* **Right Mouse Button / E**: Light your Lantern (Requires a currently burning matchstick)
* **F11**: Toggle Fullscreen
* **Esc**: Pause the game

## Gameplay Mechanics

### Matchsticks & Lantern
You begin with 2 matchsticks, but more can be found throughout the maze. 
* Lighting a matchstick provides a small amount of light for a brief time.
* While a matchstick is burning, you can choose to light your **Lantern**.
* A lit lantern provides a much stronger light source. If the ghost gets too close while your lantern is fully blazing, it will be temporarily stunned, allowing you to escape. However, lantern fuel burns out very quickly.

### The Ghost
The entity constantly roams the maze. 
* If it establishes line of sight or gets too close, it will relentlessly chase you.
* Ringing a bell instantly alerts the ghost to that specific location.
* If the ghost catches you, the game is over.

### Bells
The primary objective of the game. You must find and interact with 7 bells scattered around the map. Once all 7 are rung, you win the game.

## Project Structure

* `/entities`: Contains the ghost enemy scene and logic.
* `/items`: Interactables and pickups like matchsticks and bells.
* `/maps`: The level files, including the primary `maze_level.tscn`.
* `/player_stuff`: The player controller, HUD elements, and associated sound logic.
* `/scripts`: GDScript files driving the game's logic and mechanics.
* `/shaders`: Retro effect shaders (pixelation, vignette, glitch).
* `/sounds` & `/models` & `/images`: Audio and visual assets for the game.

---
*Created in Godot Engine 4.*