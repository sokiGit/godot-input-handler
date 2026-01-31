# You probably don't need to modify this file.

extends Node
class_name InputHandler

@export var enabled: bool = true;

enum InputHandledState {
	HANDLED,
	UNHANDLED,
	HANDLING_ERROR,
	HALNDED_CONTINUE_PROCESSING,
}

func _input(event: InputEvent) -> void:
	if not enabled: return
	for child: InputSubhandler in get_children():
		if not child.enabled: continue
		for action_name in child.action_bindings.keys():
			if event.is_action(action_name):
				match child.action_bindings[action_name]:
				# Check the trigger mode
				# You probably shouldn't change this part

					InputSubhandler.TriggerMode.JUST_PRESSED:
						if not event.is_pressed() or event.is_echo():
							continue
					
					InputSubhandler.TriggerMode.JUST_RELEASED:
						if event.is_pressed() or event.is_echo():
							continue
					
					InputSubhandler.TriggerMode.PRESSED_CONTINUOUS:
						if not event.is_pressed():
							continue

				match child.activate(event):
				# What happens after the subhandler processes the input
				# Feel free to change to your liking

					InputHandledState.HANDLED:
						# The input was successfully handled
						# Don't propagate the event further
						get_viewport().set_input_as_handled()
						return
					
					InputHandledState.UNHANDLED:
						# The input was not handled
						# Let other subhandlers handle it
						continue
					
					InputHandledState.HANDLING_ERROR:
						# There was an error handling the input
						# Log an error message
						# Continue to the next subhandler
						push_error("InputSubhandler '%s' returned HANDLING_ERROR for action '%s'." % [child.name, action_name])
						continue
					
					InputHandledState.HALNDED_CONTINUE_PROCESSING:
						# The input was handled, but allow further processing
						get_viewport().set_input_as_handled()
						break
