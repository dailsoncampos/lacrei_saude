-- -- Executa os arquivos relacionados a proposta A

\echo 'Iniciando configuração do banco - Proposta A'

\i 01_extensions.sql
\i 02_create_tables_proposta_a.sql
\i 04_indexes_constraints.sql
\i 05_insert_mock_data_proposal_a.sql

\echo 'Proposta A criada com sucesso!'
