-- ============================================================
-- Proposta B (modelo relacional)
-- ============================================================

\echo 'Inserindo dados para Proposta B (relacional)'

-- Inserir planos de saúde (tabela de domínio)
INSERT INTO health_insurances (name, category, coverage, active)
VALUES
    ('Amil Saúde', 'Nacional', ARRAY['Consultas', 'Exames', 'Internações'], TRUE),
    ('Bradesco Saúde', 'Nacional', ARRAY['Consultas', 'Terapias', 'Cirurgias'], TRUE),
    ('Unimed', 'Regional', ARRAY['Consultas', 'Exames'], TRUE),
    ('SulAmérica', 'Nacional', ARRAY['Consultas', 'Exames', 'Odontologia'], TRUE),
    ('Hapvida', 'Regional', ARRAY['Consultas', 'Exames'], TRUE);

-- Inserir profissionais
INSERT INTO professionals (full_name, email, phone, public_profile, specialty)
VALUES
('Dra. Ana Souza', 'ana.souza@email.com', '+55 11 99999-1111', TRUE, 'Cardiologista'),
('Dr. João Pereira', 'joao.pereira@email.com', '+55 21 98888-2222', TRUE, 'Dermatologista'),
('Dra. Marina Andrade', 'marina.andrade@email.com', '+55 11 99999-1234', FALSE, 'Clínico Geral'),
('Dr. Ricardo Moura', 'ricardo.moura@email.com', '+55 21 98888-9876', TRUE, 'Dermatologista'),
('Dra. Camila Nogueira', 'camila.nogueira@email.com', '+55 31 97777-5555', FALSE, 'Cardiologista');

-- Inserir associações entre profissionais e planos de saúde
INSERT INTO professionals_health_insurances (professional_id, health_insurance_id, active)
SELECT p.id, h.id, v.active
FROM (VALUES
  ('ana.souza@email.com','Amil Saúde', TRUE),
  ('ana.souza@email.com','SulAmérica', TRUE),
  ('joao.pereira@email.com','Bradesco Saúde', TRUE),
  ('joao.pereira@email.com','Unimed', TRUE),
  ('marina.andrade@email.com','Amil Saúde', TRUE),
  ('marina.andrade@email.com','Bradesco Saúde', TRUE),
  ('ricardo.moura@email.com','Unimed', TRUE),
  ('ricardo.moura@email.com','SulAmérica', TRUE),
  ('camila.nogueira@email.com','Hapvida', TRUE)
) AS v(email, insurance_name, active)
JOIN professionals p ON p.email = v.email
JOIN health_insurances h ON h.name = v.insurance_name;

\echo 'Dados inseridos com sucesso!'
