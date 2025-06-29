# Projeto 01 - ASA

## 1. Identificação

- **Instituição**: Instituto Federal da Paraíba (IFPB)
- **Nome do Projeto**: DevOps com Vagrant e Ansible
- **Disciplina**: Administração de Sistemas Abertos
- **Professor**: Leonidas Francisco de Lima Junior

- **Integrantes da Equipe**:
  - Guilherme Manoel da Silva — Matrícula: 20232380026
  - Mihael Reinaldo Araújo de Albuquerque Escobar — Matrícula: 20232380012
 

---

## 2. Objetivo

Este projeto tem como objetivo a criação e automação de um ambiente de infraestrutura de redes utilizando **Vagrant** e **Ansible**. O ambiente simula uma rede composta por quatro máquinas virtuais, cada uma com funções distintas, interligadas por uma rede interna e configuradas de forma automática via Ansible.

---

## 3. Infraestrutura Criada

O ambiente é composto por **4 VMs**:

| Máquina | Função                     | IP (eth1)           | Porta SSH | IP fixo? |
|---------|----------------------------|----------------------|-----------|----------|
| `arq`   | Servidor NFS e DHCP        | `192.168.56.112`     | 2200      | ✅ Sim    |
| `db`    | Banco de Dados MariaDB     | Dinâmico via DHCP    | 2201      | ❌ Não    |
| `app`   | Servidor Web Apache2       | Dinâmico via DHCP    | 2202      | ❌ Não    |
| `cli`   | Cliente com Firefox        | Dinâmico via DHCP    | 2203      | ❌ Não    |

Todas as VMs utilizam a imagem `debian/bookworm64`.

---

## 4. Tecnologias Utilizadas

- **Vagrant**
- **Ansible**
- **VirtualBox**
- **Debian 12 (Bookworm)**
- **Apache2**
- **MariaDB**
- **DHCP (isc-dhcp-server)**
- **NFS**
- **Autofs**
- **Firefox**
- **Shell Script**

---

## 5. Estrutura do Projeto

```
devops/
├── Vagrantfile
├── ansible/
│   ├── hosts
│   ├── playbook.yml
│   ├── roles/
│   │   ├── arq/
│   │   ├── db/
│   │   ├── app/
│   │   └── cli/
│   └── files/
│       └── index.html
├── testes.sh
├── README.md
└── documentação/
    └── relatorio_final.pdf
```

---

## 6. Execução do Projeto

### 🔽 1. Clonar o repositório

```bash
git clone https://github.com/Mihael-IFPB/Projeto-01---ASA-Dupla-Guilherme-e-Mihael.git
```

### 🔧 2. Subir o ambiente virtualizado

```bash
vagrant up
```

### 📦 3. Aplicar configuração com Ansible

```bash
ansible-playbook -i ansible/hosts ansible/playbook.yml
```

Ou para rodar em uma VM específica:

```bash
ansible-playbook -i ansible/hosts ansible/playbook.yml --limit app
```

### ✅ 4. Rodar testes automáticos

```bash
chmod +x testes.sh
./testes.sh
```

---

## 7. Descrição dos Serviços e Configurações

### Comum a todas as VMs:

- Atualização do sistema
- Instalação do `chrony` (NTP)
- Criação do grupo `ifpb`
- Criação dos usuários `guilherme` e `mihael` no grupo `ifpb`
- Configuração de sudo sem senha para o grupo
- Geração de chaves SSH para os usuários
- Bloqueio de autenticação por senha via SSH
- Instalação do cliente NFS
- Timezone ajustado para `America/Recife`

### Servidor `arq`

- IP estático: `192.168.56.112`
- Servidor **NFS**:
  - Exporta `/dados/publico` (aberto) e `/dados/privado` (restrito à rede)
- Servidor **DHCP** (`isc-dhcp-server`):
  - Distribui IPs dentro da faixa `192.168.56.100` a `192.168.56.199`
  - Usa a interface `eth1` para responder clientes
- Diretórios NFS com permissões `0777`

### Servidor `db`

- Recebe IP via DHCP
- Instalação do **MariaDB**
- Serviço ativo e habilitado

### Servidor `app`

- Recebe IP via DHCP
- Instalação do **Apache2**
- Substituição da página padrão pelo `index.html` personalizado
- Montagem automática de:
  - `/dados/publico` → `/var/nfs/publico`
  - `/dados/privado` → `/var/nfs/privado` (via autofs)

### Máquina `cli`

- Recebe IP via DHCP
- Instalação do **Firefox**
- Montagem automática de `/dados/publico` e `/dados/privado` em `/mnt/nfs/...`

---

## 8. Testes Automatizados

O script `testes.sh` executa as seguintes verificações:

- Verifica se todas as VMs estão ativas
- Verifica conectividade entre elas (`ping`)
- Verifica montagem dos diretórios NFS
- Testa acesso HTTP ao Apache2 na VM `app`
- Testa serviço MariaDB rodando
- Verifica se os serviços NFS e DHCP estão ativos na VM `arq`
- Valida se a página `index.html` foi substituída corretamente
- Confirma que o Firefox está instalado no `cli`

---

## 9. Relatório Final

O relatório em PDF se encontra em:

```
documentação/relatorio_final.pdf
```

Inclui:

- Equipe, professor e disciplina
- Descrição detalhada do funcionamento
- Screenshots e estrutura dos arquivos

---

## 10. Observações Finais

- Todo o provisionamento é automatizado com Ansible.
- O projeto foi desenvolvido e testado localmente em sistema Linux.
- O script `testes.sh` ajuda a validar o funcionamento completo da infraestrutura.

---

## 11. Licença

Projeto acadêmico — uso livre para fins educacionais.
