import 'package:equatable/equatable.dart';

class InstructionModel extends Equatable {
  final String title;
  final String description;
  final bool isSelected;
  const InstructionModel({
    required this.title,
    required this.description,
    required this.isSelected,
  });

  InstructionModel copyWith({
    String? title,
    String? description,
    bool? isSelected,
  }) {
    return InstructionModel(
      title: title ?? this.title,
      description: description ?? this.description,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [title, description, isSelected];
}
