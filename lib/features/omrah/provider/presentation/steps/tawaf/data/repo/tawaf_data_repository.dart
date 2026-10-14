import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/instruction_model.dart';

class TawafDataRepository {
  List<InstructionModel> get getTawafData => _list;

  // bool get isAllItemsSelected => _list.every((element) => element.isSelected);

  final List<InstructionModel> _list = [
    InstructionModel(
      title: appLocalizer.tawafInstruction1Title,
      description: appLocalizer.tawafInstruction1Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.tawafInstruction2Title,
      description: appLocalizer.tawafInstruction2Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.tawafInstruction3Title,
      description: appLocalizer.tawafInstruction3Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.tawafInstruction4Title,
      description: appLocalizer.tawafInstruction4Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.tawafInstruction5Title,
      description: appLocalizer.tawafInstruction5Desc,
      isSelected: false,
    ),
  ];

  void selectItem(int index) {
    _list[index] = _list[index].copyWith(isSelected: true);
  }
}
