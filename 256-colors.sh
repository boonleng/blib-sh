#!/bin/bash
 
# Foreground color (f) with black background and
# Background color (b) with white foreground
echo -en "Get foreground colors by \\\033[38;5;\033[3;4mnum\033[23;24m\t\t\t"
echo -e "Get background colors by \\\\033[48;5;\033[3;4mnum\033[23;24m\n"

b=-2
for f in {-2..256} ; do
    if [ ${f} -ge 0 ]; then
        echo -en "\033[38;5;${f};48;5;232m  ${f}\t\033[0m"
    else
        echo -en "\t"
    fi
    if [ $(((${f} + 9) % 6)) == 0 ] ; then
        echo -en "\t"
        while [ ${b} -le ${f} ] ; do
            if [ ${b} -ge 0 ]; then
                echo -en "\033[97;48;5;${b}m  ${b}\t\033[0m"
            else
                echo -en "  .\t"
            fi
            b=$((b + 1))
        done
        echo ""
    fi
done

echo -e "\n"
