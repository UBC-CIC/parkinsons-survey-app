import 'package:flutter/material.dart';

class CustomSelectionListTile extends StatelessWidget {
  final String text;
  final Function onTap;
  final bool isSelected;

  const CustomSelectionListTile({
    Key? key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Color(0xff00A2C8);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
          child: SizedBox(
            height: 85,
            child: ListTile(
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: isSelected? Color(0xff00A2C8): Colors.black,
                    fontFamily: 'DMSans-Regualar',
                    fontSize: 26
                  )
                ),
              ),
              trailing: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  shape: CircleBorder(),
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isSelected,
                  onChanged: (bool? value) {
                    onTap.call();
                  },
                ),
              ),
              onTap: () => onTap.call(),
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}
