INSERT INTO Clientes (cliente_id, nome, cpf_cnpj, email, status_cliente)
VALUES (1, 'Lucas Silva', '123.456.789-00', 'lucas.silva@email.com', 'ativo');
INSERT INTO Clientes (cliente_id, nome, cpf_cnpj, email, status_cliente)
VALUES (2, 'Gabriel Almeida', '987.654.321-00', 'gabriel.almeida@email.com', 'ativo');
INSERT INTO Clientes (cliente_id, nome, cpf_cnpj, status_cliente)
VALUES (3, 'Felipe Costa', '456.789.123-45', 'ativo');
INSERT INTO Clientes (cliente_id, nome, cpf_cnpj, email, status_cliente)
VALUES (4, 'Ricardo Souza', '321.654.987-00', 'ricardo.souza@email.com', 'inativo');
INSERT INTO Clientes (cliente_id, nome, cpf_cnpj, email, status_cliente)
VALUES (5, 'TechNova Solutions', '12.345.678/0001-90', 'contato@technova.com.br', 'ativo');
INSERT INTO Clientes (cliente_id, nome, cpf_cnpj, status_cliente)
VALUES (6, 'VerdeViva Consultoria', '98.765.432/0001-01', 'ativo');
INSERT INTO Clientes (cliente_id, nome, cpf_cnpj, email, status_cliente)
VALUES (7, 'InovaComércio Digital', '56.789.012/0001-23', 'contato@inovadigital.com.br', 'inativo');
INSERT INTO Clientes (cliente_id, nome, cpf_cnpj, email, status_cliente)
VALUES (8, 'Beatriz Costa', '159.753.864-25', 'beatriz.costa@email.com', 'ativo');
INSERT INTO Clientes (cliente_id, nome, cpf_cnpj, email, status_cliente)
VALUES (9, 'Fernanda Almeida', '741.852.963-10', 'fernanda.almeida@email.com', 'ativo');
INSERT INTO Clientes (cliente_id, nome, cpf_cnpj, status_cliente)
VALUES (10, 'Camila Pereira', '852.963.741-50', 'inativo');


INSERT INTO Unidades (unidade_id, loteamento, quadra, lote, valor)
VALUES (1, 'Loteamento Vista Alegre', 'Quadra A', '1', 15000.50);
INSERT INTO Unidades (unidade_id, loteamento, quadra, lote, valor)
VALUES (2, 'Loteamento Vista Alegre', 'Quadra A', '2', 50000.50);
INSERT INTO Unidades (unidade_id, loteamento, quadra, lote, valor)
VALUES (3, 'Loteamento Vista Alegre', 'Quadra B', '1', 18500.75);
INSERT INTO Unidades (unidade_id, loteamento, quadra, lote, valor)
VALUES (4, 'Loteamento Vista Alegre', 'Quadra B', '2', 18500.75);
INSERT INTO Unidades (unidade_id, loteamento, quadra, lote, valor)
VALUES (5, 'Loteamento Vista Alegre', 'Quadra C', '1', 21000.00);
INSERT INTO Unidades (unidade_id, loteamento, quadra, lote, valor)
VALUES (6, 'Loteamento Jardim das Flores', 'Quadra A', '1', 17500.25);
INSERT INTO Unidades (unidade_id, loteamento, quadra, lote, valor)
VALUES (7, 'Loteamento Jardim das Flores', 'Quadra A', '2', 17500.25);
INSERT INTO Unidades (unidade_id, loteamento, quadra, lote, valor)
VALUES (8, 'Loteamento Jardim das Flores', 'Quadra B', '1', 22000.80);
INSERT INTO Unidades (unidade_id, loteamento, quadra, lote, valor)
VALUES (9, 'Loteamento Jardim das Flores', 'Quadra B', '2', 22000.80);
INSERT INTO Unidades (unidade_id, loteamento, quadra, lote, valor)
VALUES (10, 'Loteamento Jardim das Flores', 'Quadra C', '1', 19500.60);
INSERT INTO Unidades (unidade_id, loteamento, quadra, lote, valor)
VALUES (11, 'Loteamento Vista Alegre', 'Quadra C', '2', 28000.00);


