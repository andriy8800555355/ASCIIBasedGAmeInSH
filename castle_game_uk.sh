#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

inventory=()
health=3
current_room="start"

display_health() {
    local hearts=""
    for ((i=0; i<health; i++)); do hearts+="❤️ "; done
    echo -e "${RED}Здоров'я: $hearts${NC}\n"
}

castle_art() {
    echo -e "${PURPLE}
 [][][] /""\ [][][]
  |::| /____\ |::|
  |[]|_|::::|_|[]|
  |::::::__::::::|
  |:::::/||\:::::|
  |:#:::||||::#::|
 #%*###&*##&*&#*&##
##%%*####*%%%###*%*#

${NC}"
}

game_over_art() {
    echo -e "${RED}
 ░▒▓██████▓▒░ ░▒▓██████▓▒░░▒▓██████████████▓▒░░▒▓████████▓▒░       ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓███████▓▒░  
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒▒▓███▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓██████▓▒░        ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒▒▓█▓▒░░▒▓██████▓▒░ ░▒▓███████▓▒░  
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ 
 ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░       ░▒▓██████▓▒░   ░▒▓██▓▒░  ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░${NC}"
}

start() {
    clear
    castle_art
    echo -e "${YELLOW}Ви стоїте перед древнім замком. Місячне світло пробивається крізь розбиті вікна."
    echo -e "Холодний вітер шепоче крізь порожні зали. Ваш ліхтар ледве мерехтить...${NC}"
    echo
    display_health
    echo -e "${CYAN}1. Увійти в браму замка"
    echo -e "2. Повернутися і піти"
    echo -e "3. Обшукати подвір'я${NC}"
    
    while true; do
        read -rp "Оберіть дію [1-3]: " choice
        case $choice in
            1) current_room="entrance_hall"; break;;
            2) game_over "cowardice"; break;;
            3) current_room="courtyard"; break;;
            *) echo -e "${RED}Невірний вибір!${NC}";;
        esac
    done
}

courtyard() {
    clear
    echo -e "${GREEN}
    🌳 Подвір'я 🌳
    Зарослие плющем. У центрі стоїть кам'яний колодязь. 
    Статуя лицаря лежить повалена.${NC}"
    display_health
    echo -e "${CYAN}1. Заглянути в колодязь"
    echo -e "2. Оглянути статую"
    echo -e "3. Повернутися до входу в замок${NC}"

    while true; do
        read -rp "Оберіть дію [1-3]: " choice
        case $choice in
            1)
                echo -e "${BLUE}Ви бачите щось блискуче на дні. Поряд лежить мотузка.${NC}"
                echo -e "${CYAN}1. Використати мотузку, щоб дістати предмет"
                echo -e "2. Залишити все як є${NC}"
                read -rp "Оберіть: " sub_choice
                if [[ $sub_choice == 1 ]]; then
                    if [[ " ${inventory[@]} " =~ "amulet" ]]; then
                        echo -e "${YELLOW}Ви більше нічого не знаходите.${NC}"
                    else
                        echo -e "${GREEN}Ви дістаєте іржавий амулет! Він холодний на дотик.${NC}"
                        inventory+=("amulet")
                    fi
                else
                    echo -e "${YELLOW}Ви вирішуєте не ризикувати.${NC}"
                fi
                current_room="courtyard"
                break
                ;;
            2)
                echo -e "${BLUE}На щиті статуї є дивні написи.${NC}"
                echo -e "${CYAN}1. Спробувати прочитати написи"
                echo -e "2. Рухатися далі${NC}"
                read -rp "Оберіть: " sub_choice
                if [[ $sub_choice == 1 ]]; then
                    echo -e "${YELLOW}Написи попереджають про прокляття. Ви відчуваєте тривогу...${NC}"
                    ((health--))
                    check_health
                else
                    echo -e "${YELLOW}Ви уникаєте торкання статуї.${NC}"
                fi
                current_room="courtyard"
                break
                ;;
            3)
                current_room="start"
                break
                ;;
            *)
                echo -e "${RED}Невірний вибір!${NC}"
                ;;
        esac
    done
}

entrance_hall() {
    clear
    echo -e "${PURPLE}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
    echo -e "${BLUE}                    🕍 ВХІДНА ЗАЛА 🕍"
    echo -e "${PURPLE}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
    echo -e "\nПил кружляє в місячному світлі. Великі сходи розділяються наліво і направо."
    echo -e "Зі східного крила йде дивний запах."
    display_health
    echo -e "${CYAN}1. Піднятися лівими сходами"
    echo -e "2. Піднятися правими сходами"
    echo -e "3. Дослідити східне крило"
    echo -e "4. Повернутися на подвір'я${NC}"
    
    while true; do
        read -rp "Оберіть дію [1-4]: " choice
        case $choice in
            1) current_room="library"; break;;
            2) current_room="armory"; break;;
            3) current_room="east_wing"; break;;
            4) current_room="courtyard"; break;;
            *) echo -e "${RED}Невірний вибір!${NC}";;
        esac
    done
}

