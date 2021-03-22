class Cliente {
  int id;
  String nome;
  String email;
  String cpf;
  int cep;
  String endereco;
  String numero;
  String bairro;
  String cidade;
  String uf;
  String pais;
  String foto;

  Cliente(
      {this.id,
        this.nome,
        this.email,
        this.cpf,
        this.cep,
        this.endereco,
        this.numero,
        this.bairro,
        this.cidade,
        this.uf,
        this.pais,
        this.foto});

  Cliente.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    cpf = json['cpf'];
    cep = json['cep'];
    endereco = json['endereco'];
    numero = json['numero'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    uf = json['uf'];
    pais = json['pais'];
    foto = json['foto'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['cpf'] = this.cpf;
    data['cep'] = this.cep;
    data['endereco'] = this.endereco;
    data['numero'] = this.numero;
    data['bairro'] = this.bairro;
    data['cidade'] = this.cidade;
    data['uf'] = this.uf;
    data['pais'] = this.pais;
    data['foto'] = this.foto;
    return data;
  }
}