import psycopg2
from tabulate import tabulate
import os
from dotenv import load_dotenv

# Carregar variáveis de ambiente do arquivo .env
load_dotenv()

# Configurações do banco de dados
dbname = os.getenv('DB_NAME')
username = os.getenv('DB_USER')
password = os.getenv('DB_PASSWORD')
host = os.getenv('DB_HOST')
port = os.getenv('DB_PORT')

#definindo esquemas para pegar os headers das tabelas
esquemas = {
    "Clientes": ['cliente_id', 'nome', 'cpf_cnpj', 'email', 'status_cliente'],
    "Contratos": ['contrato_id', 'cliente_id', 'unidade_id', 'data_contrato', 'valor_total'],
    "Pagamentos": ['pagamento_id', 'parcela_id', 'data_pagamento', 'valor_pago'],
    "Parcelas": ['parcela_id', 'contrato_id', 'data_vencimento', 'valor_parcela', 'status_parcela'],
    "Unidades": ['unidade_id', 'loteamento', 'quadra', 'lote', 'valor']
}

# Definindo chaves primárias para as tabelas
chaves_primarias = {
    "Clientes": ['cliente_id'],
    "Contratos": ['contrato_id'],
    "Pagamentos": ['pagamento_id'],
    "Parcelas": ['parcela_id'],
    "Unidades": ['unidade_id']
}

def conectar():
    return psycopg2.connect(
        dbname=dbname,
        user=username,
        password=password,
        host=host,
        port=port
    )

def consultar(tabela):
    menu_base()
    print(f"\nConsulta de {tabela}:\n")
    print(f"Aqui estão os detalhes de {tabela}.")

    conn = conectar()
    cur = conn.cursor()
    
    sql = f"SELECT * FROM {tabela}"
    headers = esquemas[tabela]
   
    
    try:
        cur.execute(sql)
        records = cur.fetchall()

        # Montando tabela para apresentação
        table = tabulate(records, headers=headers, tablefmt='fancy_grid', missingval="-")
        print(table)

    except psycopg2.DatabaseError as ex:        
        print("[ERRO] Erro interno na consulta do banco")
        print(ex)

    cur.close()
    conn.close()

    input("Pressione enter para retornar ao menu: ")

def obter_chaves_primarias(tabela):
    """
    Retorna as chaves primárias da tabela especificada.
    """
    if tabela in chaves_primarias:
        return chaves_primarias[tabela]
    else:
        return []

def remover(tabela):
    menu_base()
    print(f"\nRemoção de dados da tabela {tabela}:\n")

    # Obter chaves primárias da tabela
    chaves_primarias = obter_chaves_primarias(tabela)

    # Perguntar ao usuário se ele quer remover todos os dados ou um dado específico
    opcao = input("Digite '*' para remover todos os dados ou '1' para remover um dado específico: ").strip().upper()

    if opcao == '*':
        # Remover todos os dados
        conn = conectar()
        cur = conn.cursor()
        sql = f"DELETE FROM {tabela}"

        try:
            cur.execute(sql)
            conn.commit()
            print(f"Todos os dados da tabela {tabela} foram removidos com sucesso.")
        except psycopg2.DatabaseError as ex:
            print("[ERRO] Erro interno na remoção dos dados")
            print(ex)
        finally:
            cur.close()
            conn.close()

    elif opcao == '1' and chaves_primarias:
        # Remover um dado específico
        condicoes = []
        valores = []

        for chave in chaves_primarias:
            valor = input(f"Digite o valor de {chave}: ").strip()
            condicoes.append(f"{chave} = %s")
            valores.append(valor)

        condicao_sql = " AND ".join(condicoes)
        sql = f"DELETE FROM {tabela} WHERE {condicao_sql}"

        conn = conectar()
        cur = conn.cursor()

        try:
            cur.execute(sql, valores)
            conn.commit()
            if cur.rowcount > 0:
                print(f"O dado específico da tabela {tabela} foi removido com sucesso.")
            else:
                print("Nenhum dado correspondente foi encontrado para remoção.")
        except psycopg2.DatabaseError as ex:
            print("[ERRO] Erro interno na remoção dos dados")
            print(ex)
        finally:
            cur.close()
            conn.close()

    else:
        print("Opção inválida ou tabela sem chaves primárias definidas.")

    input("Pressione enter para retornar ao menu: ")

