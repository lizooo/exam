import 'dart:math';
import 'package:flutter/material.dart';

class FinalTask extends StatefulWidget {
  const FinalTask({Key? key}) : super(key: key);

  @override
  _FinalTaskState createState() => _FinalTaskState();
}

class _FinalTaskState extends State<FinalTask> {
  Random random = Random();

  late List<Map<String, dynamic>> arr1 = [];
  late List<Map<String, dynamic>> arr2 = [];
  late List<Map<String, dynamic>> redElementsArray = [];

  int amountOfRedsToPickNext = 5;
  bool redMode = false;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    int randomNumberForFirstList = random.nextInt(10) + 5;
    int randomNumberForSecondtList = random.nextInt(10) + 5;

    late List<Map<String, dynamic>> a1 = [];
    late List<Map<String, dynamic>> a2 = [];

    for (var i = 0; i < randomNumberForFirstList; i++) {
      a1.add(<String, dynamic>{'text': 'left $i', 'color': Colors.grey});
    }
    for (var i = 0; i < randomNumberForSecondtList; i++) {
      a2.add(<String, dynamic>{'text': 'right $i', 'color': Colors.grey});
    }

    setState(() {
      arr1 = a1;
      arr2 = a2;
    });
  }

  greyModeAction() {
    int currentListIndex = random.nextInt(2) + 0;

    if (arr1.isEmpty) {
      currentListIndex = 2;
    } else if (arr2.isEmpty) {
      currentListIndex = 1;
    }

    final selectedArr = currentListIndex == 1 ? arr1 : arr2;

    int currentElementIndex = random.nextInt(selectedArr.length) + 0;

    if (currentListIndex == 1) {
      if (!selectedArr[currentElementIndex]['text'].contains('right')) {
        selectedArr[currentElementIndex]['color'] = Colors.red;
        redElementsArray.add(selectedArr[currentElementIndex]);
        if (redElementsArray.length >= 5) {
          setState(() {
            redMode = true;
          });
        }
      } else {
        selectedArr[currentElementIndex]['color'] = Colors.grey;
      }
      setState(() {
        arr2.add(selectedArr[currentElementIndex]);
        arr1.removeAt(currentElementIndex);
      });
    } else {
      setState(() {
        if (!selectedArr[currentElementIndex]['text'].contains('left')) {
          selectedArr[currentElementIndex]['color'] = Colors.red;
          redElementsArray.add(selectedArr[currentElementIndex]);
          if (redElementsArray.length >= 5) {
            setState(() {
              redMode = true;
            });
          }
        } else {
          selectedArr[currentElementIndex]['color'] = Colors.grey;
        }

        arr1.add(selectedArr[currentElementIndex]);
        arr2.removeAt(currentElementIndex);
      });
    }
  }

  redModeAction() {
    int currentElement = random.nextInt(redElementsArray.length) + 0;

    redElementsArray[currentElement]['color'] = Colors.grey;
    if (redElementsArray[currentElement]['text'].contains('right')) {
      setState(() {
        arr2.add(redElementsArray[currentElement]);
        arr1.removeWhere((element) =>
            element['text'] == redElementsArray[currentElement]['text']);
      });
      redElementsArray.removeAt(currentElement);
    } else {
      setState(() {
        arr1.add(redElementsArray[currentElement]);
        arr2.removeWhere((element) =>
            element['text'] == redElementsArray[currentElement]['text']);
      });
      redElementsArray.removeAt(currentElement);
    }
    setState(() {
      amountOfRedsToPickNext = amountOfRedsToPickNext - 1;
    });
  }

  switchPoditions() {
    final shouldPickFromRedElements =
        redElementsArray.length >= 5 ? true : false;

    if (shouldPickFromRedElements && !redMode) {
      setState(() {
        redMode = true;
      });
    }

    if (!redMode) {
      greyModeAction();
    } else {
      redModeAction();
    }
    if (amountOfRedsToPickNext == 0) {
      setState(() {
        amountOfRedsToPickNext = 5;
        redMode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Row(
              children: <Widget>[
                ListWidget(
                  list: arr1,
                ),
                const SizedBox(
                  width: 60,
                ),
                ListWidget(
                  list: arr2,
                )
              ],
            ),
            Positioned(
              right: 50,
              bottom: 50,
              child: FloatingActionButton(
                onPressed: !redMode ? () => switchPoditions() : null,
                backgroundColor: !redMode ? Colors.blueAccent : Colors.grey,
              ),
            ),
            if (redMode)
              Positioned(
                left: 50,
                bottom: 50,
                child: FloatingActionButton(
                  onPressed: () {
                    switchPoditions();
                  },
                ),
              ),
          ],
        ),
      )),
    ));
  }
}

class ListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> list;

  const ListWidget({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: list.map((item) => ListItem(data: item)).toList(),
    ));
  }
}

class ListItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const ListItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 40,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: data['color']),
      alignment: Alignment.center,
      child: Text(
        data['text'],
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
