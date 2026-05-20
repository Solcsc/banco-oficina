CREATE DATABASE oficina;
USE oficina;

CREATE TABLE cliente(
idcliente INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(45) NOT NULL,
contato VARCHAR(45) NOT NULL,
cpf_cnpj VARCHAR(45) NOT NULL UNIQUE

);

CREATE TABLE equipe(
idequipe INT AUTO_INCREMENT PRIMARY KEY,
nome_equipe VARCHAR(45)

);

CREATE TABLE veiculo(
idveiculo INT AUTO_INCREMENT PRIMARY KEY,
placa VARCHAR(45) NOT NULL UNIQUE,
modelo VARCHAR(45) NOT NULL,
marca VARCHAR(45) NOT NULL,
ano INT NOT NULL,
idcliente INT NOT NULL,
idequipe INT NOT NULL,
FOREIGN KEY (idcliente) REFERENCES cliente (idcliente),
FOREIGN KEY (idequipe) REFERENCES equipe (idequipe)

);

CREATE TABLE mecanicos(
idmecanico INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(45),
codigo VARCHAR(45),
especialidade VARCHAR(45),
endereço VARCHAR(45),
idequipe INT NOT NULL,
FOREIGN KEY (idequipe) REFERENCES equipe (idequipe)

);
 
 CREATE TABLE ordem_servico(
 idordem_servico INT AUTO_INCREMENT PRIMARY KEY,
 numero INT UNIQUE,
 data_emissao DATE NOT NULL,
 valor DECIMAL(10,2),
 status VARCHAR(45),
 conclusao DATE,
 tipo_servico VARCHAR(45),
 idveiculo INT NOT NULL,
 idequipe INT NOT NULL,
 FOREIGN KEY (idveiculo) REFERENCES veiculo (idveiculo),
 FOREIGN KEY (idequipe) REFERENCES equipe (idequipe)
 
 );
 
CREATE TABLE servico(
idservico INT AUTO_INCREMENT PRIMARY KEY,
descricao VARCHAR(45) NOT NULL,
valor_mao_de_obra DECIMAL(10,2) NOT NULL

);

 CREATE TABLE peca(
 idpeca INT AUTO_INCREMENT PRIMARY KEY,
 descricao VARCHAR(45) NOT NULL,
 valor_unitario DECIMAL(10,2) NOT NULL
 
);
 
 CREATE TABLE os_servico(
 idos_servico INT AUTO_INCREMENT PRIMARY KEY,
 valor_praticado DECIMAL(10,2) NOT NULL,
 idservico INT NOT NULL,
 idordem_servico INT NOT NULL,
 FOREIGN KEY (idservico) REFERENCES servico (idservico),
 FOREIGN KEY (idordem_servico) REFERENCES ordem_servico (idordem_servico)
 
);
 
 CREATE TABLE os_peca(
 idos_peca INT AUTO_INCREMENT PRIMARY KEY,
 quantidade INT NOT NULL,
 venda_valor DECIMAL(10,2) NOT NULL,
 idpeca INT NOT NULL,
 idordem_servico INT NOT NULL,
 FOREIGN KEY (idpeca) REFERENCES peca (idpeca),
 FOREIGN KEY (idordem_servico) REFERENCES ordem_servico (idordem_servico)
 
 );
 
 USE oficina;
 
 INSERT INTO cliente (nome, contato, cpf_cnpj)
 VALUE 
 ('José Silva', '8598888888', '1234567890'),
 ('Maria Souza', '8599999999', '0987654321');
 
 INSERT INTO equipe (nome_equipe)
 VALUE
 ('Equipe MM2'),
 ('Equipe SS3');
 
 INSERT INTO veiculo (placa, modelo, marca, ano, idcliente, idequipe)
 VALUE 
 ('ABC1234', 'Corolla', 'Toyota', 2020, 5, 1),
 ('XYZ5678', 'Civic', 'Honda', 2019, 6, 1),
 ('FGH3456', 'Fiesta', 'Ford', 2018, 5, 2);
 
 INSERT INTO mecanicos (nome, codigo, especialidade, endereço, idequipe)
 VALUE 
 ('Carlos Pereira', 'M001', 'Motor', 'Rua A, 123', 1),
 ('Ana Clara', 'M002', 'Eletrica', 'Rua B, 456', 2);
 
 INSERT INTO ordem_servico (numero, data_emissao, valor, status, conclusao, tipo_servico, idveiculo, idequipe)
 VALUE 
 (1001, '2026-05-19', 500.00, 'Aberta', NULL, 'Revisão Geral', 7, 1),
 (1002, '2026-05-19', 300.00, 'Concluída', '2026-05-19', 'Troca de óleo', 8, 2);
 
 INSERT INTO servico (descricao, valor_mao_de_obra)
 VALUE 
 ('Troca de Óleo', 150.00),
 ('Revisão Geral', 500.00),
 ('Alinhamento e balanciamento', 200.00),
 ('Troca de pastilhas de freio', 300.00);
 
 ALTER TABLE peca
 ADD quantidade INT NOT NULL DEFAULT 0;
 
 INSERT INTO peca (descricao, valor_unitario, quantidade)
 VALUE 
 ('Filtro de óleo', 50.00, 20),
 ('Pastilha de freio', 120.00, 15),
 ('Pneu aro 15', 300.00, 10),
 ('Bateria 60Ah', 450.00, 8),
 ('Correia dentada', 200.00, 12);
 
 ALTER TABLE os_servico
 ADD quantidade INT NOT NULL DEFAULT 0;
 
 INSERT INTO os_servico ( valor_praticado, quantidade, idservico, idordem_servico)
 VALUE 
 (150.00, 1, 1, 1),
 (500.00, 1, 2, 1),
 (200.00, 2, 3, 2);
 
  INSERT INTO os_peca (quantidade, venda_valor, idpeca, idordem_servico)
  VALUE 
  (1, 50.00, 1, 1),
  (2, 240.00, 2, 1),
  (4, 1200.00, 3, 2),
  (1, 450.00, 4, 2);
  
