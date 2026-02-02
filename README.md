# Godot Input Handler System

![v1.0.1, Godot 4.x](https://img.shields.io/badge/v1.1.0-Godot_4.x-blue?style=for-the-badge)

[![Available on Itch.io](https://img.shields.io/badge/Available_on-Itch.io-red?style=for-the-badge)](https://sokiuwu.itch.io/godot-input-handler)
[![Available on Godot Asset Library](https://img.shields.io/badge/Available_on-Godot_Asset_Library-blue?style=for-the-badge)](https://godotengine.org/asset-library/asset/20610)
[![Support me on Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/S6S51Q99DO)

This is an easy-to-use Godot input handler that solves many problems you might face while trying to handle user input in your game.

## Features

- **Zero Race Conditions**: The inputs are handled in predictable order. You control the order and whether you continue parsing the input.
- **Modular Design**: Each component is a Node, no spaghetti code where multiple inputs are handled in one file. Each component can be disabled.
- **Developer Friendly**: Easy-to-use and easy-to-integrate design, utilizes familiar built-in features (Scene Tree order, exported properties, Input Map) instead of messy boilerplate code.

## How To Use

1. Download the `input_handler.gd` and `input_subhandler.gd` scripts and put them inside your Godot game's Assets directory.
2. Now these will appear as `InputHandler` and `InputSubhandler` instances when you go to add a new Node to your game.
3. Add the `InputHandler` to the game (either directly to the top or inside your player).
4. Add a `InputSubhandler` and extend its script: <img width="298" height="59" alt="image" src="https://github.com/user-attachments/assets/4e8d760e-8357-43ff-b67b-76dd5c137f30" />
5. Add your activation actions in the `InputSubhandler`'s properties. The key will be a valid action name from your game's `Input Map` and the value will be an activation mode, the options are: `Just Pressed`, `Just Released`, `Pressed Continuous`.
6. Override the `_on_activate(_event: InputEvent) -> InputHandler.InputHandledState` method to your liking.
Example method to make sure it works:
```gdscript
extends InputSubhandler

func _on_activate(_event: InputEvent) -> InputHandler.InputHandledState:
  print("This is an example InputSubhandler extension.");
  return InputHandler.InputHandledState.HANDLED;
```

## How It Works

### The Central Handler (Class: `InputHandler`)

This is the top class. It should be only once in your entire game, typically inside your player but that doesn't usually matter.
It calls the individual `InputSubhandler`s and makes sure that they are always executed in the right order and in that only one subhandler 
ever handles an event unless you say otherwise. You don't modify this class/instance in any way. You parent your subhandlers to it.

### The Subhandlers (Class: `InputSubhandler`)

This is the class that you'll "extend" with your own code. You create an instance for each action. 

You also need to assign an action (from `Project > Project Settings > Input Map`) and an activation type to your Subhandlers. 
You can assign multiple actions and activations types if you need to.

Example property window:

<img width="545" height="413" alt="image" src="https://github.com/user-attachments/assets/6b58ac4a-a2aa-42e5-81a8-b6c40a2bcbe0" />

This is an example script with which you can extend an `InputSubhandler`:

```gdscript
extends InputSubhandler

# Method override
func _on_activate(_event: InputEvent) -> InputHandler.InputHandledState:
  print("This is an example InputSubhandler extension.");
  return InputHandler.InputHandledState.HANDLED;
```
### Chain of Responsibility

This system uses a "top-down" execution model. 
By leveraging Godot's Scene Tree order, the `InputHandler` ensures that Subhandlers are processed sequentially. 
This eliminates race conditions where multiple scripts might try to handle the same input simultaneously, causing unpredictable game states.

By decoupling input detection from game logic, the system ensures that systems like UI or pause menus always takes precedence over world interactions by simply placing them higher in the scene.

### The Hierarchy

<img width="268" height="135" alt="image" src="https://github.com/user-attachments/assets/fafa43ff-06f7-41e5-b3a2-e264d53ee164" />

### Enum: `InputHandler.InputHandledState`

This is how you tell the InputHandler what happened during your input handling. You need to return one.

| Value                         | Description                                                                        | Action                          |
|-------------------------------|------------------------------------------------------------------------------------|---------------------------------|
| `HANDLED`                     | Signifies that the input was handled successfully.                                 | Stop processing                 |
| `UNHANDLED`                   | The input was not handled.                                                         | Continue processing             |
| `HANDLING_ERROR`              | There was an error while handling the input.                                       | Continue processing (log error) |
| `HANDLED_CONTINUE_PROCESSING` | The input was handled successfully, but you want to continue processing the input. | Continue processing             |
