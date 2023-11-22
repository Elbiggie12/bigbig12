#!/bin/bash
#
# Instalar e Iniciar o Servidor Apache
#

# Ativar o modo estrito para lidar com variáveis não definidas
set -euo pipefail

# Declarar Variáveis
server_root="/var/www/html"
server_port="80"
index_page="index.html"

# Título
echo "Iniciando Servidor Apache"

# Validar permissão de administrador
if [[ $(id -u) -ne 0 ]]; then
    echo "Necessário permissão elevada"
    exit 1
fi

# Fazer a atualização dos pacotes do sistema
echo "Atualizando pacotes do sistema (apt-get)"
apt-get update -y && apt-get upgrade -y

# Instalar o servidor Apache2 se ainda não estiver instalado
if ! command -v apache2 &>/dev/null; then
    echo "Instalando o servidor Apache2..."
    apt-get install apache2 -y
else
    echo "O servidor Apache2 já está instalado!"
fi

# Validar se o diretório existe
if [[ ! -d "$server_root" ]]; then
    echo "Criando diretório do Servidor"
    mkdir -p "$server_root"
fi

# Validar arquivo index.html
if [[ ! -e "$server_root/$index_page" ]]; then
    echo "Criando a página inicial..."
    echo "<html><body><h1>Bem-vindo ao servidor web default!! TESTE</h1></body></html>" >"$server_root/$index_page"
fi

# Inicializando e habilitando o servidor Apache2
echo "-------------------------------"
echo "Iniciando o servidor Apache2"
echo "Diretório do site: $server_root"
echo "Porta: $server_port"
systemctl start apache2
systemctl enable apache2

