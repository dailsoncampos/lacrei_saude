-- Índices específicos para a Proposta A
DO $$
BEGIN
    -- Verifica se a coluna JSONB "plans_accepted" existe em professionals
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'professionals'
          AND column_name = 'plans_accepted'
          AND data_type = 'jsonb'
    ) THEN
        -- Índice GIN otimizado para consultas em JSONB
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_professionals_plans_gin ON professionals USING GIN (plans_accepted jsonb_path_ops);';
    END IF;
END $$;

-- Índices específicos para a Proposta B
DO $$
BEGIN
    -- Verifica se a tabela health_insurances existe antes de criar o índice
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'health_insurances') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_health_insurances_name ON health_insurances (name);';
    END IF;
END $$;
