#!/bin/bash
#  ____       __  __       _
# / ___|     |  \/  | __ _| | _____ _ __
#| |  _ _____| |\/| |/ _` | |/ / _ \ '__|
#| |_| |_____| |  | | (_| |   <  __/ |
# \____|     |_|  |_|\__,_|_|\_\___|_|
 
# Create directory structure for G Drive

names=(
	Angelo
	David
	Andy
	Joseph
	Dennis
	Silas
)
list=(
	Reconnoitre
	EyeWitness
	Artifacts
	Cracked
	Uncracked
)
for i in "${names[@]}"; do
	for x in "${list[@]}"; do
		gdrive mkdir "$i-$x"
done
done

# Create local structure 
mkdir /root/Reconnoitre /root/EyeWitness /root/Artifacts /root/Cracked /root/Uncracked