armory() {
    clear
    echo -e "${CYAN}
    ⚔️ Зброярня ⚔️
    Іржава зброя розміщена на стінах. Пусті обладунки стоять на варті.
    На північ веде закриті залізні двері.${NC}"
    display_health
    options=("3. Повернутися до вхідної зали")
    if [[ " ${inventory[@]} " =~ "sword" ]]; then
        echo -e "${CYAN}1. Взяти меч (вже взято)"
    else
        echo -e "${CYAN}1. Взяти іржавий меч зі стіни"
    fi
    echo -e "${CYAN}2. Дослідити обладунки"
    if [[ " ${inventory[@]} " =~ "key" ]]; then
        echo -e "${CYAN}4. Відкрити залізні двері ключем"
    else
        echo -e "${CYAN}4. Залізні двері закриті"
    fi

    while true; do
        read -rp "Оберіть дію [1-4]: " choice
        case $choice in
            1)
                if [[ " ${inventory[@]} " =~ "sword" ]]; then
                    echo -e "${YELLOW}Ви вже взяли меч.${NC}"
                else
                    echo -e "${GREEN}Ви берете іржавий меч. Він може стати в нагоді.${NC}"
                    inventory+=("sword")
                fi
                current_room="armory"
                break
                ;;
            2)
                echo -e "${BLUE}Коли ви торкаєтеся обладунків, вони з гуркотом падають!${NC}"
                ((health--))
                check_health
                current_room="armory"
                break
                ;;
            3)
                current_room="entrance_hall"
                break
                ;;
            4)
                if [[ " ${inventory[@]} " =~ "key" ]]; then
                    echo -e "${GREEN}Ключ підходить! Двері скриплячі відчиняються.${NC}"
                    current_room="treasure_room"
                    break
                else
                    echo -e "${RED}Двері надійно закриті. Вам потрібен ключ.${NC}"
                    current_room="armory"
                    break
                fi
                ;;
            *)
                echo -e "${RED}Невірний вибір!${NC}"
                ;;
        esac
    done
}

library() {
    clear
    echo -e "${BLUE}
░▒▓█▓▒░      ░▒▓█▓▒░▒▓███████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓█▓▒░▒▓███████▓▒░░▒▓███████▓▒░░▒▓████████▓▒░▒▓███████▓▒░ ░▒▓██████▓▒░  
░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░     
░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░     
░▒▓████████▓▒░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░${NC}"
    echo -e "\nСтародавні фоліанти заповнюють стіни. Одна книга світиться моторошним синім світлом."
    echo -e "Повітря насичене магією..."
    display_health
    echo -e "${CYAN}1. Прочитати світячуся книгу"
    echo -e "2. Шукати приховані виходи"
    echo -e "3. Повернутися до вхідної зали${NC}"
    
    while true; do
        read -rp "Оберіть дію [1-3]: " choice
        case $choice in
            1) 
                echo -e "${RED}Коли ви відкриваєте книгу, з неї виходять тіньові щупальця!${NC}"
                ((health--))
                check_health
                sleep 2
                current_room="entrance_hall"
                break
                ;;
            2)
                if [[ " ${inventory[@]} " =~ "key" ]]; then
                    echo -e "${GREEN}Ви помічаєте прихований прохід і використовуєте ключ, щоб відкрити його!${NC}"
                    current_room="treasure_room"
                    break
                else
                    echo -e "${GREEN}Ви знаходите срібний ключ, схований за книгою!${NC}"
                    inventory+=("key")
                    sleep 2
                fi
                current_room="library"
                break
                ;;
            3) current_room="entrance_hall"; break;;
            *) echo -e "${RED}Невірний вибір!${NC}";;
        esac
    done
}

east_wing() {
    clear
    echo -e "${RED}
    🕯️ Східне крило 🕯️
    Повітря насичене запахом тління. 
    Миготливі смолоскипи виявляють плями крові на килимі.${NC}"
    display_health
    echo -e "${CYAN}1. Слідувати за плямами крові"
    echo -e "2. Відступити до вхідної зали"
    echo -e "3. Обшукати територію${NC}"

    while true; do
        read -rp "Оберіть дію [1-3]: " choice
        case $choice in
            1)
                echo -e "${RED}На вас нападають тіньові істоти!${NC}"
                ((health -= 2))
                check_health
                current_room="dungeon"
                break
                ;;
            2)
                current_room="entrance_hall"
                break
                ;;
            3)
                if [[ " ${inventory[@]} " =~ "torch" ]]; then
                    echo -e "${YELLOW}Ви нічого нового не знаходите.${NC}"
                else
                    echo -e "${GREEN}Ви берете смолоскип зі стіни.${NC}"
                    inventory+=("torch")
                fi
                current_room="east_wing"
                break
                ;;
            *)
                echo -e "${RED}Невірний вибір!${NC}"
                ;;
        esac
    done
}

