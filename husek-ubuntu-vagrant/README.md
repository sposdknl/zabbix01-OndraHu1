# Popis
- Projekt je dělaný v Ansible, původně to měl být čistý bash, avšak jsem chtěl získat zkušenosti z nového nástroje když je ta možnost :)
- Není to profesionální, snaha se však prý cení! ;)

## 1. Přidání důležitých věcí
- Přidal jsem Vagrantfile, playbook.yml a vše potřebné. 
- Nová složka /pics do které budu ukládat screenshoty jako důkaz funkčnosti a správného průběhu.

## 2. soubory
### Vagrantfile
- Configurace je nastavena pro vagrant box s názvem bento/fedora-latest
- Počet jader: 2
- Memory: 2048 (bohatě stačí :))
- Porty: 22 -> 2202, 80 -> 8081 (vše na localhostu (127.0.0.1))

### playbook.yml + Ansible
- Jsou zde umístěny všechny potřebné závislosti, např. PHP server, MariaDB a config, Zabbix Agent 2 + server
- Komplexnější a sofistikovanější způsob automatizace
- Přehledný kód s moduly od Ansible (Hodně pomohl ChatGPT)
- Nebudu ho nakonec využívat, nefunguje mi většina věcí, failed

### provision.sh
- To stejné co playbook.yml, jen v bash :)
- provision.sh: Bash skript pro stejnou instalaci, jako v playbook.yml (slouží jako záloha nebo alternativní řešení).
- /pics: Adresář pro ukládání screenshotů dokumentujících funkčnost a kroky instalace.

## 3. Instalace Zabbix serveru a agenta
 Skript provision.sh automatizuje instalaci a konfiguraci Zabbix serveru a agenta. Tento skript provádí:
1. Instalace PHP serveru
2. Instalace a konfigurace MariaDB
3. Instalace Zabbix serveru a agenta
4. Nastavení konfiguračních souborů, jako je zabbix_server.conf a zabbix_agent2.conf
Skript je napsán v Bash a je spouštěn automaticky při spuštění virtuálního stroje pomocí příkazu vagrant up.

## 4. Funkčnost
- Po řadě zpackaných pokusů jsem to konečně opravil na debian, webový server a zabbix server jede
- Importoval jsem sposdk hosta v yaml formátu
- Zkontroloval jsem a zjistil, že vše jede

## 5. Screenshoty
- Všechny screenshoty se nachází ve složce /pics, avšak není tam vše protože jsem to dělal i na jiných pc, kde se mi nepovedlo udělat screenshot. 

## 6. Shrnutí
- Práce byla deprimující :(
