part of home;

/// An accepted order whose umrah has not started yet — the requester waits for
/// it and the provider must not begin before [targetDate].
class UpcomingOmrahEntity extends Equatable {
  final String orderId;
  final String beneficiaryName;
  final DateTime? targetDate;

  const UpcomingOmrahEntity({
    required this.orderId,
    required this.beneficiaryName,
    required this.targetDate,
  });

  @override
  List<Object?> get props => [orderId, beneficiaryName, targetDate];
}
