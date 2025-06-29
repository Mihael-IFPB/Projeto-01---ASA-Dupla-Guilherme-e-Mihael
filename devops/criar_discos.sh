#!/bin/bash

mkdir -p discos
for i in 1 2 3; do
  disco="discos/disk${i}.vdi"
  if [ ! -f "$disco" ]; then
    echo "Criando $disco..."
    VBoxManage createhd --filename "$PWD/$disco" --size 10240
  else
    echo "$disco já existe, pulando..."
  fi
done

