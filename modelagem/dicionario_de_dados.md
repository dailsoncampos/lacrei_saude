## Dicionário de Dados
Este documento descreve a estrutura de dados das duas abordagens propostas para representar os planos de saúde aceitos pelos profissionais cadastrados na plataforma **Lacrei Saúde**.

---

### Tabela: `professionals`

| Campo | Tipo de Dado | Restrições | Descrição | Proposta |
|--------|---------------|-------------|------------|-----------|
| `id` | SERIAL | `PRIMARY KEY` | Identificador único do profissional | Ambas as propostas |
| `full_name` | VARCHAR(100) | `NOT NULL` | Nome completo do profissional | Ambas as propostas |
| `email` | CITEXT | `NOT NULL`, `UNIQUE` | E-mail de contato (case-insensitive) | Ambas as propostas |
| `phone` | VARCHAR(20) | `NULL` | Telefone de contato do profissional | Ambas as propostas |
| `public_profile` | BOOLEAN | `NOT NULL`, `DEFAULT TRUE` | Indica se o perfil é público na plataforma | Ambas as propostas |
| `speciality` | VARCHAR(100) | `NULL` | Especialidade principal do profissional (ex: Psicologia, Fisioterapia) | Ambas as propostas |
| `accepted_plans` | JSONB | `NULL` | Lista de planos aceitos (objeto JSON) | **Proposta de Modelo com JSONB** |
| `created_at` | TIMESTAMP | `DEFAULT now()` | Data de criação do registro | Ambas as propostas |
| `updated_at` | TIMESTAMP | `DEFAULT now()` | Data da última atualização | Ambas as propostas |

---

### Tabela: `health_insurances`

| Campo | Tipo de Dado | Restrições | Descrição | Proposta |
|--------|---------------|-------------|------------|-----------|
| `id` | SERIAL | `PRIMARY KEY` | Identificador único do plano de saúde | **Proposta de Modelo Relacional** |
| `name` | VARCHAR(100) | `NOT NULL`, `UNIQUE` | Nome do plano de saúde (ex: Unimed Nacional, Bradesco Saúde) | **Proposta de Modelo Relacional** |
| `category` | VARCHAR(100) | `NOT NULL` | Categoria ou abrangência (ex: Nacional, Regional) | **Proposta de Modelo Relacional** |
| `coverage` | TEXT[] | `NULL` | Lista de coberturas (ex: consultas, exames, terapias) | **Proposta de Modelo Relacional** |
| `created_at` | TIMESTAMP | `DEFAULT now()` | Data de criação do registro | **Proposta de Modelo Relacional** |

---

### Tabela: `professional_health_insurances` (associativa)

| Campo | Tipo de Dado | Restrições | Descrição | Proposta |
|--------|---------------|-------------|------------|-----------|
| `id` | SERIAL | `PRIMARY KEY` | Identificador único do relacionamento | **Proposta de Modelo Relacional** |
| `professional_id` | INTEGER | `NOT NULL`, `FOREIGN KEY` → `professionals.id` | Referência ao profissional | **Proposta de Modelo Relacional** |
| `health_insurance_id` | INTEGER | `NOT NULL`, `FOREIGN KEY` → `health_insurances.id` | Referência ao plano de saúde aceito | **Proposta de Modelo Relacional** |
| `active` | BOOLEAN | `DEFAULT TRUE` | Indica se o profissional ainda aceita o plano | **Proposta de Modelo Relacional** |
| `created_at` | TIMESTAMP | `DEFAULT now()` | Data de criação do relacionamento | **Proposta de Modelo Relacional** |

---

### Observações Gerais

- **Campos comuns às duas propostas**: `id`, `email`, `created_at`, `updated_at`.
- **Diferenças principais**:
  - A **Proposta de Modelo com JSONB** armazena os planos aceitos no campo `accepted_plans` (`JSONB`).
  - A **Proposta de Modelo Relacional** utiliza tabelas normalizadas (`health_plans` e `professional_health_insurances`).
- **Validação de e-mail** é feita com `CITEXT`, garantindo insensibilidade a maiúsculas/minúsculas.
- **Coberturas** dentro do `JSONB` (de Modelo com JSONB) ou (`coverage`) podem ser armazenadas como `TEXT[]` (Proposta de Modelo Relacional).
- **Campos de auditoria** (`created_at`, `updated_at`) permitem controle temporal e versionamento simples.

---