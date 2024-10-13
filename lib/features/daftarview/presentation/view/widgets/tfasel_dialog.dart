import 'package:flutter/material.dart';

class TfaselDialog extends StatelessWidget {
  final String tfasel;

  const TfaselDialog({super.key, required this.tfasel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: FractionallySizedBox(
        heightFactor: 0.4, // 40% of the screen height
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 11, 7, 25),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              Center(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Color(0xff594300), Colors.amber],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ).createShader(bounds);
                  },
                  child: const Text('تفاصيل', style: TextStyle(fontSize: 20)),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    textDirection: TextDirection.rtl,
                    'تفاصيل : $tfasel',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextButton(
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
