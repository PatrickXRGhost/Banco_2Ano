# 📦 Banco de Dados Normalizado — Controle de Frotas com IoT

## 🧾 Descrição
Este projeto consiste em um banco de dados **normalizado e auditável**, projetado para gerenciar **frotas de caminhões integradas com sensores IoT (Arduino)**. Seu objetivo é garantir integridade dos dados, rastreabilidade via logs e triggers, e suporte a operações de empresas que atuam na logística e transporte.

## 🎯 Objetivos
- Eliminar redundâncias e inconsistências  
- Garantir integridade referencial  
- Suportar rastreamento via IoT (telemetria veicular)  
- Implementar logs de auditoria e triggers automáticas  
- Otimizar performance com índices e procedures  

## 🧱 Estrutura do Banco

### Principais Entidades e Relacionamentos

| Entidade     | Relacionamento              | Observações                                                                 |
|--------------|-----------------------------|-----------------------------------------------------------------------------|
| Empresa      | 1:N → Motorista             | CNPJ único, dados empresariais e vínculo com motoristas e caminhões        |
| Motorista    | 1:1 → Caminhão              | Associado a uma única empresa e um caminhão                                |
| Caminhão     | 1:N → Manutenção, Alerta, Rota, Arduino | Cada caminhão possui sensores e logs operacionais                     |
| Manutenção   | 1:N → Serviço               | Histórico de serviços e intervenções técnicas                              |
| Arduino      | N/A                         | Armazena dados dos sensores IoT embarcados                                 |
| Sessão       | N/A                         | Registra entradas/saídas de usuários                                       |
| Notificações | N/A                         | Logs de envio via Firebase Cloud Messaging                                 |
| Rota Caminhão| N/A                         | Gerencia deslocamentos, distâncias e destinos                              |

## 🛠 Procedures Implementadas

- `insert_empresa`, `insert_motorista`, `insert_caminhao`  
- `insert_manutencao`, `insert_alerta`, `insert_servico`  
- `insert_arduino`, `insert_rota_caminhao`, `insert_sessao`  

Todas as procedures incluem validações (ex: CNPJ, placa, data, etc).

## 🔎 Funções de Consulta (SQL)

- `buscar_caminhao_por_motorista(p_id_motorista)`  
- `buscar_alertas_ativos_por_caminhao(p_id_caminhao)`  
- `buscar_rotas_por_caminhao(p_id_caminhao)`  
- `buscar_arduino_por_caminhao(p_id_caminhao)`  
- `buscar_empresa_por_id(p_id)`  
- `buscar_empresa_por_codigo(p_cod_empresa)`  

Essas funções otimizam APIs e dashboards de monitoramento em tempo real.

## 🔐 Triggers e Logs de Auditoria

Cada tabela principal possui:
- Tabela de log (`log_*`)
- Trigger automática (`trg_log_*`)
- Função associada (`func_log_*`)

Campos padrão dos logs:
- ID, tipo de operação (INSERT/UPDATE/DELETE), timestamp, usuário e dados alterados.

## 🚀 Índices para Performance

| Índice                                     | Finalidade                                 |
|-------------------------------------------|--------------------------------------------|
| `idx_caminhao_id_motorista`               | Busca de caminhões por motorista           |
| `idx_alerta_id_caminhao_status`           | Alertas ativos por caminhão                |
| `idx_rota_caminhao_id_caminhao`           | Consulta de rotas                          |
| `idx_arduino_id_caminhao`                 | Telemetria IoT                             |
| `ux_fcm_id_usuario_fcm_token` (composto)  | Unicidade de tokens para notificações      |

## 📍 Localização e Mapas

A tabela `maps` armazena:
- `latitude`, `longitude`
- Localização inferida por modelo de machine learning (campo `captura_localizacao_ml`)

Pode ser integrada a ferramentas de mapeamento para dashboards e visualizações.

## ✅ Conclusão

O banco de dados atende às melhores práticas com:
- Estrutura relacional normalizada
- Procedures para validações e inserções seguras
- Triggers e logs para auditoria automática
- Índices para alta performance em consultas

Essa estrutura garante **manutenção facilitada**, **alta integridade dos dados** e **suporte para aplicações modernas** de monitoramento e análise de frotas.