dungeon() {
    clear
    echo -e "${BLUE}
    🕳️ Підземелля 🕳️
    Смердючий запах гниття переповнює вас. 
    Камери розташовані вздовж стін, у деяких є кістяки.${NC}"
    display_health
    echo -e "${CYAN}1. Обшукати камери"
    echo -e "2. Спробувати втекти"
    echo -e "3. Дослідити дивний звук${NC}"

    while true; do
        read -rp "Оберіть дію [1-3]: " choice
        case $choice in
            1)
                echo -e "${BLUE}Ви знаходите фрагмент кістки з дивними різьбленнями.${NC}"
                inventory+=("bone fragment")
                current_room="dungeon"
                break
                ;;
            2)
                echo -e "${YELLOW}Ви намагаєтеся пробитися крізь темряву.${NC}"
                current_room="east_wing"
                break
                ;;
            3)
                echo -e "${RED}Примарний стогін пронизує ваш розум!${NC}"
                ((health--))
                check_health
                current_room="dungeon"
                break
                ;;
            *)
                echo -e "${RED}Невірний вибір!${NC}"
                ;;
        esac
    done
}

treasure_room() {
    clear
    if [[ " ${inventory[@]} " =~ "key" ]]; then
        echo -e "${YELLOW}
   __________________________
  /=======__________________/|
 /_________________________/ |
|_________________________|  |
| |                    |  |  |
| |     $$$  $$$  $$$  |  |  |
|_|____________________|  |  |
|_________________________| /
|_________________________|/${NC}"
        echo -e "\nЗолоті двері відчиняються! Перед вами неймовірні скарби!"
        echo -e "Але замок починає руйнуватися навколо вас..."
        display_health
        echo -e "${CYAN}1. Взяти скарби і втекти"
        echo -e "2. Взяти лише маленькі коштовності"
        echo -e "3. Піти з порожніми руками${NC}"
        
        while true; do
            read -rp "Оберіть дію [1-3]: " choice
            case $choice in
                1)
                    echo -e "${RED}Ви втікаєте багатим, але прокляття переслідує вас...${NC}"
                    game_over "greed"
                    break
                    ;;
                2)
                    echo -e "${GREEN}Ви втікаєте зі скромним багатством і своїм життям!${NC}"
                    game_over "success"
                    break
                    ;;
                3)
                    echo -e "${BLUE}Замок зникає, коли ви втікаєте. Що було реальним?${NC}"
                    game_over "mystery"
                    break
                    ;;
                *) echo -e "${RED}Невірний вибір!${NC}";;
            esac
        done
    else
        echo -e "${RED}Двері закриті! Вам потрібен ключ.${NC}"
        sleep 2
        current_room="armory"
    fi
}

check_health() {
    if (( health <= 0 )); then
        clear
        game_over_art
        echo -e "\n${RED}💀 ВАШЕ СВІТЛО ЗГАСАЄ... ГРА ЗАКІНЧЕНА 💀${NC}"
        exit 0
    fi
}

game_over() {
    clear
    case $1 in
        "cowardice") 
            echo -e "${BLUE}Таємниці замку залишаються назавжди невідомими...${NC}"
            ;;
        "greed") 
            echo -e "${RED}Жадібність поглинає вас у кінці...${NC}"
            ;;
        "success") 
            echo -e "${GREEN}
   ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
   ██▀▀▀▀███▀▀▀▀███▀▀▀▀▀██▀▀▀▀██▀▀▀▀▀█▀▀▀▀▀██▀▀▀▀███▀▀▀▀███▀▀▀▀███▀▀▀▀███▀▀▀▀███▀▀▀▀██
   ██▄▄▄▄███▄▄▄▄███▄▄▄▄▄██▄▄▄▄██▄▄▄▄▄█▄▄▄▄▄██▄▄▄▄████▄▄▄▄███▄▄▄▄███▄▄▄▄███▄▄▄▄███▄▄▄▄██
   ██         ██▒▒▒▒▒▒██          ██          ██▒▒▒▒▒▒██          ██          ██
   ██▄▄▄▄▄▄▄▄▄██▒▒▒▒▒▒██▄▄▄▄▄▄▄▄▄▄▄██▄▄▄▄▄▄▄▄▄▄▄██▒▒▒▒▒▒██▄▄▄▄▄▄▄▄▄▄▄██▄▄▄▄▄▄▄▄▄▄▄██
   █████████████████████████████████████████████████████████████████████████████${NC}"
            ;;
        "mystery") 
            echo -e "${PURPLE}Таємниця залишається... але ви вижили!${NC}"
            ;;
        *) 
            echo -e "${RED}Гра закінчена!${NC}"
            ;;
    esac
    echo
    read -rp "Грати знову? (y/n): " choice
    if [[ "$choice" =~ ^[Yy] ]]; then
        inventory=()
        health=3
        current_room="start"
    else
        echo "Дякуємо за гру!"
        exit 0
    fi
}

while true; do
    case $current_room in
        "start") start;;
        "entrance_hall") entrance_hall;;
        "library") library;;
        "treasure_room") treasure_room;;
        "courtyard") courtyard;;
        "armory") armory;;
        "east_wing") east_wing;;
        "dungeon") dungeon;;
        *) echo "Невірна кімната!"; exit 1;;
    esac
    sleep 1
done
