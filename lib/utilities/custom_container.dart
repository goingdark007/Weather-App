import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomContainer extends StatelessWidget {

  final String conditionName;
  final String conditionData;
  final String conditionLottie;

  const CustomContainer({
    super.key,
    required this.conditionName,
    required this.conditionData,
    required this.conditionLottie,
  });

  @override
  Widget build(BuildContext context) {

    return Stack(

      children: [

        Container(

          decoration: BoxDecoration(
            color: const Color(0xFF0d1d2a).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        Positioned(

            top: 20,

            left: 10,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(conditionName,
                        style: const TextStyle( color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 15),
                      Text(conditionData,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      )

                    ],
                ),

                const SizedBox(width: 5),

                Lottie.asset(conditionLottie, height: 90, width: 90)

              ],
            )
        )

      ],

    );

  }
}