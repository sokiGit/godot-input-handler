# How to use:
# 1) Create an InputSubhandler node inside your InputHandler.
# 2) Click on it, then right click, and click "Extend script".
# 3) Open the newly created script and replace its content with this script.
# 4) Modify it as you wish.

extends InputSubhandler

# Method override
func _on_activate(_event: InputEvent) -> InputHandler.InputHandledState:
  print("This is an example InputSubhandler script.");
  return InputHandler.InputHandledState.HANDLED;
