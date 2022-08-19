 export CLR_ICU_VERSION_OVERRIDE=$(pacman -Q icu | awk '{split($0,a," ");print a[2]}' | awk '{split($0,a,"-");print a[1]}')
