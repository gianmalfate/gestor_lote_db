-- 1. Resumo de Contratos Ativos
-- Liste todos os contratos ativos, exibindo:
-- - Nome do cliente.
-- - Lote adquirido (loteamento, quadra, lote).
-- - Valor total do contrato.

SELECT clientes.nome, CONCAT(unidades.loteamento, ', ', unidades.quadra, ', ', unidades.lote) AS lote_adquirido, contratos.valor_total
FROM contratos
JOIN clientes ON contratos.cliente_id = clientes.cliente_id
JOIN unidades ON contratos.unidade_id = unidades.unidade_id;


-- 2. Recebíveis em Aberto
-- Liste todas as parcelas com status "vencida" ou "pendente", agrupando por cliente, e exiba:
-- - Cliente (ID e nome).
-- - Total em aberto (soma de todas as parcelas pendentes ou vencidas).

SELECT CONCAT(contratos.cliente_id, ', ', clientes.nome) AS cliente, SUM(valor_parcela) AS total_em_aberto
FROM contratos
JOIN parcelas ON contratos.contrato_id = parcelas.contrato_id
JOIN clientes ON contratos.cliente_id = clientes.cliente_id
WHERE parcelas.status_parcela = 'vencida' OR parcelas.status_parcela = 'pendente'
GROUP BY cliente


-- 3. Pagamentos por Loteamento
-- Para cada loteamento, calcule:
-- - Total de pagamentos realizados nos últimos 12 meses. Exiba o nome do loteamento e o valor total.

SELECT unidades.loteamento, SUM(pagamentos.valor_pago) AS valor_total
FROM contratos
JOIN unidades ON contratos.unidade_id = unidades.unidade_id
JOIN parcelas ON contratos.contrato_id = parcelas.contrato_id
JOIN pagamentos ON parcelas.parcela_id = pagamentos.parcela_id
WHERE pagamentos.data_pagamento >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY unidades.loteamento;


-- 4. Parcelas Pagas com Atraso
-- Liste todas as parcelas pagas com atraso, incluindo:
-- - Nome do cliente.
-- - Número de dias de atraso.
-- - Valor pago.

SELECT clientes.nome, (pagamentos.data_pagamento - parcelas.data_vencimento) AS dias_de_atraso, pagamentos.valor_pago
FROM parcelas
JOIN contratos ON parcelas.contrato_id = contratos.contrato_id
JOIN clientes ON contratos.cliente_id = clientes.cliente_id
JOIN pagamentos ON parcelas.parcela_id = pagamentos.parcela_id
WHERE pagamentos.data_pagamento - parcelas.data_vencimento > 0


-- 5. Unidades com Saldo Devedor
-- Liste todas as unidades que ainda possuem saldo a pagar, exibindo:
-- - Nome do loteamento, quadra, lote.
-- - Valor total em aberto.

SELECT unidades.loteamento, unidades.quadra, unidades.lote, (unidades.valor - COALESCE(SUM(pagamentos.valor_pago), 0)) AS valor_total_em_aberto
FROM unidades
LEFT JOIN contratos ON unidades.unidade_id = contratos.unidade_id
LEFT JOIN parcelas ON contratos.contrato_id = parcelas.contrato_id
LEFT JOIN pagamentos ON parcelas.parcela_id = pagamentos.parcela_id
GROUP BY unidades.loteamento, unidades.quadra, unidades.lote, unidades.valor
HAVING (unidades.valor - COALESCE(SUM(pagamentos.valor_pago), 0)) > 0
ORDER BY unidades.loteamento, unidades.quadra, unidades.lote, unidades.valor;


-- 6. Parcelas em Contratos
-- Liste todas as parcelas, incluindo:
-- - Parcelas que não possuem pagamentos associados. Exiba o contrato_id, parcela_id, e status da parcela.

SELECT contrato_id, parcela_id, status_parcela
FROM parcelas


-- 7. Clientes com Múltiplos Contratos
-- Liste os clientes que possuem mais de um contrato ativo, exibindo:
-- - Cliente_id.
-- - Nome do cliente.
-- - Número total de contratos ativos.

SELECT clientes.cliente_id, clientes.nome, COUNT(contratos.contrato_id) AS numero_contratos_ativos
FROM clientes
JOIN contratos ON clientes.cliente_id = contratos.cliente_id
GROUP BY clientes.cliente_id, clientes.nome
HAVING COUNT(contratos.contrato_id) > 1
ORDER BY clientes.cliente_id, clientes.nome;


-- 8. Recebíveis por Cliente
-- Para cada cliente, calcule o total de parcelas com status "pendente" ou "vencida". Exiba:
-- - Cliente_id.
-- - Nome.
-- - Valor total em aberto. Filtre apenas clientes cujo total em aberto exceda R$ 50.000.

SELECT clientes.cliente_id, clientes.nome, SUM(valor_parcela) AS valor_total_em_aberto
FROM clientes
JOIN contratos ON clientes.cliente_id = contratos.cliente_id
JOIN parcelas ON contratos.contrato_id = parcelas.contrato_id
WHERE parcelas.status_parcela = 'pendente' OR parcelas.status_parcela = 'vencida'
GROUP BY clientes.cliente_id, clientes.nome
HAVING SUM(valor_parcela) > 50000


-- 9. Contratos sem Parcelas ou Parcelas sem Pagamento
-- Crie uma lista única que combine:
-- - Contratos que não possuem parcelas associadas.
-- - Parcelas que não possuem pagamentos registrados. Exiba:
-- -- Contrato_id ou parcela_id.
-- -- Tipo do registro ("Contrato sem Parcela" ou "Parcela sem Pagamento").

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


-- 10. Parcela de Maior Valor e Ranking por Contrato
-- Para cada contrato:
-- - Identifique a parcela de maior valor.
-- - Classifique todas as parcelas por valor dentro de cada contrato (da maior para a menor). Exiba:
-- - Contrato_id.
-- - Parcela_id.
-- - Valor_parcela.
-- - Ranking (posição no ranking, onde 1 é a parcela de maior valor).

SELECT parcelas.contrato_id, parcelas.parcela_id, parcelas.valor_parcela, 
	RANK() OVER (PARTITION BY parcelas.contrato_id ORDER BY parcelas.valor_parcela DESC) AS ranking
FROM parcelas;
