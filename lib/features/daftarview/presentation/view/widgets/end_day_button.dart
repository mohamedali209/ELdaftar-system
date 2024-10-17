import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class EndDayButton extends StatelessWidget {
  const EndDayButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center aligns the button in the available space
      child: Row(
        children: [
          const Spacer(),
          SizedBox(
            width: MediaQuery.sizeOf(context).width *
                .3, // Fixed width for the button
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 61, 126, 237),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Text('إنهاء اليوم', style: Appstyles.regular25(context)),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