USE oficina;

SELECT * FROM cliente;

SELECT nome FROM cliente;

SELECT numero, valor FROM ordem_servico ORDER BY valor DESC;

SELECT COUNT(*) FROM veiculo;

SELECT * FROM cliente where nome = 'José da Silva';

SELECT numero, valor FROM ordem_servico WHERE valor > 400;

SELECT numero, valor FROM ordem_servico  WHERE valor BETWEEN 200 AND 500;

SELECT numero, valor, valor * 0.10 AS imposto 
FROM ordem_servico;

SELECT numero, valor, valor * 1.15 AS valor_final 
FROM ordem_servico;

SELECT numero, valor, status
FROM ordem_servico
ORDER BY valor ASC;

 SELECT numero, data_emissao, valor 
 FROM ordem_servico
 ORDER BY data_emissao ASC;
 
 SELECT idequipe, SUM(valor) AS total_valor
 FROM ordem_servico
 GROUP BY idequipe
 HAVING SUM(valor) > 500;
  
SELECT tipo_servico, AVG(valor) AS media_valor
FROM ordem_servico
GROUP BY tipo_servico
HAVING AVG(valor) > 300;

SELECT idveiculo, COUNT(*) AS qtd_ordens
FROM ordem_servico
GROUP BY idveiculo
HAVING COUNT(*) > 1;
 
SELECT status, SUM(valor) AS total_valor
FROM ordem_servico
GROUP BY status
HAVING SUM(valor) > 400;
 
SELECT os.numero, os.valor, v.placa, v.modelo
FROM ordem_servico os
INNER JOIN veiculo v ON os.idveiculo = v.idveiculo;
 
SELECT os.numero, os.tipo_servico, e.nome_equipe
FROM ordem_servico os
INNER JOIN equipe e ON os.idequipe = e.idequipe;

SELECT os.numero, os.valor, os.status,
       v.placa, v.modelo,
       c.nome AS cliente,
       e.nome_equipe
FROM ordem_servico os
INNER JOIN veiculo v ON os.idveiculo = v.idveiculo
INNER JOIN cliente c ON v.idcliente = c.idcliente
INNER JOIN equipe e ON os.idequipe = e.idequipe;



