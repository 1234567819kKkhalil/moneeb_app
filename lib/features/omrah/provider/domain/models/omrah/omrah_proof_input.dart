import 'package:equatable/equatable.dart';
import 'package:moneeb/core/base/media_utils/media_utils.dart';

class OmrahProofInput extends Equatable {
  final String? proofImageFileId;
  final String? proofVideoFileId;

  const OmrahProofInput({this.proofImageFileId, this.proofVideoFileId});

  factory OmrahProofInput.fromAttachment({required Attachment attachment}){
    if(attachment.type == AttachmentTypeEnum.photo){
      return OmrahProofInput(
        proofImageFileId: attachment.id
      );
    } else {
      return OmrahProofInput(
        proofVideoFileId: attachment.id
      );
    }
  }


  factory OmrahProofInput.fromJson(Map<String, dynamic> json) {
    return OmrahProofInput(
      proofImageFileId: json['proofImageFileId'],
      proofVideoFileId: json['proofVideoFileId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (proofImageFileId != null) 'proofImageFileId': proofImageFileId,
      if (proofVideoFileId != null) 'proofVideoFileId': proofVideoFileId,
    };
  }

  @override
  List<Object?> get props => [proofImageFileId, proofVideoFileId];
}
