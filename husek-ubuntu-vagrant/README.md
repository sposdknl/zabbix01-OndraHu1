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