INSERT INTO Contratos (contrato_id, cliente_id, unidade_id, data_contrato, valor_total)
VALUES (1, 1, 1, '2022-01-15', 15000.50);
INSERT INTO Contratos (contrato_id, cliente_id, unidade_id, data_contrato, valor_total)
VALUES (2, 1, 4, '2022-03-10', 19000.00);
INSERT INTO Contratos (contrato_id, cliente_id, unidade_id, data_contrato, valor_total)
VALUES (3, 2, 2, '2022-05-20', 55000.50);
INSERT INTO Contratos (contrato_id, cliente_id, unidade_id, data_contrato, valor_total)
VALUES (4, 3, 3, '2022-07-25', 18500.75);
INSERT INTO Contratos (contrato_id, cliente_id, unidade_id, data_contrato, valor_total)
VALUES (5, 5, 5, '2022-09-05', 21000.00);
INSERT INTO Contratos (contrato_id, cliente_id, unidade_id, data_contrato, valor_total)
VALUES (6, 5, 6, '2023-02-01', 18550.60);
INSERT INTO Contratos (contrato_id, cliente_id, unidade_id, data_contrato, valor_total)
VALUES (7, 6, 7, '2023-04-18', 17500.25);
INSERT INTO Contratos (contrato_id, cliente_id, unidade_id, data_contrato, valor_total)
VALUES (8, 8, 8, '2023-06-12', 22000.80);
INSERT INTO Contratos (contrato_id, cliente_id, unidade_id, data_contrato, valor_total)
VALUES (9, 8, 10, '2023-08-30', 19500.60);
INSERT INTO Contratos (contrato_id, cliente_id, unidade_id, data_contrato, valor_total)
VALUES (10, 9, 9, '2023-10-15', 22500.00);
INSERT INTO Contratos (contrato_id, cliente_id, unidade_id, data_contrato, valor_total)
VALUES (11, 1, 11, '2022-01-15', 25000.00);



INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (1, 1, '2022-05-15', 625.02, 'paga');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (2, 1, '2028-10-15', 625.02, 'pendente');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (3, 3, '2022-10-20', 25000, 'vencida');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (4, 4, '2022-12-25', 770.86, 'paga');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (5, 5, '2023-02-05', 1750.00, 'vencida');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (6, 5, '2023-07-05', 1750.00, 'vencida');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (7, 8, '2023-11-12', 916.70, 'paga');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (8, 9, '2026-12-30', 812.53, 'pendente');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (9, 9, '2024-06-30', 812.53, 'paga');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (10, 10, '2025-12-15', 3750.00, 'pendente');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (11, 1, '2022-10-15', 625.02, 'paga');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (12, 3, '2029-10-15', 625.02, 'pendente');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (13, 10, '2026-10-15', 625.02, 'pendente');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (14, 1, '2024-07-15', 625.02, 'paga');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (15, 3, '2024-10-20', 1291.71, 'paga');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (16, 3, '2024-10-20', 13708.79, 'paga');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (17, 5, '2023-12-05', 7000, 'paga');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (18, 5, '2024-05-05', 7000, 'paga');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (19, 5, '2024-10-05', 7000, 'paga');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (20, 3, '2023-10-20', 25000, 'vencida');
INSERT INTO Parcelas (parcela_id, contrato_id, data_vencimento, valor_parcela, status_parcela)
VALUES (21, 3, '2025-10-20', 5500.50, 'pendente');


INSERT INTO Pagamentos (pagamento_id, parcela_id, data_pagamento, valor_pago)
VALUES (1, 1, '2022-05-20', 625.02);
INSERT INTO Pagamentos (pagamento_id, parcela_id, data_pagamento, valor_pago)
VALUES (2, 4, '2022-12-20', 385.43);
INSERT INTO Pagamentos (pagamento_id, parcela_id, data_pagamento, valor_pago)
VALUES (3, 7, '2023-12-01', 916.70);
INSERT INTO Pagamentos (pagamento_id, parcela_id, data_pagamento, valor_pago)
VALUES (4, 9, '2024-05-30', 406.27);
INSERT INTO Pagamentos (pagamento_id, parcela_id, data_pagamento, valor_pago)
VALUES (5, 14, '2024-05-30', 625.02);
INSERT INTO Pagamentos (pagamento_id, parcela_id, data_pagamento, valor_pago)
VALUES (6, 15, '2024-10-30', 1291.71);
INSERT INTO Pagamentos (pagamento_id, parcela_id, data_pagamento, valor_pago)
VALUES (7, 16, '2024-10-30', 13708.79);
INSERT INTO Pagamentos (pagamento_id, parcela_id, data_pagamento, valor_pago)
VALUES (8, 17, '2023-12-05', 7000);
INSERT INTO Pagamentos (pagamento_id, parcela_id, data_pagamento, valor_pago)
VALUES (9, 18, '2024-05-05', 7000);
INSERT INTO Pagamentos (pagamento_id, parcela_id, data_pagamento, valor_pago)
VALUES (10, 19, '2024-10-05', 7000);