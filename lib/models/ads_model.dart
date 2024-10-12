class AdsModel {
  final String nomeCampanha;
  final String statusVeiculacao;
  final String nivelVeiculacao;
  final String nomeConjuntoAnuncios;
  final String configuracaoAtribuicao;
  final String tipoResultado;
  final int resultados;
  final int alcance;
  final int impressoes;
  final double custoPorResultado;
  final String classificacaoQualidade;
  final String classificacaoTaxaEngajamento;
  final String classificacaoTaxaConversao;
  final double valorUsado;
  final DateTime inicioRelatorios;
  final DateTime terminoRelatorios;

  AdsModel({
    required this.nomeCampanha,
    required this.statusVeiculacao,
    required this.nivelVeiculacao,
    required this.nomeConjuntoAnuncios,
    required this.configuracaoAtribuicao,
    required this.tipoResultado,
    required this.resultados,
    required this.alcance,
    required this.impressoes,
    required this.custoPorResultado,
    required this.classificacaoQualidade,
    required this.classificacaoTaxaEngajamento,
    required this.classificacaoTaxaConversao,
    required this.valorUsado,
    required this.inicioRelatorios,
    required this.terminoRelatorios,
  });

  AdsModel.empty()
      : nomeCampanha = '',
        statusVeiculacao = '',
        nivelVeiculacao = '',
        nomeConjuntoAnuncios = '',
        configuracaoAtribuicao = '',
        tipoResultado = '',
        resultados = 0,
        alcance = 0,
        impressoes = 0,
        custoPorResultado = 0.0,
        classificacaoQualidade = '',
        classificacaoTaxaEngajamento = '',
        classificacaoTaxaConversao = '',
        valorUsado = 0.0,
        inicioRelatorios = DateTime(1970),
        terminoRelatorios = DateTime(1970);

  factory AdsModel.fromMap(Map<String, dynamic> map) {
    return AdsModel(
      nomeCampanha: map['Nome da campanha'],
      statusVeiculacao: map['Status de veiculação'],
      nivelVeiculacao: map['Nível de veiculação'],
      nomeConjuntoAnuncios: map['Nome do conjunto de anúncios'],
      configuracaoAtribuicao: map['Configuração de atribuição'],
      tipoResultado: map['Tipo de resultado'],
      resultados: map['Resultados'],
      alcance: map['Alcance'],
      impressoes: map['Impressões'],
      custoPorResultado: map['Custo por resultado'],
      classificacaoQualidade: map['Classificação de qualidade'],
      classificacaoTaxaEngajamento: map['Classificação da taxa de engajamento'],
      classificacaoTaxaConversao: map['Classificação da taxa de conversão'],
      valorUsado: map['Valor usado (BRL)'],
      inicioRelatorios: DateTime.parse(map['Início dos relatórios']),
      terminoRelatorios: DateTime.parse(map['Término dos relatórios']),
    );
  }
}
