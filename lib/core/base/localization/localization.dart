library localization;

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:injectable/injectable.dart';
import 'package:moneeb/core/config/config.dart';

import '../../../l10n/app_localizations.dart';
import '../../../l10n/app_localizations_ar.dart';
export '../../../l10n/app_localizations.dart';
import '../../utils/utils_imports.dart';
import '../di/data_injector.dart';
import '../helpers/helpers.dart';

part 'src/manger/app_language_cubit.dart';
part 'src/manger/app_language_state.dart';
part 'src/localization_container.dart';

part 'src/enums/lang_code_enum.dart';
part 'src/data/language_repo.dart';

extension LocalizationExt on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this);
}