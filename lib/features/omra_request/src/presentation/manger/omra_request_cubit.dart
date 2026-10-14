part of omra_request;

@lazySingleton
class OmraRequestCubit extends BaseCubit<OmraRequestState> {
  final CreateOmraOrderUseCase _createOmraOrderUseCase;

  OmraRequestCubit(this._createOmraOrderUseCase)
    : super(
        OmraRequestState(
          isCheck: false,
          omraTypeSelected: '',
          omraTypes: [
            OmraSetting(title: appLocalizer.sick, data: OmraConst.KEY_SICK),
            OmraSetting(
              title: appLocalizer.helpless,
              data: OmraConst.KEY_HELPLESS,
            ),
            OmraSetting(
              title: appLocalizer.deceased,
              data: OmraConst.KEY_DECEASED,
            ),
            OmraSetting(title: appLocalizer.martyr, data: OmraConst.KEY_MARTYR),
          ],
          dateStarted: '',
          date: DateTime.now(),
          genderSelected: 'male',
          gender: [
            OmraSetting(
              title: appLocalizer.male,
              data: 'male',
              isSelected: true,
            ),
            OmraSetting(
              title: appLocalizer.female,
              data: 'female',
              isSelected: false,
            ),
          ],
        ),
      );

  void selectOmraType(String typeData) {
    final updatedTypes = state.omraTypes.map((type) {
      return OmraSetting(
        title: type.title,
        data: type.data,
        isSelected: type.data == typeData,
      );
    }).toList();
    emit(state.copyWith(omraTypeSelected: typeData, omraTypes: updatedTypes));
  }

  void updateCheck(bool value) {
    if (!value) {
      emit(state.copyWith(isCheck: false, clearSelectedPilgrim: true));
    } else {
      emit(state.copyWith(isCheck: true));
    }
  }

  void clearPilgrim() {
    emit(state.copyWith(clearSelectedPilgrim: true));
  }

  void updateBeneficiaryName(String name) {
    emit(state.copyWith(beneficiaryName: name));
  }

  void updateCustomDua(String dua) {
    emit(state.copyWith(customDua: dua));
  }

  void selectGender(String genderData) {
    final updatedGender = state.gender.map((g) {
      return OmraSetting(
        title: g.title,
        data: g.data,
        isSelected: g.data == genderData,
      );
    }).toList();
    emit(state.copyWith(genderSelected: genderData, gender: updatedGender));
  }

  void updateDate(DateTime newDate) {
    final dateStr = '${newDate.day}-${newDate.month}-${newDate.year}';
    emit(state.copyWith(date: newDate, dateStarted: dateStr));
  }

  void showDateDialog(BuildContext context) async {
    final firstAvailable = DateUtils.dateOnly(
      DateTime.now(),
    ).add(const Duration(days: 0));
    final initial = state.date.isBefore(firstAvailable)
        ? firstAvailable
        : state.date;
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstAvailable,
      lastDate: DateTime(2050),
    );
    if (newDate != null) {
      updateDate(newDate);
    }
  }

  // Pilgrims methods
  void selectPilgrim(ProviderEntity pilgrim) {
    emit(state.copyWith(selectedPilgrim: pilgrim));
  }

  Future<void> submitOrder() async {
    if (state.beneficiaryName.trim().isEmpty ||
        state.omraTypeSelected.isEmpty ||
        state.genderSelected.isEmpty ||
        state.dateStarted.isEmpty) {
      emit(
        state.copyWith(
          validationStatus: StateBox.failure(
            Failure(appLocalizer.enterRequiredFields),
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        submitStatus: const StateBox.loading(),
        validationStatus: const StateBox.initial(),
      ),
    );

    await collect(
      task: () async {
        final targetDateStr =
            '${state.date.year}-${state.date.month.toString().padLeft(2, '0')}-${state.date.day.toString().padLeft(2, '0')}';

        await _createOmraOrderUseCase.execute(
          beneficiaryType: state.omraTypeSelected.toUpperCase(),
          beneficiaryName: state.beneficiaryName,
          beneficiaryGender: state.genderSelected.toUpperCase(),
          customDua: state.customDua,
          targetDate: targetDateStr,
          preferredProviderId: state.isCheck
              ? state.selectedPilgrim?.userId
              : null,
        );

        emit(state.copyWith(submitStatus: const StateBox.success(null)));
      },
      onError: (failure) {
        emit(state.copyWith(submitStatus: StateBox.failure(failure)));
      },
    );
  }

  void clearData() {
    emit(
      OmraRequestState(
        isCheck: false,
        omraTypeSelected: '',
        omraTypes: [
          OmraSetting(
            title: appLocalizer.sick,
            data: OmraConst.KEY_SICK,
          ), // مريض
          OmraSetting(
            title: appLocalizer.helpless, //عاجز
            data: OmraConst.KEY_HELPLESS,
          ),
          OmraSetting(
            title: appLocalizer.deceased, // متوفى
            data: OmraConst.KEY_DECEASED,
          ),
          OmraSetting(
            title: appLocalizer.martyr,
            data: OmraConst.KEY_MARTYR,
          ), // شهيد
        ],
        dateStarted: '',
        date: DateTime.now(),
        genderSelected: 'male',
        gender: [
          OmraSetting(title: appLocalizer.male, data: 'male', isSelected: true),
          OmraSetting(
            title: appLocalizer.female,
            data: 'female',
            isSelected: false,
          ),
        ],
        resetKey: state.resetKey + 1,
      ),
    );
  }
}
