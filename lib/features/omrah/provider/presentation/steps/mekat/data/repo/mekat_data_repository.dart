import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/instruction_model.dart';

class MekatDataRepository {
  List<InstructionModel> get getMekatData => _list;

  // bool get isAllItemsSelected => _list.every((element) => element.isSelected);

  final List<InstructionModel> _list = [
    InstructionModel(
      title: appLocalizer.mekatInstruction1Title,
      description: appLocalizer.mekatInstruction1Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.mekatInstruction2Title,
      description: appLocalizer.mekatInstruction2Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.mekatInstruction3Title,
      description: appLocalizer.mekatInstruction3Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.mekatInstruction4Title,
      description: appLocalizer.mekatInstruction4Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.mekatInstruction5Title,
      description: appLocalizer.mekatInstruction5Desc,
      isSelected: false,
    ),
  ];

  void selectItem(int index) {
    _list[index] = _list[index].copyWith(isSelected: true);
  }
}
