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
    echo -e "${RED}Health: $hearts${NC}\n"
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
    echo -e "${YELLOW}You stand before an ancient castle. Moonlight filters through broken windows."
    echo -e "A cold wind whispers through empty halls. Your lantern flickers weakly...${NC}"
    echo
    display_health
    echo -e "${CYAN}1. Enter the castle gates"
    echo -e "2. Turn back and leave"
    echo -e "3. Search the courtyard${NC}"
    
    while true; do
        read -rp "Choose your action [1-3]: " choice
        case $choice in
            1) current_room="entrance_hall"; break;;
            2) game_over "cowardice"; break;;
            3) current_room="courtyard"; break;;
            *) echo -e "${RED}Invalid choice!${NC}";;
        esac
    done
}

courtyard() {
    clear
    echo -e "${GREEN}
    🌳 Courtyard 🌳
    Overgrown with vines. A stone well stands in the center. 
    A statue of a knight lies toppled over.${NC}"
    display_health
    echo -e "${CYAN}1. Peer into the well"
    echo -e "2. Examine the statue"
    echo -e "3. Return to the castle entrance${NC}"

    while true; do
        read -rp "Choose your action [1-3]: " choice
        case $choice in
            1)
                echo -e "${BLUE}You see something glittering at the bottom. A rope is nearby.${NC}"
                echo -e "${CYAN}1. Use the rope to retrieve the item"
                echo -e "2. Leave it alone${NC}"
                read -rp "Choose: " sub_choice
                if [[ $sub_choice == 1 ]]; then
                    if [[ " ${inventory[@]} " =~ "amulet" ]]; then
                        echo -e "${YELLOW}You find nothing else.${NC}"
                    else
                        echo -e "${GREEN}You retrieve a rusty amulet! It feels cold.${NC}"
                        inventory+=("amulet")
                    fi
                else
                    echo -e "${YELLOW}You decide not to risk it.${NC}"
                fi
                current_room="courtyard"
                break
                ;;
            2)
                echo -e "${BLUE}The statue's shield has strange inscriptions.${NC}"
                echo -e "${CYAN}1. Try to read the inscriptions"
                echo -e "2. Move on${NC}"
                read -rp "Choose: " sub_choice
                if [[ $sub_choice == 1 ]]; then
                    echo -e "${YELLOW}The inscriptions warn of a curse. You feel uneasy...${NC}"
                    ((health--))
                    check_health
                else
                    echo -e "${YELLOW}You avoid touching the statue.${NC}"
                fi
                current_room="courtyard"
                break
                ;;
            3)
                current_room="start"
                break
                ;;
            *)
                echo -e "${RED}Invalid choice!${NC}"
                ;;
        esac
    done
}

entrance_hall() {
    clear
    echo -e "${PURPLE}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
    echo -e "${BLUE}                    🕍 ENTRANCE HALL 🕍"
    echo -e "${PURPLE}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
    echo -e "\nDust swirls in the moonlight. A grand staircase splits left and right."
    echo -e "There's an odd smell coming from the east wing."
    display_health
    echo -e "${CYAN}1. Go up left staircase"
    echo -e "2. Go up right staircase"
    echo -e "3. Investigate east wing"
    echo -e "4. Return to courtyard${NC}"
    
    while true; do
        read -rp "Choose your action [1-4]: " choice
        case $choice in
            1) current_room="library"; break;;
            2) current_room="armory"; break;;
            3) current_room="east_wing"; break;;
            4) current_room="courtyard"; break;;
            *) echo -e "${RED}Invalid choice!${NC}";;
        esac
    done
}

armory() {
    clear
    echo -e "${CYAN}
    ⚔️ Armory ⚔️
    Rusted weapons line the walls. An empty suit of armor stands guard.
    There's a locked iron door to the north.${NC}"
    display_health
    options=("3. Return to entrance hall")
    if [[ " ${inventory[@]} " =~ "sword" ]]; then
        echo -e "${CYAN}1. Take a sword (already taken)"
    else
        echo -e "${CYAN}1. Take a rusted sword from the wall"
    fi
    echo -e "${CYAN}2. Investigate the suit of armor"
    if [[ " ${inventory[@]} " =~ "key" ]]; then
        echo -e "${CYAN}4. Unlock the iron door with the key"
    else
        echo -e "${CYAN}4. The iron door is locked"
    fi

    while true; do
        read -rp "Choose your action [1-4]: " choice
        case $choice in
            1)
                if [[ " ${inventory[@]} " =~ "sword" ]]; then
                    echo -e "${YELLOW}You already took the sword.${NC}"
                else
                    echo -e "${GREEN}You take a rusted sword. It might be useful.${NC}"
                    inventory+=("sword")
                fi
                current_room="armory"
                break
                ;;
            2)
                echo -e "${BLUE}As you touch the armor, it collapses loudly!${NC}"
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
                    echo -e "${GREEN}The key fits! The door creaks open.${NC}"
                    current_room="treasure_room"
                    break
                else
                    echo -e "${RED}The door is securely locked. You need a key.${NC}"
                    current_room="armory"
                    break
                fi
                ;;
            *)
                echo -e "${RED}Invalid choice!${NC}"
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
    echo -e "\nAncient tomes line the walls. One book glows with eerie blue light."
    echo -e "The air feels thick with magic..."
    display_health
    echo -e "${CYAN}1. Read the glowing book"
    echo -e "2. Search for hidden exits"
    echo -e "3. Return to entrance hall${NC}"
    
    while true; do
        read -rp "Choose your action [1-3]: " choice
        case $choice in
            1) 
                echo -e "${RED}As you open the book, shadowy tendrils emerge!${NC}"
                ((health--))
                check_health
                sleep 2
                current_room="entrance_hall"
                break
                ;;
            2)
                if [[ " ${inventory[@]} " =~ "key" ]]; then
                    echo -e "${GREEN}You notice a hidden passage and use the key to open it!${NC}"
                    current_room="treasure_room"
                    break
                else
                    echo -e "${GREEN}You find a silver key hidden behind a book!${NC}"
                    inventory+=("key")
                    sleep 2
                fi
                current_room="library"
                break
                ;;
            3) current_room="entrance_hall"; break;;
            *) echo -e "${RED}Invalid choice!${NC}";;
        esac
    done
}

