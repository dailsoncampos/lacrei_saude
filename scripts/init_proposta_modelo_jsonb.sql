-- -- Executa os arquivos relacionados a proposta modelo JSONB

\echo 'Iniciando configuração do banco - Proposta Modelo JSONB'

\i 01_extensions.sql
\i 02_create_tables_proposta_modelo_jsonb.sql
\i 04_indexes_constraints.sql
\i 05_insert_mock_data_proposal_modelo_jsonb.sql

\echo 'Proposta Modelo JSONB criada com sucesso!'
