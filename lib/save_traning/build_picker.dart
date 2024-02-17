import 'package:flutter/cupertino.dart';

Widget buildPickerTr({
  required FixedExtentScrollController scrollController,
  required List<String> items,
  required int index,
  required void Function(int) onSelectedItemChanged,
}) {
  return SizedBox(
    height: 350,
    child: CupertinoPicker(
      scrollController: scrollController,
      itemExtent: 64,
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
        background: CupertinoColors.activeOrange.withOpacity(0.2),
      ),
      onSelectedItemChanged: onSelectedItemChanged,
      children: List.generate(
        items.length,
            (index) {
          final item = items[index];
          return Center(
            child: Text(
              item,
              style: TextStyle(fontSize: 32),
            ),
          );
        },
      ),
    ),
  );
}
