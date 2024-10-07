import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Testsummaryitems extends StatelessWidget {
  const Testsummaryitems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 146.91,
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
      decoration: const BoxDecoration(
        color: Color(0xff1D1D1D),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: LayoutBuilder(
    builder: (context, constraints) {
      double fontSize = constraints.maxWidth * 0.08; // Adjust multiplier as needed
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'شراء اليوم',
                style: Appstyles.regular12cairo(context).copyWith(
                  fontSize: fontSize, // Responsive text size
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/images/kasr.svg',height: MediaQuery.of(context).size.height * 0.02,),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '325,000',
                    style: TextStyle(
                      fontSize: fontSize, // Responsive text size
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 30),
          // const VerticalDivider(
          //   color: Color(0xff373737),
          //   thickness: 2,
          //   width: 20,
          //   indent: 20,
          //   endIndent: 20,
          // ),
        ],
      );
    },
            ),
          ),
          Expanded(
            child: LayoutBuilder(
    builder: (context, constraints) {
      double fontSize = constraints.maxWidth * 0.08;
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'شراء اليوم',
                style: Appstyles.regular12cairo(context).copyWith(
                  fontSize: fontSize,
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/images/kasr.svg',height: 20,),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '325,000',
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 30),
          // const VerticalDivider(
          //   color: Color(0xff373737),
          //   thickness: 2,
          //   width: 20,
          //   indent: 20,
          //   endIndent: 20,
          // ),
        ],
      );
    },
            ),
          ),
           Expanded(
            child: LayoutBuilder(
    builder: (context, constraints) {
      double fontSize = constraints.maxWidth * 0.08;
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'شراء اليوم',
                style: Appstyles.regular12cairo(context).copyWith(
                  fontSize: fontSize,
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/images/kasr.svg',height: 20,),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '325,000',
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 30),
        
        ],
      );
    },
            ),
          ),
    Expanded(
            child: LayoutBuilder(
    builder: (context, constraints) {
      double fontSize = constraints.maxWidth * 0.08;
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'شراء اليوم',
                style: Appstyles.regular12cairo(context).copyWith(
                  fontSize: fontSize,
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/images/kasr.svg',height: 20,),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '325,000',
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 30),
        
        ],
      );
    },
            ),
          ),
        ],
      ),
    ),
    
        ),
      ),
    );
  }
}
