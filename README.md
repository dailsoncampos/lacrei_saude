
---

## Desafio Lacrei Saúde - Modelagem de Dados

A seguir são apresentadas **duas abordagens distintas de modelagem** do relacionamento entre **profissionais** e **planos de saúde**.

---

### 1. Proposta de Modelo com `jsonb` (flexível e semi-estruturado)

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

### Uso de JSONB

O tipo de dado **`JSONB` (JSON Binary)** é utilizado na **Proposta de Modelo com JSONB** para armazenar a lista de planos aceitos diretamente na tabela `professionals`.  
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
    "name": "Unimed",
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
WHERE accepted_plans @> '[{"name": "Unimed"}]';
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

### 2. Proposta de Modelo Relacional

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

### 3. Reflexão sobre as abordagens

| Critério | **Proposta de Modelo com JSONB** | **Proposta de Modelo Relacional** |
|-----------|------------------------------------|-----------------------------------|
| **Integridade dos dados** | Limitada (sem FKs entre planos, validação manual) | Alta (FKs, constraints e normalização) |
| **Flexibilidade de esquema** | Alta (estrutura mutável, sem migrações) | Média (migrações necessárias para mudanças) |
| **Desempenho em leitura** | Muito bom (com índice GIN) | Excelente (JOINs otimizados e estrutura indexada) |
| **Desempenho em escrita** | Mais custoso (reescrita completa do JSONB) | Leve (inserções e updates parciais) |
| **Complexidade de manutenção** | Baixa (estrutura simples e compacta) | Alta (mais tabelas e relacionamentos) |
| **Escalabilidade** | Boa (limitada por tamanho dos documentos JSON) | Alta (controle granular por entidade) |
| **Aderência à LGPD** | Requer cuidado em masking de dados no JSON | Mais fácil de gerenciar e anonimizar por entidade |
| **Cenário ideal** | MVPs, protótipos, sistemas dinâmicos | Produção estável, dados críticos e rastreáveis |


---

### 4. Índice e Constrants
- **Proposta de Modelo com JSONB:** Índice **GIN** em `accepted_plans` acelera buscas em dados JSON, mas aumenta o custo de escrita.

```sql
CREATE INDEX idx_professionals_accepted_plans_gin
ON professionals USING GIN (accepted_plans jsonb_path_ops);
````
- **Proposta de Modelo Relacional:** Índices em chaves estrangeiras (professional_id, health_insurance_id) melhoram performance de joins.
- **CITEXT:** Reduz problemas com duplicidade de e-mails ao tratar insensibilidade de caixa.

### 5. Decisões de Modelagem

- O tipo `CITEXT` foi adotado para o campo email, evitando duplicidade causada por diferenças de maiúsculas/minúsculas.
- Campos `created_at` e `updated_at` padronizados para rastreabilidade e controle temporal.
- Índice **GIN** sugerido para o campo accepted_plans (Proposta de Modelo com JSONB) para permitir consultas rápidas em estruturas JSONB.
- Chaves estrangeiras garantem integridade e facilitam auditoria na Proposta de Modelo Relacional.
- Ambas as abordagens permitem expansão futura sem perda de compatibilidade.

---

### 6. Conclusão

- A **Proposta de Modelo com JSONB** é indicada para **fase inicial de produto**, onde o formato dos planos pode mudar com frequência, e há foco em **agilidade e iteração**.
- A **Proposta de Modelo Relacional** é ideal para **sistemas maduros**, que exigem **consistência e rastreabilidade**, como ambientes hospitalares ou plataformas com integrações múltiplas.

---