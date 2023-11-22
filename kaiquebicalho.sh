#!/bin/bash
#
# Instalar Servidor Web
#
# CVS $Header$

# Ativar o modo estrito para lidar com variáveis não definidas
shopt -s -o nounset

# Declarar Variáveis
server_root="/var/www/html"
server_port="80"
index_page="index.html"

# Título
echo "Iniciando Servidor Apache"

# Validar permissão de administrador
if [[ $EUID -ne 0 ]]; then
    echo "Necessário permissão elevada"
    sleep 3
    exit 1
fi

# Fazer a atualização dos pacotes do sistema
echo "Atualizando pacotes do sistema (apt-get)"
apt-get update -y && apt-get upgrade -y
sleep 4

# Validar a existência dos pacotes necessários para a execução do servidor
if ! command -v apache2 >/dev/null; then
    echo "O servidor Apache2 não está instalado"
    echo "Instalando o Servidor..."
    apt-get install apache2 -y
    sleep 4
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
    sleep 1
    echo "<html><body><h1>Bem-vindo ao servidor web default!! TESTE</h1></body></html>" >"$server_root/$index_page"
    sleep 3
fi

# Inicializando o servidor Apache2
echo "-------------------------------"
echo "Iniciando o servidor Apache2"
echo "Diretório do site: $server_root"
echo "Porta: $server_port"
systemctl start apache2
