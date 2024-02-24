import 'package:flutter/cupertino.dart';

Widget buildPickerTr(FixedExtentScrollController scrollController, List<String> items, int selectedIndex, Function(int) onSelectedItemChanged) => SizedBox(
  height: 350,
  child: CupertinoPicker(
    scrollController: scrollController,
    itemExtent: 64,
    selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
      background: CupertinoColors.activeOrange.withOpacity(0.2),
    ),
    onSelectedItemChanged: onSelectedItemChanged,
    children: List.generate(items.length, (index) {
      final item = items[index];
      return Center(
        child: Text(
          item,
          style: const TextStyle(fontSize: 32),
        ),
      );
    }),
  ),
);