def resumo_contratos_ativos():
    menu_base()
    print("\nListagem de contratos ativos:\n")

    conn = conectar()
    cur = conn.cursor()
    
    sql = """
            SELECT clientes.nome, CONCAT(unidades.loteamento, ', ', unidades.quadra, ', ', unidades.lote) AS lote_adquirido, contratos.valor_total
            FROM contratos
            JOIN clientes ON contratos.cliente_id = clientes.cliente_id
            JOIN unidades ON contratos.unidade_id = unidades.unidade_id;
            """

    headers = ["Nome Cliente", "Lote Adquirido", "Valor Contrato"]

    try:
        cur.execute(sql)
        records = cur.fetchall()

        table = tabulate(records, headers=headers, tablefmt='fancy_grid', missingval="-")
        print(table)
    except psycopg2.DatabaseError as ex:
        print("[ERRO] Erro interno na consulta do banco")
        print(ex)

    cur.close()
    conn.close()

    input("Pressione enter para retornar ao menu: ")

def recebiveis_em_aberto():
    menu_base()
    print("\nRecebíveis em Aberto:\n")

    conn = conectar()
    cur = conn.cursor()

    sql = f"""
            SELECT CONCAT(contratos.cliente_id, ', ', clientes.nome) AS cliente, SUM(valor_parcela) AS total_em_aberto
            FROM contratos
            JOIN parcelas ON contratos.contrato_id = parcelas.contrato_id
            JOIN clientes ON contratos.cliente_id = clientes.cliente_id
            WHERE parcelas.status_parcela = 'vencida' OR parcelas.status_parcela = 'pendente'
            GROUP BY cliente
            """
    
    headers = ["Cliente", "Total em Aberto"]

    try:
        cur.execute(sql)
        records = cur.fetchall()

        table = tabulate(records, headers=headers, tablefmt='fancy_grid', missingval="-")
        print(table)
    except psycopg2.DatabaseError as ex:
        print("[ERRO] Erro interno na consulta do banco")
        print(ex)

    cur.close()
    conn.close()

    input("Pressione enter para retornar ao menu: ")

def pagamentos_por_loteamento():
    menu_base()
    print("\nTotal de pagamentos realizados nos últimos 12 meses:\n")

    conn = conectar()
    cur = conn.cursor()

    sql = f"""
            SELECT unidades.loteamento, SUM(pagamentos.valor_pago) AS valor_total
            FROM contratos
            JOIN unidades ON contratos.unidade_id = unidades.unidade_id
            JOIN parcelas ON contratos.contrato_id = parcelas.contrato_id
            JOIN pagamentos ON parcelas.parcela_id = pagamentos.parcela_id
            WHERE pagamentos.data_pagamento >= CURRENT_DATE - INTERVAL '12 months'
            GROUP BY unidades.loteamento;
            """
    
    headers = ["Loteamento", "Valor Total"]

    try:
        cur.execute(sql)
        records = cur.fetchall()

        table = tabulate(records, headers=headers, tablefmt='fancy_grid', missingval="-")
        print(table)
    except psycopg2.DatabaseError as ex:
        print("[ERRO] Erro interno na consulta do banco")
        print(ex)

    cur.close()
    conn.close()

    input("Pressione enter para retornar ao menu: ")

def parcelas_pagas_com_atraso():
    menu_base()
    print("\nTodas as parcelas pagas com atraso:\n")

    conn = conectar()
    cur = conn.cursor()

    sql = f"""
            SELECT clientes.nome, (pagamentos.data_pagamento - parcelas.data_vencimento) AS dias_de_atraso, pagamentos.valor_pago
            FROM parcelas
            JOIN contratos ON parcelas.contrato_id = contratos.contrato_id
            JOIN clientes ON contratos.cliente_id = clientes.cliente_id
            JOIN pagamentos ON parcelas.parcela_id = pagamentos.parcela_id
            WHERE pagamentos.data_pagamento - parcelas.data_vencimento > 0
            """
    
    headers = ["Nome Cliente", "Dias de Atraso", "Valor Pago"]

    try:
        cur.execute(sql)
        records = cur.fetchall()

        table = tabulate(records, headers=headers, tablefmt='fancy_grid', missingval="-")
        print(table)
    except psycopg2.DatabaseError as ex:
        print("[ERRO] Erro interno na consulta do banco")
        print(ex)

    cur.close()
    conn.close()

    input("Pressione enter para retornar ao menu: ")

def unidades_com_saldo_devedor():
    menu_base()
    print("\nUnidades que ainda possuem saldo a pagar:\n")

    conn = conectar()
    cur = conn.cursor()

    sql = f"""
            SELECT unidades.loteamento, unidades.quadra, unidades.lote, (unidades.valor - COALESCE(SUM(pagamentos.valor_pago), 0)) AS valor_total_em_aberto
            FROM unidades
            LEFT JOIN contratos ON unidades.unidade_id = contratos.unidade_id
            LEFT JOIN parcelas ON contratos.contrato_id = parcelas.contrato_id
            LEFT JOIN pagamentos ON parcelas.parcela_id = pagamentos.parcela_id
            GROUP BY unidades.loteamento, unidades.quadra, unidades.lote, unidades.valor
            HAVING (unidades.valor - COALESCE(SUM(pagamentos.valor_pago), 0)) > 0
            ORDER BY unidades.loteamento, unidades.quadra, unidades.lote, unidades.valor;
            """
    
    headers = ["Loteamento", "Quadra", "Lote", "Valor Total em Aberto"]

    try:
        cur.execute(sql)
        records = cur.fetchall()

        table = tabulate(records, headers=headers, tablefmt='fancy_grid', missingval="-")
        print(table)
    except psycopg2.DatabaseError as ex:
        print("[ERRO] Erro interno na consulta do banco")
        print(ex)

    cur.close()
    conn.close()

    input("Pressione enter para retornar ao menu: ")

