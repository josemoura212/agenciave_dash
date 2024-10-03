import 'package:agenciave_dash/models/cartesian_model.dart';
import 'package:agenciave_dash/models/chart_model.dart';
import 'package:agenciave_dash/models/date_model.dart';
import 'package:agenciave_dash/models/grid_model.dart';
import 'package:agenciave_dash/models/raw_sale_model.dart';
import 'package:agenciave_dash/models/weekday_model.dart';
import 'package:intl/intl.dart';

class ProcessedSaleModel {
  final List<WeekdayModel> weekdayData;
  final List<CartesianModel> hourData;
  final List<CartesianModel> status;
  final List<ChartModel> origemData;
  final List<ChartModel> stateData;
  final List<ChartModel> paymentTypeData;
  final List<ChartModel> paymentTypeOfferData;
  final List<ChartModel> countryData;
  final GridMediaModel mediaData;
  final List<DateModel> dateData;
  final List<BuyerModel> buyerData;
  final int totalSales;
  final String totalInvoicing;
  final String totalCommission;

  ProcessedSaleModel({
    required this.weekdayData,
    required this.hourData,
    required this.status,
    required this.origemData,
    required this.stateData,
    required this.dateData,
    required this.paymentTypeData,
    required this.paymentTypeOfferData,
    required this.countryData,
    required this.mediaData,
    required this.totalSales,
    required this.buyerData,
    required this.totalCommission,
    required this.totalInvoicing,
  });

  ProcessedSaleModel.empty()
      : weekdayData = [],
        hourData = [],
        status = [],
        origemData = [],
        stateData = [],
        paymentTypeData = [],
        paymentTypeOfferData = [],
        countryData = [],
        totalSales = 0,
        mediaData = GridMediaModel.empty(),
        dateData = [],
        buyerData = [],
        totalInvoicing = '',
        totalCommission = '';

  factory ProcessedSaleModel.fromRawModel(List<RawSaleModel> raw) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    final dateData = setDateData(raw);
    final totalInvoicing = raw
        .where(
            (e) => e.status == Status.aproved || e.status == Status.completed)
        .fold<double>(0, (p, e) => p + e.invoicing);

    final totalCommission = raw
        .where(
            (e) => e.status == Status.aproved || e.status == Status.completed)
        .fold<double>(0, (p, e) => p + e.commissionValueGenerated);

    final totalSales = raw
        .where(
            (e) => e.status == Status.aproved || e.status == Status.completed)
        .fold(0, (p, e) => p + e.quantity);

    return ProcessedSaleModel(
      weekdayData: setWeekdayData(raw),
      hourData: setCartesianData(raw, TypeData.hour),
      status: setCartesianData(raw, TypeData.status),
      origemData: setChartData(raw, TypeData.origem),
      stateData: setChartData(raw, TypeData.state),
      dateData: dateData,
      paymentTypeData: setChartData(raw, TypeData.paymentType),
      paymentTypeOfferData: setChartData(raw, TypeData.paymentTypeOffer),
      countryData: setChartData(raw, TypeData.country),
      mediaData: setGridMediaData(dateData),
      totalSales: totalSales,
      totalCommission: formatter.format(totalCommission),
      totalInvoicing: formatter.format(totalInvoicing),
      buyerData: [],
    );
  }
}

enum TypeData {
  weekday,
  hour,
  status,
  origem,
  state,
  paymentType,
  paymentTypeOffer,
  country,
  media,
  buyer,
}

class BuyerModel {
  final String name;
  final String email;
  final String phone;
  final Status status;

  BuyerModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
  });
}
