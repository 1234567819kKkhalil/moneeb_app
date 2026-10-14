part of app_material;

class BlockerLoaderInfoModel extends Equatable{
  final bool isLoading;
  final String? text;
  const BlockerLoaderInfoModel({required this.isLoading, this.text});

  @override
  List<Object?> get props => [isLoading,text];
}