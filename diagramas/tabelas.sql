CREATE SEQUENCE incrementavel START 1 INCREMENT 1;
CREATE TABLE telefones (
  id_telefone INT PRIMARY KEY DEFAULT NEXTVAL('incrementavel'),
  numero BIGINT NOT NULL
);

CREATE TABLE medicos (
  id_medico INT PRIMARY KEY DEFAULT NEXTVAL('incrementavel'),
  nome_medico VARCHAR(50) NOT NULL,
  especialidade VARCHAR(50) NOT NULL,
  foto_medico VARCHAR(255)
);

CREATE TABLE enderecos (
  id_endereco INT PRIMARY KEY DEFAULT NEXTVAL('incrementavel'),
  cep INT NOT NULL,
  rua VARCHAR(50) NOT NULL,
  numero VARCHAR(10) NOT NULL,
  cidade VARCHAR(20) NOT NULL
);

CREATE TABLE clientes (
  id_cliente INT PRIMARY KEY DEFAULT NEXTVAL('incrementavel'),
  nome VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  data_nascimento DATE NOT NULL,
  senha VARCHAR(255) NOT NULL,
  foto_cliente VARCHAR(255) NOT NULL,
  fk_id_telefone INT NOT NULL,
  fk_id_endereco INT NOT NULL,
  CONSTRAINT fk_telefones_clientes FOREIGN KEY (fk_id_telefone) REFERENCES telefones(id_telefone),
  CONSTRAINT fk_enderecos_clientes FOREIGN KEY (fk_id_endereco) REFERENCES enderecos(id_endereco)
);

CREATE TABLE consultas (
  id_consulta INT PRIMARY KEY DEFAULT NEXTVAL('incrementavel'),
  data_consulta TIMESTAMP NOT NULL,
  fk_id_cliente INT NOT NULL,
  fk_id_medico INT NOT NULL,
  CONSTRAINT fk_clientes_consultas FOREIGN KEY (fk_id_cliente) REFERENCES clientes(id_cliente),
  CONSTRAINT fk_medico_consultas FOREIGN KEY (fk_id_medico) REFERENCES medicos(id_medico)
);

CREATE TABLE agendas_medicos (
  id_agenda SERIAL PRIMARY KEY,
  fk_id_medico INT NOT NULL,
  dia_semana VARCHAR(10) NOT NULL,
  horario TIME NOT NULL,
  CONSTRAINT fk_medico_agenda FOREIGN KEY (fk_id_medico) REFERENCES medicos(id_medico)
);

DO $$
DECLARE
  medico_id INT;
  h TIME;
  dias TEXT[] := ARRAY['Segunda', 'Terca', 'Quarta', 'Quinta', 'Sexta'];
  dia TEXT;
  i INT;
BEGIN
  FOR medico_id IN SELECT id_medico FROM medicos LOOP
    FOR i IN 1..array_length(dias, 1) LOOP
      dia := dias[i];
      h := '08:00';
      WHILE h < '18:00' LOOP
        IF h != '12:00' THEN
          INSERT INTO agendas_medicos (fk_id_medico, dia_semana, horario)
          VALUES (medico_id, dia, h);
        END IF;
        h := h + interval '1 hour';
      END LOOP;
    END LOOP;
  END LOOP;
END $$;


CREATE VIEW informacoes_clientes_completos AS
SELECT c.*, e.*, t.id_telefone AS telefone_id, t.numero AS telefone_numero
FROM clientes c
JOIN enderecos e ON c.fk_id_endereco = e.id_endereco
JOIN telefones t ON c.fk_id_telefone = t.id_telefone;

CREATE VIEW horarios_disponiveis_medicos AS
SELECT 
  m.id_medico,
  m.nome_medico,
  a.dia_semana,
  a.horario
FROM medicos m
JOIN agendas_medicos a ON m.id_medico = a.fk_id_medico
ORDER BY m.id_medico, 
         CASE 
           WHEN a.dia_semana = 'Segunda' THEN 1
           WHEN a.dia_semana = 'Terca' THEN 2
           WHEN a.dia_semana = 'Quarta' THEN 3
           WHEN a.dia_semana = 'Quinta' THEN 4
           WHEN a.dia_semana = 'Sexta' THEN 5
           ELSE 6
         END,
         a.horario;