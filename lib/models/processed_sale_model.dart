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
    final totalInvoicing = raw.fold<double>(0, (p, e) => p + e.invoicing);

    final totalCommission =
        raw.fold<double>(0, (p, e) => p + e.commissionValueGenerated);

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
      totalSales: raw.fold(0, (p, e) => p + e.quantity),
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

enum Status {
  aproved,
  canceled,
  refunded,
  completed,
  awaitPayment,
  chargeback,
  expired,
  disputed,
  billetPrint,
  denied,
  latePayment,
  others;

  String get name {
    switch (this) {
      case Status.aproved:
        return 'Aprovado';
      case Status.canceled:
        return 'Cancelado';
      case Status.refunded:
        return 'Reembolsado';
      case Status.disputed:
        return 'Pedido de reembolso';
      case Status.expired:
        return 'Expirado';
      case Status.completed:
        return 'Concluído';
      case Status.billetPrint:
        return 'Boleto Impresso';
      case Status.awaitPayment:
        return 'Aguardando Pagamento';
      case Status.chargeback:
        return 'Chargeback';
      case Status.denied:
        return 'Negado';
      case Status.latePayment:
        return 'Pagamento Atrasado';
      default:
        return 'Outros';
    }
  }

  factory Status.fromString(String status) {
    switch (status.toLowerCase()) {
      case 'aprovado' || 'aproved':
        return Status.aproved;
      case 'pendente' || "delayed":
        return Status.canceled;
      case 'reembolsado':
        return Status.refunded;
      case 'disputado' || "disputed":
        return Status.disputed;
      case 'boleto impresso' || "billet_printed":
        return Status.billetPrint;
      case 'expirado' || "expired":
        return Status.expired;
      case 'completo' || "completed":
        return Status.completed;
      case 'aguardando pagto':
        return Status.awaitPayment;
      case 'chargeback':
        return Status.chargeback;
      case 'negado' || "denied":
        return Status.denied;
      case 'pagamento atrasado':
        return Status.latePayment;
      default:
        return Status.others;
    }
  }
}
