# Host Avaibility

Disponibilidade do host é um script simples que tenta verificar sem um host está ativo ou não na rede.

Ele usa o programa `ping` para detectar se um host está ativo ou não, baseado no numero de pacotes enviados.

### Instruções
Esse script pode ser usado de duas formas, usando argumentos ou editando uma variavel.

Em caso de automação, edite a variavel `$HOST_IP`. Dessa forma toda vez que o script for executado, ele usará essa váriavel como referencia para dar um resultado.

Use argumentos quando quiser testar um ou mais IPs de uma vez só pela linha de commando. Você pode passar como argumentos:

- IP internos
- IP externos
- Dominios

Para passar varios argumentos de uma vez execute:

`./host-avaibility.bash 192.168.0.10 8.8.8.8 google.com pudim.com.br`



### Sistemas Operacionais

- Debian
- Deepin
- Ubuntu
- Fedora
- Centos
- RedHat
