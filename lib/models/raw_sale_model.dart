import 'package:intl/intl.dart';

class RawSaleModel {
  int nowNumber;
  String id;
  String nameProduct;
  String origin;
  DateTime saleDate;
  int quantity;
  double invoicing;
  String coin;
  int recurrenceNumber;
  Status status;
  String country;
  String state;
  String paymentType;
  String paymenteTypeOffer;
  double commissionValueGenerated;
  String name;
  String email;
  String phone;

  RawSaleModel({
    required this.nowNumber,
    required this.id,
    required this.nameProduct,
    required this.origin,
    required this.saleDate,
    required this.quantity,
    required this.invoicing,
    required this.coin,
    required this.recurrenceNumber,
    required this.status,
    required this.country,
    required this.state,
    required this.paymentType,
    required this.paymenteTypeOffer,
    required this.commissionValueGenerated,
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'now_number': nowNumber,
      "ID": id,
      'Nome do Produto': nameProduct,
      'Origem': origin,
      'Data de Venda': saleDate,
      'Qtd.': quantity,
      'Faturamento': invoicing,
      'Moeda': coin,
      'Número da Parcela': recurrenceNumber,
      'Status': status,
      'País': country,
      'Estado': state,
      'Tipo de Pagamento': paymentType,
      'Tipo pagamento oferta': paymenteTypeOffer,
      'Valor da Comissão Gerada': commissionValueGenerated,
      'Nome': name,
      'Email': email,
      'Telefone': phone,
    };
  }

  factory RawSaleModel.empty() {
    return RawSaleModel(
      nowNumber: 0,
      id: '',
      nameProduct: '',
      origin: '',
      saleDate: DateTime.now(),
      quantity: 0,
      invoicing: 0.0,
      coin: '',
      recurrenceNumber: 0,
      status: Status.others,
      country: '',
      state: '',
      paymentType: '',
      paymenteTypeOffer: '',
      commissionValueGenerated: 0.0,
      name: '',
      email: '',
      phone: '',
    );
  }

  factory RawSaleModel.fromMap(Map<String, dynamic> map) {
    return RawSaleModel(
      nowNumber: map['row_number']?.toInt() ?? 0,
      id: map['ID'] ?? '',
      nameProduct: map['Nome do Produto'] ?? '',
      origin: map['Origem'] ?? '',
      saleDate: toDate(map['Data de Venda']),
      quantity: map['Qtd.']?.toInt() ?? 0,
      invoicing: map['Faturamento']?.toDouble() ?? 0.0,
      coin: map['Moeda'] ?? '',
      recurrenceNumber: map['Número da Parcela']?.hashCode ?? 0,
      status: Status.fromString(map['Status'] ?? ''),
      country: map['País'] ?? '',
      state: map['Estado'] ?? '',
      paymentType: map['Tipo de Pagamento'] ?? '',
      paymenteTypeOffer: map['Tipo pagamento oferta'] ?? '',
      commissionValueGenerated:
          map['Valor da Comissão Gerada']?.toDouble() ?? 0.0,
      name: map['Nome'] ?? '',
      email: map['Email'] ?? '',
      phone: map['Telefone'].toString(),
    );
  }

  @override
  String toString() {
    return 'HomeModel(nowNumber: $nowNumber, id: $id, nameProduct: $nameProduct, origin: $origin, saleDate: $saleDate, quantity: $quantity, invoicing: $invoicing, coin: $coin, recurrenceNumber: $recurrenceNumber, status: $status, country: $country, state: $state, paymentType: $paymentType, paymenteTypeOffer: $paymenteTypeOffer, commissionValueGenerated: $commissionValueGenerated), name: $name, email: $email, phone: $phone';
  }
}

DateTime toDate(String date) {
  DateFormat format = DateFormat("dd/MM/yyyy HH:mm");
  return format.parse(date);
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
        return 'Pedido de reemb.';
      case Status.expired:
        return 'Expirado';
      case Status.completed:
        return 'Concluído';
      case Status.billetPrint:
        return 'Boleto Impresso';
      case Status.awaitPayment:
        return 'Aguardando Pagto';
      case Status.chargeback:
        return 'Chargeback';
      case Status.denied:
        return 'Negado';
      case Status.latePayment:
        return 'Pagto Atrasado';
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
