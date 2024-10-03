import 'package:agenciave_dash/models/cartesian_model.dart';
import 'package:agenciave_dash/models/chart_model.dart';
import 'package:agenciave_dash/models/grid_model.dart';
import 'package:agenciave_dash/models/raw_sale_model.dart';
import 'package:agenciave_dash/models/weekday_model.dart';

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
  final List<BuyerModel> buyerData;
  final double totalInvoicing;
  final double totalCommission;

  ProcessedSaleModel({
    required this.weekdayData,
    required this.hourData,
    required this.status,
    required this.origemData,
    required this.stateData,
    required this.paymentTypeData,
    required this.paymentTypeOfferData,
    required this.countryData,
    required this.mediaData,
    required this.buyerData,
    required this.totalCommission,
    required this.totalInvoicing,
  });

  // factory ProcessedSaleModel.fromRawModel({List<RawSaleModel> raw}) {
  //   final List<WeekdayModel> weekdayData = [];
  //   final List<CartesianModel> hourData = [];
  //   final List<CartesianModel> status = [];
  //   final List<ChartModel> origemData = [];
  //   final List<ChartModel> stateData = [];
  //   final List<ChartModel> paymentTypeData = [];
  //   final List<ChartModel> paymentTypeOfferData = [];
  //   final List<ChartModel> countryData = [];
  //   final GridMediaModel mediaData = GridMediaModel(
  //     mediaDiaria: MediaDiaria(
  //       vendas: 0,
  //       mediaFaturamento: "0.0",
  //       mediaReceita: "0.0",
  //     ),
  //     mediaMensal: MediaMensal(
  //       vendas: 0,
  //       mediaFaturamento: "0.0",
  //       mediaReceita: "0.0",
  //     ),
  //   );
  //   final List<BuyerModel> buyerData = [];
  //   double totalInvoicing = 0;
  //   double totalCommission = 0;

  //   for (var element in raw) {

  //   }
  // }
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
