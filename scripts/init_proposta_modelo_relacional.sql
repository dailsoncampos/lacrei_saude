-- Executa os arquivos relacionados a proposta modelo relacional

\echo 'Iniciando configuração do banco - Proposta Modelo Relacional'

\i 01_extensions.sql
\i 03_create_tables_proposta_modelo_relacional.sql
\i 04_indexes_constraints.sql
\i 06_insert_mock_data_proposal_modelo_relacional.sql

\echo 'Proposta Modelo Relacional criada com sucesso!'
