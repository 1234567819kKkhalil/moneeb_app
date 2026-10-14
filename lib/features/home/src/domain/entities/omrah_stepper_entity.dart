import 'package:equatable/equatable.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/orders/provider_orders/provider_orders_imports.dart';

class OmrahStepperEntity extends Equatable{
  final OmrahStepsEnum currentStep;
  final String orderId;
  final ForWhomEntity forWhom;

  /// The day the requester wants the umrah done. The provider may not start
  /// the rituals (or be tracked) before it; null when the order has none.
  final DateTime? targetDate;
  const OmrahStepperEntity({required this.currentStep, required this.orderId, required this.forWhom, this.targetDate,});

  OmrahStepperEntity copyWith({
    OmrahStepsEnum? currentStep,
    String? orderId,
  }){
    return OmrahStepperEntity(
      currentStep: currentStep ?? this.currentStep,
      orderId: orderId ?? this.orderId,
      forWhom: forWhom,
      targetDate: targetDate,
    );
  }


  @override
  List<Object?> get props => [currentStep, orderId, forWhom, targetDate,];
}

class ForWhomEntity extends Equatable{
  final String beneficiaryName;
  final BeneficiaryType beneficiaryType;

  const ForWhomEntity({required this.beneficiaryName, required this.beneficiaryType});

  @override
  List<Object?> get props => [beneficiaryName, beneficiaryType];
}