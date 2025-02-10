import 'package:flutter/material.dart';

/// A customizable swipe button widget that changes state upon user interaction.
/// The button includes features like gradient background, customizable icons,
/// text, and color changes on swipe completion.
class BGSwipeButton extends StatefulWidget {
  /// Callback to be executed when the swipe is completed.
  final VoidCallback onCompleted;

  /// The text to display before the swipe action.
  final String text;

  /// The text to display after the swipe action is completed.
  final String completedText;

  /// The background color of the swipe button before completion.
  final Color backgroundColor;

  /// The color of the swipe button when it's completed.
  final Color completeColor;

  /// The radius of the swipe button's circular avatar.
  final double buttonRadius;

  /// The text color before the swipe action.
  final Color beforeSwipeTextColor;

  /// The text color after the swipe action is completed.
  final Color afterSwipeTextColor;

  /// The icon to display before the swipe action.
  final Icon beforeSwipeIcon;

  /// The icon to display after the swipe action is completed.
  final Icon afterSwipeIcon;

  /// A list of colors used for the gradient background.
  final List<Color> gradientColors;

  /// Constructor to initialize the swipe button with required and optional properties.
  const BGSwipeButton({
    super.key,
    required this.onCompleted,
    required this.text,
    required this.completedText,
    this.backgroundColor = Colors.grey,
    this.completeColor = Colors.green,
    this.buttonRadius = 30,
    this.beforeSwipeTextColor = Colors.white,
    this.afterSwipeTextColor = Colors.white,
    required this.beforeSwipeIcon,
    required this.afterSwipeIcon,
    this.gradientColors = const [Colors.blue, Colors.blueAccent],
  });

  @override
  State<BGSwipeButton> createState() => _BGSwipeButtonState();
}

class _BGSwipeButtonState extends State<BGSwipeButton> {
  /// Keeps track of the current position of the swipe.
  double _swipePosition = 0;

  /// Indicates whether the swipe action is completed.
  bool _isCompleted = false;

  /// Indicates whether the user is currently dragging the button.
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    double maxSwipePosition =
        MediaQuery.of(context).size.width - 2 * widget.buttonRadius;

    double thresholdSwipePosition = maxSwipePosition * 0.2;

    return GestureDetector(
      /// Called when the user starts dragging the button horizontally.
      onHorizontalDragStart: (details) {
        setState(() {
          _isDragging = true;
        });
      },

      /// Called during the dragging process. Updates the swipe position.
      onHorizontalDragUpdate: (details) {
        if (!_isCompleted) {
          setState(() {
            _swipePosition = (_swipePosition + details.primaryDelta!)
                .clamp(0, maxSwipePosition);
          });
        }
      },

      /// Called when the user ends the drag. Determines if the swipe is completed.
      onHorizontalDragEnd: (details) {
        setState(() {
          _isDragging = false;
        });

        if (!_isCompleted && _swipePosition > maxSwipePosition * 0.7) {
          setState(() {
            _swipePosition = maxSwipePosition;
            _isCompleted = true;
          });
          widget.onCompleted();
        } else {
          setState(() {
            _swipePosition = 0;
          });
        }
      },

      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 2 * widget.buttonRadius,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            /// The background container with gradient applied.
            Container(
              width: 2 * MediaQuery.of(context).size.width,
              height: 2 * widget.buttonRadius,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradientColors, // Apply gradient colors.
                ),
                borderRadius: BorderRadius.circular(widget.buttonRadius),
              ),
            ),

            /// The animated container that updates during the drag.
            ClipRRect(
              borderRadius: BorderRadius.circular(widget.buttonRadius),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _swipePosition >= thresholdSwipePosition
                    ? _swipePosition + widget.buttonRadius
                    : widget.buttonRadius,
                height: 2 * widget.buttonRadius,
                decoration: BoxDecoration(
                  color: _swipePosition >= thresholdSwipePosition
                      ? widget.completeColor
                      : Colors.transparent,
                ),
              ),
            ),

            /// The circle avatar to show the swipe button's icon.
            Positioned(
              left: _swipePosition,
              child: CircleAvatar(
                radius: widget.buttonRadius,
                backgroundColor: widget.completeColor,
                foregroundColor: Colors.white,
                child: _isCompleted
                    ? widget.afterSwipeIcon
                    : widget.beforeSwipeIcon,
              ),
            ),

            /// The text that appears in the center of the swipe button.
            Center(
              child: Opacity(
                opacity: _isDragging ? 0.0 : 1.0,
                child: Text(
                  _isCompleted ? widget.completedText : widget.text,
                  style: TextStyle(
                    color: _isCompleted
                        ? widget.afterSwipeTextColor
                        : widget.beforeSwipeTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