def parcelas_em_contratos():
    menu_base()
    print("\nParcelas em contratos:\n")

    conn = conectar()
    cur = conn.cursor()

    sql = f"""
            SELECT contrato_id, parcela_id, status_parcela
            FROM parcelas
            """
    
    headers = ["Contrato ID", "Parcela ID", "Status Parcela"]

    try:
        cur.execute(sql)
        records = cur.fetchall()

        table = tabulate(records, headers=headers, tablefmt='fancy_grid', missingval="-")
        print(table)
    except psycopg2.DatabaseError as ex:
        print("[ERRO] Erro interno na consulta do banco")
        print(ex)

    cur.close()
    conn.close()

    input("Pressione enter para retornar ao menu: ")

def clientes_com_multiplos_contratos():
    menu_base()
    print("\nClientes que possuem mais de um contrato ativo:\n")

    conn = conectar()
    cur = conn.cursor()

    sql = f"""
            SELECT clientes.cliente_id, clientes.nome, COUNT(contratos.contrato_id) AS numero_contratos_ativos
            FROM clientes
            JOIN contratos ON clientes.cliente_id = contratos.cliente_id
            GROUP BY clientes.cliente_id, clientes.nome
            HAVING COUNT(contratos.contrato_id) > 1
            ORDER BY clientes.cliente_id, clientes.nome;
            """
    
    headers = ["Cliente ID", "Cliente Nome", "Número de Contratos Ativos"]

    try:
        cur.execute(sql)
        records = cur.fetchall()

        table = tabulate(records, headers=headers, tablefmt='fancy_grid', missingval="-")
        print(table)
    except psycopg2.DatabaseError as ex:
        print("[ERRO] Erro interno na consulta do banco")
        print(ex)

    cur.close()
    conn.close()

    input("Pressione enter para retornar ao menu: ")

def recebiveis_por_cliente():
    menu_base()
    print("\nRecebíveis por Cliente:\n")

    conn = conectar()
    cur = conn.cursor()

    sql = f"""
            SELECT clientes.cliente_id, clientes.nome, SUM(valor_parcela) AS valor_total_em_aberto
            FROM clientes
            JOIN contratos ON clientes.cliente_id = contratos.cliente_id
            JOIN parcelas ON contratos.contrato_id = parcelas.contrato_id
            WHERE parcelas.status_parcela = 'pendente' OR parcelas.status_parcela = 'vencida'
            GROUP BY clientes.cliente_id, clientes.nome
            HAVING SUM(valor_parcela) > 50000  
            """
    
    headers = ["Cliente ID", "Cliente Nome", "Valor Total em Aberto"]

    try:
        cur.execute(sql)
        records = cur.fetchall()

        table = tabulate(records, headers=headers, tablefmt='fancy_grid', missingval="-")
        print(table)
    except psycopg2.DatabaseError as ex:
        print("[ERRO] Erro interno na consulta do banco")
        print(ex)

    cur.close()
    conn.close()

    input("Pressione enter para retornar ao menu: ")

def contrato_sem_parcela_parcela_sem_pagamento():
    menu_base()
    print("\nContratos sem Parcelas ou Parcelas sem Pagamento:\n")

    conn = conectar()
    cur = conn.cursor()

    sql = f"""
            SELECT contratos.contrato_id AS id, 'Contrato sem Parcela' AS tipo
            FROM contratos
            LEFT JOIN parcelas ON contratos.contrato_id = parcelas.contrato_id
            WHERE parcelas.parcela_id IS NULL

            UNION

            SELECT parcelas.parcela_id AS id, 'Parcela sem Pagamento' AS tipo
            FROM parcelas
            LEFT JOIN pagamentos ON parcelas.parcela_id = pagamentos.parcela_id
            WHERE pagamentos.pagamento_id IS NULL
            ORDER BY tipo; 
            """
    
    headers = ["ID", "Tipo"]

    try:
        cur.execute(sql)
        records = cur.fetchall()

        table = tabulate(records, headers=headers, tablefmt='fancy_grid', missingval="-")
        print(table)
    except psycopg2.DatabaseError as ex:
        print("[ERRO] Erro interno na consulta do banco")
        print(ex)

    cur.close()
    conn.close()

    input("Pressione enter para retornar ao menu: ")

