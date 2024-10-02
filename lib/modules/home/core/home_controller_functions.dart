part of 'home_controller.dart';

mixin _HomeControllerFunctions on _HomeControllerVariables {
  Future<void> changeRelease(bool toglee, {bool initial = false}) async {
    final start = 0;
    final end = release.length;
    final current = selectedRelease;
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
    _rangeStartDay.value = release[selectedRelease.toString()]![0];
    _rangeEndDay.value = release[selectedRelease.toString()]![1];
    _focusedDay.value =
        release[selectedRelease.toString()]![0].add(Duration(days: 1));
    _rangeSelectionMode.value = RangeSelectionMode.toggledOn;
    _setHomeData(_homeDataBackup.value);
    await _localStore.write(
        LocalStorageConstants.release, selectedRelease.toString());
  }

  void _setHomeData(List<HomeModel> data) {
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
        final normalizedStartDate = DateTime(
            rangeStartDay!.year, rangeStartDay!.month, rangeStartDay!.day);
        final normalizedEndDate =
            DateTime(rangeEndDay!.year, rangeEndDay!.month, rangeEndDay!.day);

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

  void _setChartData(List<HomeModel> data) {
    var dataResult = data
        .where((item) =>
            item.status == "Aprovado" ||
            item.status == "APPROVED" ||
            item.status == "Completo" ||
            item.status == "COMPLETED")
        .toList();
    _homeData.set(data, force: true);
    _dateData.set(setDateData(dataResult), force: true);

    _origemData.set(setOrigemData(dataResult), force: true);
    _stateData.set(setStateData(dataResult), force: true);

    _totalVendas.set(dataResult.length, force: true);
    _calcTotalFaturamento();
    _calcTotalReceita();
    _gridMediaData.set(setGridMediaData(dateData));
    _hourData.set(setHourData(dataResult), force: true);
    _weekdayData.set(setWeekdayData(dataResult), force: true);
  }

  void _calcTotalFaturamento() {
    final total = homeData.fold<double>(
        0, (previusValue, element) => previusValue + element.invoicing);

    _totalFaturamento.set(formatter.format(total));
  }

  void _calcTotalReceita() {
    final total = homeData.fold<double>(
        0,
        (previusValue, element) =>
            previusValue + element.commissionValueGenerated);
    _totalReceita.set(formatter.format(total));
  }

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
    final mode = rangeSelectionMode == RangeSelectionMode.toggledOff
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

  void toogleSettings() {
    _showSettings.value = !_showSettings.value;
  }

  void toogleOrigen() {
    _showOrigen.value = !_showOrigen.value;
  }

  void toogleState() {
    _showState.value = !_showState.value;
  }
}
