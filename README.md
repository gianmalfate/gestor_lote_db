<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="https://cdn-icons-png.flaticon.com/512/9850/9850812.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Gestor Lote - CUB</h3>

  <p align="center">
    Sistema de gerenciamento de loteamentos desenvolvido em Python, que permite consultar e remover dados, listar contratos, gerar relatórios de recebíveis em aberto, unidades com saldo devedor e parcelas pagas com atraso, integrado a um banco de dados PostgreSQL.
  </p>
</div>


## Instalação

1. Crie um banco de dados PostgreSQL, e execute os comandos
    - GestorLote_DDL.sql
    - GestorLote_DML.sql

    Eles realizaram a criação da instância do banco de dados e inserção de dados fictícios.

2. Instalação de dependências
    ```
    pip install psycopg2-binary
    pip install python-dotenv
    pip install tabulate
    ```

3. Configurar variáveis de ambiente
    - Crie um arquivo '.env' com a seguinte estrutura:
    
    ```
    DB_NAME=nome_do_banco_de_dados
    DB_USER=nome_do_usuario
    DB_PASSWORD=senha_do_usuario
    DB_HOST=endereco_do_host
    DB_PORT=porta_do_host
    ```

# Utilização

Para utilizar o script, basta executar o arquivo ``main.py`` com o seguinte código:

```
python main.py
```

Com isso você já poderá realizar consultas nos dados e excluílos!
