part of media_utils;

enum UploadDirectory{
  avatars,
  introMedia,
  certificates,
  providerIdentification,
  stories,
  ritualProofs,
  rituals,
  beneficiaryImages,
  documents,
  dua;

  String toApi(){
    switch(this) {
      case UploadDirectory.avatars:
        return "avatars";
      case UploadDirectory.introMedia:
        return "intro-media";
      case UploadDirectory.certificates:
        return "certificates";
      case UploadDirectory.providerIdentification:
        return "provider-identification";
      case UploadDirectory.stories:
        return "stories";
      case UploadDirectory.ritualProofs:
        return "ritual-proofs";
      case UploadDirectory.rituals:
        return "omrah";
      case UploadDirectory.beneficiaryImages:
        return "beneficiary-images";
      case UploadDirectory.documents:
        return "documents";
      case UploadDirectory.dua:
        return "dua";
    }

  }
}