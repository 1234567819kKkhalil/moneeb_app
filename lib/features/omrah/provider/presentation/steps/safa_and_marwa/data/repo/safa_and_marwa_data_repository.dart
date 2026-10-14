import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/instruction_model.dart';

class SafaAndMarwaDataRepository {
  List<InstructionModel> get getSafaAndMarwaData => _list;

  // bool get isAllItemsSelected => _list.every((element) => element.isSelected);

  final List<InstructionModel> _list = [
    InstructionModel(
      title: appLocalizer.safaMarwaInstruction1Title,
      description: appLocalizer.safaMarwaInstruction1Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.safaMarwaInstruction2Title,
      description: appLocalizer.safaMarwaInstruction2Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.safaMarwaInstruction3Title,
      description: appLocalizer.safaMarwaInstruction3Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.safaMarwaInstruction4Title,
      description: appLocalizer.safaMarwaInstruction4Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.safaMarwaInstruction5Title,
      description: appLocalizer.safaMarwaInstruction5Desc,
      isSelected: false,
    ),
    InstructionModel(
      title: appLocalizer.safaMarwaInstruction6Title,
      description: appLocalizer.safaMarwaInstruction6Desc,
      isSelected: false,
    ),
  ];

  void selectItem(int index) {
    _list[index] = _list[index].copyWith(isSelected: true);
  }
}
