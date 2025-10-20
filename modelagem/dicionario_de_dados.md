## Dicionário de Dados
Este documento descreve a estrutura de dados das duas abordagens propostas para representar os planos de saúde aceitos pelos profissionais cadastrados na plataforma **Lacrei Saúde**.

---

### Tabela: `professionals`

| Campo | Tipo de Dado | Restrições | Descrição | Proposta |
|--------|---------------|-------------|------------|-----------|
| `id` | SERIAL | `PRIMARY KEY` | Identificador único do profissional | A / B |
| `full_name` | VARCHAR(100) | `NOT NULL` | Nome completo do profissional | A / B |
| `email` | CITEXT | `NOT NULL`, `UNIQUE` | E-mail de contato (case-insensitive) | A / B |
| `phone` | VARCHAR(20) | `NULL` | Telefone do profissional | A / B |
| `public_profile` | BOOLEAN | `NOT NULL` | Lista de planos aceitos (objeto JSON) | A / B |
| `speciality` | VARCHAR(100) | `NULL` | Lista de planos aceitos (objeto JSON) | A / B |
| `accepted_plans` | JSONB | `NULL` | Lista de planos aceitos (objeto JSON) | **B** |
| `created_at` | TIMESTAMP | `DEFAULT now()` | Data de criação do registro | A / B |
| `updated_at` | TIMESTAMP | `DEFAULT now()` | Data da última atualização | A / B |

---

### Tabela: `health_insurances`

| Campo | Tipo de Dado | Restrições | Descrição | Proposta |
|--------|---------------|-------------|------------|-----------|
| `id` | SERIAL | `PRIMARY KEY` | Identificador único do plano de saúde | **A** |
| `name` | VARCHAR(100) | `NOT NULL`, `UNIQUE` | Nome do plano de saúde (ex: Unimed, Bradesco Saúde) | **A** |
| `category` | VARCHAR(100) | `NOT NULL` | Categoria ou abrangência (ex: Nacional, Regional) | **A** |
| `coverage` | TEXT[] | `NULL` | Lista de coberturas (ex: consultas, exames, terapias) | **A** |
| `created_at` | TIMESTAMP | `DEFAULT now()` | Data de criação do registro | **A** |

---

### Tabela: `professional_health_insurances` (associativa)

| Campo | Tipo de Dado | Restrições | Descrição | Proposta |
|--------|---------------|-------------|------------|-----------|
| `id` | SERIAL | `PRIMARY KEY` | Identificador único do relacionamento | **A** |
| `professional_id` | INTEGER | `NOT NULL`, `FOREIGN KEY` → `professionals.id` | Referência ao profissional | **A** |
| `health_plan_id` | INTEGER | `NOT NULL`, `FOREIGN KEY` → `health_plans.id` | Referência ao plano de saúde aceito | **A** |
| `active` | BOOLEAN | `DEFAULT TRUE` | Indica se o profissional ainda aceita o plano | **A** |
| `created_at` | TIMESTAMP | `DEFAULT now()` | Data de criação do relacionamento | **A** |
| `updated_at` | TIMESTAMP | `DEFAULT now()` | Data da última atualização do relacionamento | **A** |

---

### Observações Gerais

- **Campos comuns às duas propostas**: `id`, `name`, `email`, `created_at`, `updated_at`.
- **Diferenças principais**:
  - A **Proposta A** utiliza tabelas normalizadas (`health_plans` e `professional_health_insurances`).
  - A **Proposta B** armazena os planos aceitos no campo `accepted_plans` (`JSONB`).
- **Validação de e-mail** é feita com `CITEXT`, garantindo insensibilidade a maiúsculas/minúsculas.
- **Coberturas** (`coverage`) podem ser armazenadas como `TEXT[]` (Proposta A) ou dentro do `JSONB` (Proposta B).
- **Campos de auditoria** (`created_at`, `updated_at`) permitem controle temporal e versionamento simples.

---