part of app_utils;

class FastScrollPhysics extends ScrollPhysics {
  const FastScrollPhysics({
    super.parent,
  });

  @override
  FastScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FastScrollPhysics(parent: buildParent(ancestor),);
  }

  //When you scroll past the list edges (overscroll), this decides how "hard" it is to keep going.
  //A lower value = easier to pull past edges (so 0.4 = light friction).
  double frictionFactor(double overscrollFraction) {
    return math.pow(1 - overscrollFraction, 2) * 0.4;
  }

  //Handles the user's drag gesture.
  //If you're scrolling inside the list, it just moves as usual.
  //If you're dragging past the edges (overscroll), it slows things down using friction (see above).
  //This gives you that soft edge resistance effect.
  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (!position.outOfRange) return offset*0.6;

    final overscrollPastStart = math.max(position.minScrollExtent - position.pixels, 0.0);
    final overscrollPastEnd = math.max(position.pixels - position.maxScrollExtent, 0.0);
    final overscrollPast = math.max(overscrollPastStart, overscrollPastEnd);

    final easing = (overscrollPastStart > 0.0 && offset < 0.0) ||
        (overscrollPastEnd > 0.0 && offset > 0.0);

    final friction = frictionFactor(
      easing
          ? (overscrollPast - offset.abs()) / position.viewportDimension
          : overscrollPast / position.viewportDimension,
    );

    final direction = offset.sign;

    return direction * _applyFriction(overscrollPast, offset.abs(), friction);
  }

  //Calculates how much drag to allow depending on how far you've gone past the scroll bounds.
  //Keeps the motion feeling natural and progressively harder the more you pull.
  static double _applyFriction(double extentOutside, double absDelta, double gamma) {
    double total = 0.0;
    if (extentOutside > 0) {
      final deltaToLimit = extentOutside / gamma;
      if (absDelta < deltaToLimit) {
        return absDelta * gamma;
      }
      total += extentOutside;
      absDelta -= deltaToLimit;
    }
    return total + absDelta;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) => 0.0;

  //Triggered after you lift your finger — this is where momentum continues.
  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    var tolerance = toleranceFor(position);

    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
        constantDeceleration: 1600,
      );
    }
    return null;
  }

  // Sets the minimum speed required for a fling to happen.
  //Lowering it makes small finger flicks still trigger a scroll (more responsive).
  @override
  double get minFlingVelocity => 20;

  //Sets the maximum speed allowed when flinging.
  // 10.0 is very high, so big flicks will go very fast.
  @override
  double get maxFlingVelocity => kMaxFlingVelocity * 10.0;

  //Controls how much extra momentum gets carried over from a quick swipe.
  //This helps repeated swipes feel faster
  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign *
        math.min(0.000816 * math.pow(existingVelocity.abs(), 1.967).toDouble(), 40000.0);
  }

  //How far your finger has to move before a drag/scroll starts.
  //A smaller value (like 0.5) makes the scroll respond to even slight touches.
  @override
  double get dragStartDistanceMotionThreshold => 2;

  @override
  SpringDescription get spring {
    return SpringDescription.withDampingRatio(
      mass: 0.2,
      stiffness: 200,
      ratio: 1.05,
    );
  }
}
