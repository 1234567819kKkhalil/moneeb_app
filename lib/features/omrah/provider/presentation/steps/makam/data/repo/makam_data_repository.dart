import 'package:moneeb/core/base/localization/localization.dart';

import 'package:moneeb/features/omrah/provider/domain/models/omrah/instruction_model.dart';


class MakamDataRepository {
  List<InstructionModel> get getMakamData => _list;

  // bool get isAllItemsSelected => _list.every((element) => element.isSelected);

  final List<InstructionModel> _list = [
    InstructionModel(
      title: appLocalizer.makamInstruction1Title,
      description: appLocalizer.makamInstruction1Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.makamInstruction2Title,
      description: appLocalizer.makamInstruction2Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.makamInstruction3Title,
      description: appLocalizer.makamInstruction3Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.makamInstruction4Title,
      description: appLocalizer.makamInstruction4Desc,
      isSelected: false,
    ),
  ];
  
  void selectItem(int index) {
    _list[index] = _list[index].copyWith(isSelected: true);
  }
}
