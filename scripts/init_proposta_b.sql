-- Executa os arquivos relacionados a proposta B

\echo 'Iniciando configuração do banco - Proposta B'

\i 01_extensions.sql
\i 03_create_tables_proposta_b.sql
\i 04_indexes_constraints.sql
\i 06_insert_mock_data_proposal_b.sql

\echo 'Proposta B criada com sucesso!'
