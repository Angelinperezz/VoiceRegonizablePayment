class Destinatario {
  String alias;
  String cedula;
  String telefono;
  String banco;

  // Otros atributos del destinatario

  Destinatario(this.alias, this.cedula, this.telefono, this.banco);

}

class ConfirmDestinatario{


  Destinatario? confirmAlias(String alias) {
    List<Destinatario> listaDestinatarios = [
      Destinatario('Marco','258','04125596633','0102'),
      Destinatario('Eduardo','123','04120798865','0102'),
      Destinatario('Jose','125','04120298865','0102'),
      Destinatario('Angelin','143','04121798865','0102'),
      Destinatario('Cesar','145','04121798762','0102'),
      // Agregar más destinatarios aquí
    ];

    for (var destinatario in listaDestinatarios) {
      if (destinatario.alias.toLowerCase()==(alias.toLowerCase())) {
        print(destinatario.alias);
        return destinatario;
      }
    }
    print(null);

    return null;
  }
}

class SearchDestinatario{

  List<Destinatario> filtrarDestinatarios(List<Destinatario> lista, String filtro) {
    List<Destinatario> resultado = [];

    for (var destinatario in lista) {
      if (destinatario.alias.toLowerCase().contains(filtro.toLowerCase())) {
        resultado.add(destinatario);

      }
    }

    return resultado;
  }

  List<Destinatario> filtro(String alias) {
    List<Destinatario> listaDestinatarios = [
      Destinatario('Amigo1','258','04125596633','0102'),
      Destinatario('Amigo2','123','04120798865','0102'),
      Destinatario('Familia','125','04120298865','0102'),
      Destinatario('Familia2','143','04121798865','0102'),
      // Agregar más destinatarios aquí
    ];

    String filtro = alias;

    List<Destinatario> destinatariosFiltrados = filtrarDestinatarios(listaDestinatarios, filtro);

    print('Destinatarios encontrados:');
    for (var destinatario in destinatariosFiltrados) {
      print(destinatario.alias);
    }
    return destinatariosFiltrados;
  }
}