east_wing() {
    clear
    echo -e "${RED}
    🕯️ East Wing 🕯️
    The air is thick with the smell of decay. 
    Flickering torches reveal bloodstains on the carpet.${NC}"
    display_health
    echo -e "${CYAN}1. Follow the bloodstains"
    echo -e "2. Retreat to entrance hall"
    echo -e "3. Search the area${NC}"

    while true; do
        read -rp "Choose your action [1-3]: " choice
        case $choice in
            1)
                echo -e "${RED}You're ambushed by shadow creatures!${NC}"
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
                    echo -e "${YELLOW}You find nothing new.${NC}"
                else
                    echo -e "${GREEN}You grab a torch from the wall.${NC}"
                    inventory+=("torch")
                fi
                current_room="east_wing"
                break
                ;;
            *)
                echo -e "${RED}Invalid choice!${NC}"
                ;;
        esac
    done
}

dungeon() {
    clear
    echo -e "${BLUE}
    🕳️ Dungeon 🕳️
    The stench of rot overwhelms you. 
    Cells line the walls, some containing skeletal remains.${NC}"
    display_health
    echo -e "${CYAN}1. Search the cells"
    echo -e "2. Try to escape back"
    echo -e "3. Investigate a strange sound${NC}"

    while true; do
        read -rp "Choose your action [1-3]: " choice
        case $choice in
            1)
                echo -e "${BLUE}You find a bone fragment with strange carvings.${NC}"
                inventory+=("bone fragment")
                current_room="dungeon"
                break
                ;;
            2)
                echo -e "${YELLOW}You struggle back through the darkness.${NC}"
                current_room="east_wing"
                break
                ;;
            3)
                echo -e "${RED}A ghostly wail pierces your mind!${NC}"
                ((health--))
                check_health
                current_room="dungeon"
                break
                ;;
            *)
                echo -e "${RED}Invalid choice!${NC}"
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
        echo -e "\nThe golden door opens! Before you lies unimaginable treasure!"
        echo -e "But the castle begins to collapse around you..."
        display_health
        echo -e "${CYAN}1. Grab treasure and run"
        echo -e "2. Take only small jewels"
        echo -e "3. Leave empty-handed${NC}"
        
        while true; do
            read -rp "Choose your action [1-3]: " choice
            case $choice in
                1)
                    echo -e "${RED}You escape rich but the curse follows you...${NC}"
                    game_over "greed"
                    break
                    ;;
                2)
                    echo -e "${GREEN}You escape with modest wealth and your life!${NC}"
                    game_over "success"
                    break
                    ;;
                3)
                    echo -e "${BLUE}The castle vanishes as you escape. What was real?${NC}"
                    game_over "mystery"
                    break
                    ;;
                *) echo -e "${RED}Invalid choice!${NC}";;
            esac
        done
    else
        echo -e "${RED}The door is locked! You need a key.${NC}"
        sleep 2
        current_room="armory"
    fi
}

check_health() {
    if (( health <= 0 )); then
        clear
        game_over_art
        echo -e "\n${RED}💀 YOUR LIGHT FADES... GAME OVER 💀${NC}"
        exit 0
    fi
}

game_over() {
    clear
    case $1 in
        "cowardice") 
            echo -e "${BLUE}The castle's secrets remain forever unknown...${NC}"
            ;;
        "greed") 
            echo -e "${RED}Greed consumes you in the end...${NC}"
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
            echo -e "${PURPLE}The mystery lingers... but you survived!${NC}"
            ;;
        *) 
            echo -e "${RED}Game Over!${NC}"
            ;;
    esac
    echo
    read -rp "Play again? (y/n): " choice
    if [[ "$choice" =~ ^[Yy] ]]; then
        inventory=()
        health=3
        current_room="start"
    else
        echo "Thanks for playing!"
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
        *) echo "Invalid room!"; exit 1;;
    esac
    sleep 1
done
