import 'dart:convert';

import 'package:intl/intl.dart';

class HomeModel {
  int nowNumber;
  String id;
  String nameProduct;
  String origin;
  DateTime saleDate;
  int quantity;
  double invoicing;
  String coin;
  int recurrenceNumber;
  String status;
  String country;
  String state;
  String paymentType;
  String paymenteTypeOffer;
  double commissionValueGenerated;
  String name;
  String email;
  String phone;

  HomeModel({
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

  factory HomeModel.empty() {
    return HomeModel(
      nowNumber: 0,
      id: '',
      nameProduct: '',
      origin: '',
      saleDate: DateTime.now(),
      quantity: 0,
      invoicing: 0.0,
      coin: '',
      recurrenceNumber: 0,
      status: "empty",
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

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      nowNumber: map['row_number']?.toInt() ?? 0,
      id: map['ID'] ?? '',
      nameProduct: map['Nome do Produto'] ?? '',
      origin: map['Origem'] ?? '',
      saleDate: toDate(map['Data de Venda']),
      quantity: map['Qtd.']?.toInt() ?? 0,
      invoicing: map['Faturamento']?.toDouble() ?? 0.0,
      coin: map['Moeda'] ?? '',
      recurrenceNumber: map['Número da Parcela']?.hashCode ?? 0,
      status: map['Status'] ?? '',
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

  String toJson() => json.encode(toMap());

  factory HomeModel.fromJson(String source) =>
      HomeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HomeModel(nowNumber: $nowNumber, id: $id, nameProduct: $nameProduct, origin: $origin, saleDate: $saleDate, quantity: $quantity, invoicing: $invoicing, coin: $coin, recurrenceNumber: $recurrenceNumber, status: $status, country: $country, state: $state, paymentType: $paymentType, paymenteTypeOffer: $paymenteTypeOffer, commissionValueGenerated: $commissionValueGenerated), name: $name, email: $email, phone: $phone';
  }
}

DateTime toDate(String date) {
  DateFormat format = DateFormat("dd/MM/yyyy HH:mm");
  return format.parse(date);
}
