#!/bin/bash

echo "===== TESTE AUTOMATIZADO - PROJETO 01 - DEVOPS ====="

# Testar conectividade entre as VMs
echo -e "\n[1] Testando conectividade entre as VMs..."
for origem in db app cli; do
  echo "-> $origem tentando pingar arq (192.168.56.112)..."
  vagrant ssh "$origem" -c "ping -c 2 192.168.56.112 >/dev/null 2>&1 && echo '    [OK] Conectado à arq' || echo '    [ERRO] Falha na conexão'"
done

# Verificar montagem do NFS
echo -e "\n[2] Verificando montagem do NFS nas VMs..."
for host in db app cli; do
  echo "-> $host:"
  vagrant ssh "$host" -c "mount | grep '/var/nfs' >/dev/null && echo '    [OK] NFS montado' || echo '    [ERRO] NFS não montado'"
done

# Verificar serviço do Apache
echo -e "\n[3] Verificando Apache na VM app..."
vagrant ssh app -c "systemctl is-active apache2" | grep -q active && echo "    [OK] Apache ativo" || echo "    [ERRO] Apache inativo"

# Verificar index.html via curl
echo -e "\n[4] Verificando conteúdo da página do Apache (index.html)..."
vagrant ssh app -c "curl -s localhost | grep -qi 'XOdonto' && echo '    [OK] Página encontrada' || echo '    [ERRO] Página padrão não foi substituída'"

# Verificar chaves SSH dos usuários
echo -e "\n[5] Verificando chaves SSH dos usuários guilherme e mihael..."
for user in guilherme mihael; do
  for host in arq db app cli; do
    echo -n "-> $host / $user: "
    vagrant ssh "$host" -c "test -f /home/$user/.ssh/id_rsa && echo '[OK]' || echo '[ERRO] Chave não encontrada'" 
  done
done

echo -e "\n===== FIM DOS TESTES ====="

