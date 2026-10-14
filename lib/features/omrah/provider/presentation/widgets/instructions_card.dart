import 'package:flutter/material.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/instruction_model.dart';

class InstructionsCard extends StatefulWidget {
  final InstructionModel item;
  final int number;
  // final void Function() onCompleteTap;
  const InstructionsCard({
    super.key,
    required this.item,
    required this.number,
    // required this.onCompleteTap,
  });

  @override
  State<InstructionsCard> createState() => _InstructionsCardState();
}

class _InstructionsCardState extends State<InstructionsCard> {
  bool expanded = false;
  late String numberOfStep;

  @override
  void initState() {
    super.initState();
    setNumberOfStep();
  }

  @override
  void didUpdateWidget(covariant InstructionsCard oldWidget) {
    if (widget.number != oldWidget.number) {
      setNumberOfStep();
    }
    super.didUpdateWidget(oldWidget);
  }

  void setNumberOfStep() {
    numberOfStep = injector<LocalizationContainer>().langCode.isArabic
        ? widget.number.toArabicNumber()
        : widget.number.toString();
  }

  void toggle() {
    setState(() => expanded = !expanded);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF0E2A22), Color(0xFF0B3D2E)],
          ),
        ),

        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 320),
          reverseDuration: const Duration(milliseconds: 300),
          firstCurve: Curves.ease,
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,

          firstChild: _collapsedView(),
          secondChild: _expandedView(),
        ),
      ),
    );
  }

  Widget _collapsedView() {
    return Center(
      child: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  numberOfStep,
                  style: TextStyle(
                    color: Color(0xFFE6D3A3),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.item.title,
                  style: context.medium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          PositionedDirectional(
            top: 0,
            end: 0,
            child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ),

          if (widget.item.isSelected)
            PositionedDirectional(
              bottom: 0,
              end: 4,
              child: Icon(Icons.check_circle, color: Colors.white, size: 14),
            ),
        ],
      ),
    );
  }

  Widget _expandedView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              numberOfStep,
              style: TextStyle(
                color: Color(0xFFE6D3A3),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            Icon(Icons.keyboard_arrow_up, color: Colors.white),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          widget.item.title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),

        const SizedBox(height: 8),

        Text(
          appLocalizer.readGuideConfirm,
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),

        const SizedBox(height: 16),

        // Content Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            widget.item.description,
            style: TextStyle(color: Colors.white, height: 1.5),
          ),
        ),

       // const SizedBox(height: 16),
       //
       //  // Button
       //  SizedBox(
       //    width: double.infinity,
       //    child: ElevatedButton(
       //      onPressed: () {
       //        widget.onCompleteTap();
       //        setState(() {
       //          expanded = false;
       //        });
       //      },
       //      style: ElevatedButton.styleFrom(
       //        backgroundColor: Colors.white,
       //        foregroundColor: Colors.black,
       //        shape: RoundedRectangleBorder(
       //          borderRadius: BorderRadius.circular(16),
       //        ),
       //        padding: const EdgeInsets.symmetric(vertical: 14),
       //      ),
       //      child: Text(appLocalizer.confirm),
       //    ),
       //  ),
      ],
    );
  }
}
