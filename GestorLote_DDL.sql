CREATE TABLE Clientes (
	cliente_id INT, 
	nome VARCHAR(100) NOT NULL,
	cpf_cnpj VARCHAR(18) NOT NULL,
	email VARCHAR(100),
	status_cliente VARCHAR(7) NOT NULL,

	CONSTRAINT pk_cliente PRIMARY KEY(cliente_id),
	CONSTRAINT ck_status_cliente_valido CHECK(status_cliente = 'ativo' OR status_cliente = 'inativo')
);

CREATE TABLE Unidades (
	unidade_id INT,
	loteamento VARCHAR(100) NOT NULL,
	quadra VARCHAR(100) NOT NULL,
	lote VARCHAR(100) NOT NULL,
	valor DECIMAL NOT NULL,

	CONSTRAINT pk_unidade PRIMARY KEY(unidade_id),
	CONSTRAINT ck_valor_unidade_positivo CHECK(valor >= 0) 
);

CREATE TABLE Contratos (
	contrato_id INT, 
	cliente_id INT,
	unidade_id INT,
	data_contrato DATE NOT NULL,
	valor_total DECIMAL NOT NULL,

	CONSTRAINT pk_contrato PRIMARY KEY(contrato_id),
	CONSTRAINT fk_cliente FOREIGN KEY(cliente_id)
		REFERENCES Clientes(cliente_id)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT fk_unidade FOREIGN KEY(unidade_id)
		REFERENCES Unidades(unidade_id)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT ck_valor_contrato_positivo CHECK(valor_total >= 0)
);

CREATE TABLE Parcelas (
	parcela_id INT,
	contrato_id INT,
	data_vencimento DATE NOT NULL,
	valor_parcela DECIMAL NOT NULL,
	status_parcela VARCHAR(8) NOT NULL,

	CONSTRAINT pk_parcela PRIMARY KEY(parcela_id),
	CONSTRAINT fk_contrato FOREIGN KEY(contrato_id)
		REFERENCES Contratos(contrato_id)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT ck_valor_parcela_positiva CHECK(valor_parcela >= 0),
	CONSTRAINT ck_status_parcela_valido CHECK(status_parcela = 'pendente' OR status_parcela = 'paga' OR status_parcela = 'vencida')
);

CREATE TABLE Pagamentos (
	pagamento_id INT,
	parcela_id INT,
	data_pagamento DATE NOT NULL,
	valor_pago DECIMAL NOT NULL,

	CONSTRAINT pk_pagamento PRIMARY KEY(pagamento_id),
	CONSTRAINT fk_parcela FOREIGN KEY(parcela_id)
		REFERENCES Parcelas(parcela_id)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT ck_valor_pagamento_positivo CHECK(valor_pago >= 0)
);