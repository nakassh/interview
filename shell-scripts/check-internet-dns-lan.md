# Check Internet Dns Lan connectivity

Esse script verifica e informa a qualidade da conexão em 3 pontos diferentes:

- Internet 
- Dns
- Lan

Quando o script verifica a conexão da internet, ele usar o curl para estabelecer a conexão e verificar seu retorno. Você pode usar qualquer website, mas por padrão ele já usa o `google.com`. Pra isso, basta alterar a variável `$INTERNET_URL_TEST`.

Já as verificações de DNS e LAN (Gateway), são testadas usando comando ping e IPs. O script sempre tenta pingar 4 vezes no IP determinado. Se o retorno for menos de 3 pacotes recebidos, ele sugere a conexão tem problemas. 

O IP do DNS por padrão testado é 1.1.1.1, Serviço de DNS gratuito da Cloudflare e que está configurado na variável `$IP_CLOUDFLARE_DNS`. Você pode trocar pelo DNS do Google (8.8.8.8) por trocar pela variável `$IP_GOOGLE_DNS` se preferir.

Já o IP do gateway é pego automaticamente no sistema. E assim que ele testa a conectividade usando o Ping.

### Instruções

De as permissões de execução:

`sudo chmod +x check-internet-dns-lan.bash`

E execute no terminal:

`./check-internet-dns-lan.bash`

### Requerimentos

- curl 
- bash


### Sistemas Operacionais

- Debian
- Deepin
- Ubuntu
- Fedora
- Centos
- RedHat
