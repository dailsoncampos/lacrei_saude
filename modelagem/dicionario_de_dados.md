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
| `accepted_plans` | JSONB | `NULL` | Lista de planos aceitos (objeto JSON) | **A** |
| `created_at` | TIMESTAMP | `DEFAULT now()` | Data de criação do registro | A / B |
| `updated_at` | TIMESTAMP | `DEFAULT now()` | Data da última atualização | A / B |

---

### Tabela: `health_insurances`

| Campo | Tipo de Dado | Restrições | Descrição | Proposta |
|--------|---------------|-------------|------------|-----------|
| `id` | SERIAL | `PRIMARY KEY` | Identificador único do plano de saúde | **B** |
| `name` | VARCHAR(100) | `NOT NULL`, `UNIQUE` | Nome do plano de saúde (ex: Unimed, Bradesco Saúde) | **B** |
| `category` | VARCHAR(100) | `NOT NULL` | Categoria ou abrangência (ex: Nacional, Regional) | **B** |
| `coverage` | TEXT[] | `NULL` | Lista de coberturas (ex: consultas, exames, terapias) | **B** |
| `created_at` | TIMESTAMP | `DEFAULT now()` | Data de criação do registro | **B** |

---

### Tabela: `professional_health_insurances` (associativa)

| Campo | Tipo de Dado | Restrições | Descrição | Proposta |
|--------|---------------|-------------|------------|-----------|
| `id` | SERIAL | `PRIMARY KEY` | Identificador único do relacionamento | **B** |
| `professional_id` | INTEGER | `NOT NULL`, `FOREIGN KEY` → `professionals.id` | Referência ao profissional | **B** |
| `health_plan_id` | INTEGER | `NOT NULL`, `FOREIGN KEY` → `health_plans.id` | Referência ao plano de saúde aceito | **B** |
| `active` | BOOLEAN | `DEFAULT TRUE` | Indica se o profissional ainda aceita o plano | **B** |
| `created_at` | TIMESTAMP | `DEFAULT now()` | Data de criação do relacionamento | **B** |

---

### Observações Gerais

- **Campos comuns às duas propostas**: `id`, `email`, `created_at`, `updated_at`.
- **Diferenças principais**:
  - A **Proposta A** armazena os planos aceitos no campo `accepted_plans` (`JSONB`).
  - A **Proposta B** utiliza tabelas normalizadas (`health_plans` e `professional_health_insurances`).
- **Validação de e-mail** é feita com `CITEXT`, garantindo insensibilidade a maiúsculas/minúsculas.
- **Coberturas** dentro do `JSONB` (Proposta A) ou (`coverage`) podem ser armazenadas como `TEXT[]` (Proposta B).
- **Campos de auditoria** (`created_at`, `updated_at`) permitem controle temporal e versionamento simples.

---