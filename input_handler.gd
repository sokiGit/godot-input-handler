# You probably don't need to modify this file.

class_name InputHandler extends Node

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
				var trigger_mode = child.action_bindings[action_name];
				match trigger_mode:
				# Check the trigger mode
				# You probably shouldn't change this part

					InputSubhandler.TriggerMode.JUST_PRESSED:
						if not event.is_pressed() or event.is_echo():
							continue
					
					InputSubhandler.TriggerMode.JUST_RELEASED:
						if event.is_pressed() or event.is_echo():
							continue
					
					InputSubhandler.TriggerMode.ECHO:
						if not event.is_pressed() or not event.is_echo():
							continue
					
					_:
						# This should not happen, if it does, it's a very weird bug
						push_error("Skipping because provided TriggerMode for action '%s' was an invalid value: %s" % [ str(action_name), str(trigger_mode) ]);
						continue

				var activation_return_state = child.activate(event);

				match activation_return_state:
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
					
					_:
						# Default
						# For anything else that might be returned by the function,
						# including unhandled or unexpected values
						push_warning("Breaking because %s.activate(...) returned an unexpected value: %s" % [ child.name, str(activation_return_state) ]);
						break
