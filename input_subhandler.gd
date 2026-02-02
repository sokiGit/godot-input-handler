class_name InputSubhandler extends Node

@export var enabled: bool = true;

@export_category("Action-to-Mode Bindings")
@export var action_bindings: Dictionary[String, TriggerMode] = {};

enum TriggerMode {
    JUST_PRESSED, # Only trigger when the action is just pressed
    JUST_RELEASED, # Only trigger when the action is just released
    ECHO, # Trigger continuously while the action is held down (after a delay, depends on user's OS settings)
        # Note: Maybe this should be called "ECHO", that's what Godot calls it internally
}

func _on_activate(_event: InputEvent) -> InputHandler.InputHandledState:
## The internal method to be overridden by subclasses to handle input
## This is the method you should change in your subclasses
## Feel free to change this default method
    return InputHandler.InputHandledState.UNHANDLED # Return UNHANDLED by default

func activate(event: InputEvent) -> InputHandler.InputHandledState:
## The external method called by InputHandler to activate this subhandler
## You probably shouldn't change this method

    if not enabled:
        return InputHandler.InputHandledState.UNHANDLED

    var returned_value = _on_activate(event)

    if returned_value is InputHandler.InputHandledState: # Type safety check
        return returned_value
    else:
        # If the returned value is not of the correct type, log an error and return HANDLING_ERROR
        return InputHandler.InputHandledState.HANDLING_ERROR 
