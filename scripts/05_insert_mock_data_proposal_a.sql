-- ============================================================
-- Proposta A (modelo com JSONB)
-- ============================================================

\echo 'Inserindo dados para Proposta A'

INSERT INTO professionals (full_name, email, phone, specialty, plans_accepted)
VALUES
(
  'Dra. Ana Souza',
  'ana.souza@email.com',
  '+55 11 99999-1111',
  'Cardiologista',
  '[{"name": "Amil Saúde"}, {"name": "SulAmérica"}]'::jsonb
),
(
  'Dr. João Pereira',
  'joao.pereira@email.com',
  '+55 21 98888-2222',
  'Dermatologista',
  '[{"name": "Bradesco Saúde"}, {"name": "Unimed"}]'::jsonb
),
(
  'Dra. Marina Andrade',
  'marina.andrade@email.com',
  '+55 11 99999-1234',
  'Clínico Geral',
  '[{"name": "Amil Saúde"}, {"name": "Bradesco Saúde"}]'::jsonb
),
(
  'Dr. Ricardo Moura',
  'ricardo.moura@email.com',
  '+55 21 98888-9876',
  'Dermatologista',
  '[{"name": "Unimed"}, {"name": "SulAmérica"}]'::jsonb
),
(
  'Dra. Camila Nogueira',
  'camila.nogueira@email.com',
  '+55 31 97777-5555',
  'Cardiologista',
  '[{"name": "Hapvida"}]'::jsonb
);

\echo 'Dados inseridos com sucesso!'
