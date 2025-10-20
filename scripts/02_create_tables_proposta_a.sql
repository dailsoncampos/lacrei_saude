-- Proposta A: Estrutura utilizando JSONB para planos aceitos

\echo 'Criando tabelas - Proposta A (com JSONB)'

-- Tabela: professionals
CREATE TABLE IF NOT EXISTS professionals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(100) NOT NULL,
    email CITEXT UNIQUE NOT NULL,
    phone VARCHAR(100),
    public_profile BOOLEAN DEFAULT TRUE,
    specialty VARCHAR(100),
    plans_accepted JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

\echo 'Tabelas da Proposta A criadas com sucesso!'
