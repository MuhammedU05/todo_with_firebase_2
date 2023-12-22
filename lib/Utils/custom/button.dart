import 'package:flutter/material.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';

class SelectableButton extends StatefulWidget {
  const SelectableButton({
    super.key,
    required this.selected,
    this.style,
    required this.onPressed,
    required this.child,
  });

  final bool selected;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<SelectableButton> createState() => _SelectableButtonState();
}

class _SelectableButtonState extends State<SelectableButton> {
  late final MaterialStatesController statesController;

  @override
  void initState() {
    super.initState();
    statesController = MaterialStatesController(
        <MaterialState>{if (widget.selected) MaterialState.selected});
  }

  @override
  void didUpdateWidget(SelectableButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      statesController.update(MaterialState.selected, widget.selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      statesController: statesController,
      style: widget.style,
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}

class CustomButtonCompleted extends StatefulWidget {
  const CustomButtonCompleted({super.key});

  @override
  State<CustomButtonCompleted> createState() => _CustomButtonCompletedState();
}

class _CustomButtonCompletedState extends State<CustomButtonCompleted> {
  @override
  Widget build(BuildContext context) {
    // selected = false;
    // isCompletedSelected = false;
    isCompletedSelected ? selected = true : selected = false;
    return SelectableButton(
        selected: selected,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                // selected = false;
                // isCompletedSelected = false;
                return Colors.white;
              }
              return null; // defer to the defaults
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                // selected = true;
                // isCompletedSelected = true;
                return Colors.green;
              }
              return null; // defer to the defaults
            },
          ),
        ),
        onPressed: () {
          setState(() {
            selected = !selected;
            isCompletedSelected = !isCompletedSelected;
            print('selected : $selected');
            print('isCompletedSelected : $isCompletedSelected');
          });
        },
        child: const Text(TStrings.completed));
  }
}
