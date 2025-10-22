-- Proposta B: Estrutura relacional normalizada

\echo 'Criando tabelas - Proposta de Modelo Relacional'

-- Tabela: professionals
CREATE TABLE IF NOT EXISTS professionals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(100) NOT NULL,
    email CITEXT UNIQUE NOT NULL,
    phone VARCHAR(100),
    public_profile BOOLEAN DEFAULT TRUE,
    specialty VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela: health_insurances
CREATE TABLE IF NOT EXISTS health_insurances (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    coverage VARCHAR(100),
    category VARCHAR(100),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela: professionals_health_insurances
CREATE TABLE IF NOT EXISTS professionals_health_insurances (
    id SERIAL PRIMARY KEY,
    professional_id UUID NOT NULL,
    health_insurance_id INT NOT NULL,
    accepted_since DATE DEFAULT CURRENT_DATE,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE (professional_id, health_insurance_id)
);

\echo 'Tabelas da Proposta de Modelo Relacional criadas com sucesso!'
