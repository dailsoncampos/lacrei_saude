
---

## 1. Modelagem de Dados

A seguir são apresentadas **duas abordagens distintas de modelagem** do relacionamento entre **profissionais** e **planos de saúde**.

---

### Proposta A — Modelo com `jsonb` (flexível e semi-estruturado)

#### Descrição

Neste modelo, a tabela `professionals` possui uma coluna `accepted_plans` do tipo `jsonb`, armazenando os planos aceitos diretamente.

Exemplo de conteúdo:

```json
[
    {"name": "Unimed", "category": "Regional", "coverage": ["Consultas", "Exames"], "active": true},
    {"name": "SulAmérica", "category": "Nacional", "coverage": ["Consultas", "Exames", "Odontologia"], "active": true}
]
```

#### Vantagens
- Alta flexibilidade de esquema
- Menos tabelas e joins
- Ideal para consultas rápidas e estrutura em evolução

#### Desvantagens
- Menor controle relacional
- Indexação e validação mais complexas
- Pode gerar problemas de integridade

#### Quando usar
- Adequado em MVPs, protótipos ou sistemas em evolução, onde o formato de dados ainda não está completamente definido.

---

## 2. Uso de JSONB

O tipo de dado **`JSONB` (JSON Binary)** é utilizado na **Proposta B** para armazenar a lista de planos aceitos diretamente na tabela `professionals`.  
Essa escolha traz **flexibilidade de estrutura**, mantendo ainda **eficiência de consulta** quando combinada com índices adequados (como GIN).

---

### Campos com `JSONB`

| Tabela | Campo | Tipo | Descrição |
|---------|--------|------|------------|
| `professionals` | `accepted_plans` | JSONB | Lista de planos aceitos pelo profissional |

Exemplo de dado armazenado:

```json
[
  {
    "name": "Unimed Nacional",
    "category": "Nacional",
    "coverage": ["consultas", "exames", "terapias"]
  },
  {
    "name": "Bradesco Saúde",
    "category": "Regional",
    "coverage": ["consultas"]
  }
]
```
#### Quando usar
- Adequado em MVPs, protótipos ou sistemas em evolução, onde o formato de dados ainda não está completamente definido.
- Quando o formato dos dados pode variar ao longo do tempo (ex.: novos campos de plano, detalhes adicionais).
- Quando é necessário armazenar estruturas complexas (arrays, objetos) sem criar várias tabelas.
- Para consultas flexíveis e ad hoc, como:
```sql
SELECT name
FROM professionals
WHERE accepted_plans @> '[{"name": "Unimed Nacional"}]';
```

#### Quando evitar JSONB
- Quando há forte dependência relacional (FKs, integridade referencial).
- Em cenários de alta concorrência de escrita — o PostgreSQL reescreve o campo JSONB a cada alteração.
- Quando o esquema é estável e bem definido (melhor usar modelo normalizado).

#### Boas práticas
- Armazenar apenas informações relevantes no JSONB.
- Evitar campos redundantes (duplicados no JSON e na tabela).
- Garantir que o campo seja opcional e documentado.

---

### Proposta B — Modelo Normalizado (com tabela de relacionamento)

#### Descrição

Neste modelo, temos as tabelas principais:
- `professionals`
- `health_plans`
- `professional_health_plans` (tabela associativa)

Cada profissional pode aceitar vários planos, e cada plano pode ser aceito por vários profissionais (**relação N:N**).

#### Vantagens
- Forte **integridade referencial**
- Facilita **consultas complexas** (joins entre profissionais e planos)
- Melhor **controle de versionamento e histórico**
- Facilita manutenção e migração

#### Desvantagens
- Estrutura mais **verbosa**
- Exige **joins** em consultas simples

#### Quando usar
Ideal em sistemas que precisam **garantir que os dados estejam corretos e auditáveis**, mesmo que isso exija mais estrutura e manutenção.

---

## 3. Reflexão sobre as abordagens

| Critério | **Proposta A — Modelo com JSONB** | **Proposta B — Modelo Normalizado** |
|-----------|------------------------------------|-----------------------------------|
| **Integridade dos dados** | Alta (FKs, constraints) | Limitada (sem FKs entre planos) |
| **Flexibilidade de esquema** | Média (migrações necessárias) | Alta (estrutura mutável) |
| **Desempenho em leitura** | Excelente (JOINs otimizados) | Muito bom (com índice GIN) |
| **Desempenho em escrita** | Leve | Mais custoso (reescrita do JSONB) |
| **Complexidade de manutenção** | Alta (mais tabelas e relações) | Baixa (estrutura simplificada) |
| **Escalabilidade** | Alta (controle granular) | Boa (estrutura compacta) |
| **Aderência à LGPD** | Fácil de gerenciar e anonimizar | Requer cuidado em masking de JSON |
| **Cenário ideal** | Produção estável, dados críticos | MVPs, protótipos, sistemas dinâmicos |

---

### Interpretação

- A **Proposta A** é indicada para **fase inicial de produto**, onde o formato dos planos pode mudar com frequência, e há foco em **agilidade e iteração**.
- A **Proposta B** é ideal para **sistemas maduros**, que exigem **consistência e rastreabilidade**, como ambientes hospitalares ou plataformas com integrações múltiplas.

---