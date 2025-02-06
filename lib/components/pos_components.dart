
import 'package:flutter/material.dart';

import 'components.dart';

class PosMenuOrderTabs extends StatelessWidget {
  const PosMenuOrderTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(
          style: BorderStyle.solid,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 30.0,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/pos-menu");
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Sans("Menu", 12.0),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 30.0,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/pos-order");
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Sans("Order", 12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
