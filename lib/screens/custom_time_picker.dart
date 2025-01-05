import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final void Function(int hour, int minute)? onTimeSelected;

  const CustomTimePicker({super.key, this.onTimeSelected});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  int selectedHour = 0;
  int selectedMinute = 0;

  @override
  void initState() {
    _hourController = FixedExtentScrollController(initialItem: 0);
    _minuteController = FixedExtentScrollController(initialItem: 0);
    super.initState();
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 65,
                      decoration:
                          BoxDecoration(color: const Color(0xff36402b), borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  //    Time Weels
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildWheelList(
                          controller: _hourController,
                          items: List.generate(24, (index) => index),
                          onChanged: (value) {
                            setState(() {
                              selectedHour = value;
                            });
                            widget.onTimeSelected?.call(selectedHour, selectedMinute);
                          },
                        ),
                        const Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            ":",
                            style: TextStyle(fontSize: 40, color: Color(0xffa8c889)),
                          ),
                        ),
                        _buildWheelList(
                          controller: _minuteController,
                          items: List.generate(60, (index) => index),
                          onChanged: (value) {
                            setState(() {
                              selectedMinute = value;
                            });
                            widget.onTimeSelected?.call(selectedHour, selectedMinute);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomButton(Icons.music_note, 'SOUND\nWAKEUP'),
                  _buildBottomButton(Icons.notifications, 'SNOOZE\nEVERY 10 MIN'),
                  _buildBottomButton(Icons.repeat, 'REPEAT\nNO'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.green[200],
                  ),
                  style: IconButton.styleFrom(
                    fixedSize: const Size(80, 80),
                    backgroundColor: const Color(0xff10130d),
                  ),
                ),
                Text(
                  'CHOOSE TIME',
                  style: TextStyle(
                    color: Colors.green[200],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.check,
                    color: Colors.black,
                  ),
                  style: IconButton.styleFrom(
                    fixedSize: const Size(80, 80),
                    backgroundColor: const Color(0xff98ac84),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.green[200],
          size: 24,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.green[200],
            fontSize: 18,
          ),
        )
      ],
    );
  }

  Widget _buildWheelList({
    required FixedExtentScrollController controller,
    required List<int> items,
    required Function(int) onChanged,
  }) {
    return SizedBox(
      width: 70,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 80,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.005,
        diameterRatio: 2.0,
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (context, index) {
            return Center(
              child: Text(
                items[index].toString().padLeft(2, '0'),
                style: const TextStyle(fontSize: 60, color: Color(0xffa8c889), fontWeight: FontWeight.w600),
              ),
            );
          },
        ),
      ),
    );
  }
}
