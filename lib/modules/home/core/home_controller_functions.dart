part of 'home_controller.dart';

mixin _HomeControllerFunctions on _HomeControllerVariables {
  Future<void> changeRelease(bool toglee, {bool initial = false}) async {
    final start = 0;
    final end = release.length;
    final current = _selectedRelease.value;
    if (initial) {
      final releaseResult =
          await _localStore.read(LocalStorageConstants.release);
      if (releaseResult != null) {
        _selectedRelease.set(int.parse(releaseResult), force: true);
        _rangeStartDay.set(release[releaseResult]![0], force: true);
        _rangeEndDay.set(release[releaseResult]![1], force: true);
        _focusedDay.set(release[releaseResult]![0].add(Duration(days: 1)),
            force: true);
        _rangeSelectionMode.value = RangeSelectionMode.toggledOn;
        _setHomeData(_homeDataBackup.value);
        return;
      }
      _selectedRelease.set(1, force: true);
      _rangeStartDay.set(release["1"]![0], force: true);
      _rangeEndDay.set(release["1"]![1], force: true);
      _focusedDay.set(release["1"]![0].add(Duration(days: 1)), force: true);
      _rangeSelectionMode.value = RangeSelectionMode.toggledOn;
      _setHomeData(_homeDataBackup.value);
      return;
    }
    if (toglee) {
      if (current != end) {
        _selectedRelease.set(current + 1);
      }
    } else {
      if (current != start) {
        _selectedRelease.set(current - 1);
      }
    }
    _rangeStartDay.value = release[_selectedRelease.value.toString()]![0];
    _rangeEndDay.value = release[_selectedRelease.value.toString()]![1];
    _focusedDay.value =
        release[_selectedRelease.value.toString()]![0].add(Duration(days: 1));
    _rangeSelectionMode.value = RangeSelectionMode.toggledOn;
    _setHomeData(_homeDataBackup.value);
    await _localStore.write(
        LocalStorageConstants.release, _selectedRelease.value.toString());
  }

  void _setHomeData(List<RawSaleModel> data) {
    if (_selectedDay.value != null) {
      final filteredData = data.where((item) {
        final normalizedSaleDate = DateTime(
            item.saleDate.year, item.saleDate.month, item.saleDate.day);

        return isSameDay(normalizedSaleDate, _selectedDay.value);
      }).toList();
      _setChartData(filteredData);
    } else if (_rangeStartDay.value != null && _rangeEndDay.value != null) {
      final filteredData = data.where((item) {
        final normalizedSaleDate = DateTime(
            item.saleDate.year, item.saleDate.month, item.saleDate.day);
        final normalizedStartDate = DateTime(_rangeStartDay.value!.year,
            _rangeStartDay.value!.month, _rangeStartDay.value!.day);
        final normalizedEndDate = DateTime(_rangeEndDay.value!.year,
            _rangeEndDay.value!.month, _rangeEndDay.value!.day);

        return normalizedSaleDate.isAfter(
                normalizedStartDate.subtract(const Duration(days: 1))) &&
            normalizedSaleDate
                .isBefore(normalizedEndDate.add(const Duration(days: 1)));
      }).toList();

      _setChartData(filteredData);
    } else {
      _setChartData(data);
    }
  }

  void _setChartData(List<RawSaleModel> data) {
    _homeData.set(data, force: true);
    _processedSaleData.set(ProcessedSaleModel.fromRawModel(data), force: true);
  }

  final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  void resetSelectedDate() {
    DateTime now = DateTime.now();
    if (_rangeSelectionMode.value == RangeSelectionMode.toggledOn) {
      _rangeStartDay.value = null;
      _rangeEndDay.value = null;
    } else {
      _selectedDay.value = null;
    }
    _focusedDay.value = now;
    if (_homeData.value.length != _homeDataBackup.value.length) {
      _setHomeData(_homeDataBackup.value);
    }
  }

  void onRangeSelectionModeChanged() {
    final mode = _rangeSelectionMode.value == RangeSelectionMode.toggledOff
        ? RangeSelectionMode.toggledOn
        : RangeSelectionMode.toggledOff;
    _rangeSelectionMode.value = mode;
    resetSelectedDate();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay.value = selectedDay;
    _focusedDay.value = focusedDay;

    _rangeStartDay.value = null;
    _rangeEndDay.value = null;
    _setHomeData(_homeDataBackup.value);
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    if (_rangeStartDay.value != null && _rangeEndDay.value != null) {
      return;
    }

    if (start != null) {
      _rangeStartDay.value = start;
      _focusedDay.value = start;
    }

    if (end != null) {
      _rangeEndDay.value = end;
    }

    if (start != null && end != null) {
      if (start.isAfter(end)) {
        _rangeStartDay.value = end;
        _rangeEndDay.value = start;
        _focusedDay.value = end;
      }
    }

    _selectedDay.value = null;

    _setHomeData(_homeDataBackup.value);
  }

  void toggleShowHide(ShowAndHide showHide) {
    switch (showHide) {
      case ShowAndHide.settings:
        _showSettings.value = !_showSettings.value;
        _localStore.writeBool(showHide.toString(), _showSettings.value);
        break;
      case ShowAndHide.origem:
        _showOrigen.value = !_showOrigen.value;
        _localStore.writeBool(showHide.toString(), _showOrigen.value);
        break;
      case ShowAndHide.state:
        _showState.value = !_showState.value;
        _localStore.writeBool(showHide.toString(), _showState.value);
        break;
      case ShowAndHide.paymentType:
        _showPaymentType.value = !_showPaymentType.value;
        _localStore.writeBool(showHide.toString(), _showPaymentType.value);
        break;
      case ShowAndHide.paymentTypeOffer:
        _showPaymentTypeOffer.value = !_showPaymentTypeOffer.value;
        _localStore.writeBool(showHide.toString(), _showPaymentTypeOffer.value);
        break;
      case ShowAndHide.gridMedia:
        _showGridMedia.value = !_showGridMedia.value;
        _localStore.writeBool(showHide.toString(), _showGridMedia.value);
        break;
      case ShowAndHide.weekday:
        _showWeekday.value = !_showWeekday.value;
        _localStore.writeBool(showHide.toString(), _showWeekday.value);
        break;
      case ShowAndHide.hour:
        _showHour.value = !_showHour.value;
        _localStore.writeBool(showHide.toString(), _showHour.value);
        break;
      case ShowAndHide.status:
        _showStatus.value = !_showStatus.value;
        _localStore.writeBool(showHide.toString(), _showStatus.value);
        break;
      case ShowAndHide.recovery:
        _showRecovery.value = !_showRecovery.value;
        _localStore.writeBool(showHide.toString(), _showRecovery.value);
        break;
      case ShowAndHide.country:
        _showCountry.value = !_showCountry.value;
        _localStore.writeBool(showHide.toString(), _showCountry.value);
        break;
    }
  }
}