def parcela_maior_valor_ranking_por_contrato():
    menu_base()
    print("\nParcela de Maior Valor e Ranking por Contrato:\n")

    conn = conectar()
    cur = conn.cursor()

    sql = f"""
            SELECT parcelas.contrato_id, parcelas.parcela_id, parcelas.valor_parcela, 
	            RANK() OVER (PARTITION BY parcelas.contrato_id ORDER BY parcelas.valor_parcela DESC) AS ranking
            FROM parcelas; 
            """
    
    headers = ["Contrato ID", "Parcela ID", "Valor da Parcela", "Ranking"]

    try:
        cur.execute(sql)
        records = cur.fetchall()

        table = tabulate(records, headers=headers, tablefmt='fancy_grid', missingval="-")
        print(table)
    except psycopg2.DatabaseError as ex:
        print("[ERRO] Erro interno na consulta do banco")
        print(ex)

    cur.close()
    conn.close()

    input("Pressione enter para retornar ao menu: ")

def limpar_terminal():
    if os.name == 'posix':  # Para sistemas Unix/Linux/Mac
        os.system('clear')
    elif os.name == 'nt':  # Para sistemas Windows
        os.system('cls')

def menu_base():
    print("\n============= MENU =============\n")

def menu_principal():
    menu_base()
    print("    1 - Consultar tabelas")
    print("    2 - Remover dados")
    print("    3 - Resumo contratos ativos")
    print("    4 - Recebíveis em aberto")
    print("    5 - Pagamento por loteamento")
    print("    6 - Parcelas pagas com atraso")
    print("    7 - Unidades com saldo devedor")
    print("    8 - Parcelas em contratos")
    print("    9 - Clientes com múltiplos contratos")
    print("    10 - Recebíveis por cliente")
    print("    11 - Contratos sem parcelas ou parcelas sem pagamento")
    print("    12 - Parcela de maior valor e ranking por contrato")
    print("    0 - Sair\n")

def menu_consultar():
    menu_base()
    print("    1 - Consultar Clientes")
    print("    2 - Consultar Contratos")
    print("    3 - Consultar Pagamentos")
    print("    4 - Consultar Parcelas")
    print("    5 - Consultar Unidades")
    print("    0 - Retornar\n")

def menu_remover():
    menu_base()
    print("    1 - Remover Clientes")
    print("    2 - Remover Contratos")
    print("    3 - Remover Pagamentos")
    print("    4 - Remover Parcelas")
    print("    5 - Remover Unidades")
    print("    0 - Retornar\n")

def processar_opcao(opcao):
    if opcao == 1:
        menu_consultar()
        sub_opcao = int(input("Escolha uma opção de consulta: "))
        limpar_terminal()

        if sub_opcao == 0:
            print("Retornando")

        elif sub_opcao == 1:
            consultar("Clientes")

        elif sub_opcao == 2:
            consultar("Contratos")

        elif sub_opcao == 3:
            consultar("Pagamentos")

        elif sub_opcao == 4:
            consultar("Parcelas")

        elif sub_opcao == 5:
            consultar("Unidades")


    elif opcao == 2:
        menu_remover()
        sub_opcao = int(input("Escolha uma opção de remoção: "))
        limpar_terminal()

        if sub_opcao == 0:
            print("Retornando")

        elif sub_opcao == 1:
            remover("Clientes")

        elif sub_opcao == 2:
            remover("Contratos")

        elif sub_opcao == 3:
            remover("Pagamentos")

        elif sub_opcao == 4:
            remover("Parcelas")

        elif sub_opcao == 5:
            remover("Unidades")


    elif opcao == 3:
        resumo_contratos_ativos()

    elif opcao == 4:
        recebiveis_em_aberto()

    elif opcao == 5:
        pagamentos_por_loteamento()

    elif opcao == 6:
        parcelas_pagas_com_atraso()

    elif opcao == 7:
        unidades_com_saldo_devedor()

    elif opcao == 8:
        parcelas_em_contratos()

    elif opcao == 9:
        clientes_com_multiplos_contratos()

    elif opcao == 10:
        recebiveis_por_cliente()

    elif opcao == 11:
        contrato_sem_parcela_parcela_sem_pagamento()

    elif opcao == 12:
        parcela_maior_valor_ranking_por_contrato()

    elif opcao == 0:
        print("Saindo do programa.")

    else:
        print("Opção inválida. Tente novamente.")
        opcao = int(input("Escolha uma opção: "))

if __name__ == '__main__':
    opcao = 1
    while opcao:
        menu_principal()
        opcao = int(input("Escolha uma opção: "))
        processar_opcao(opcao)
        limpar_terminal()