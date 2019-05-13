#!/bin/bash

name="$(echo $1 | sed 's/\.[^.]*$//')"
echo "Binary file to analyse: $name"

output_dir=/private/var/tmp/"$name"/
mkdir $output_dir
chmod 777 $output_dir

###FUNCTIONS###
otool_aslr=$(otool -Vh "${name}")
otool_ssp=$(otool -I -v "${name}" | grep stack_chk_guard)
otool_arc=$(otool -I -v "${name}" | grep _objc_release)

strings_full=$(strings "${name}" > /private/var/tmp/"$name"/strings_full.txt)

###EXECUTION###
echo -e "\n[1] Checking for Address Space Layout Randomization (ASLR) PIE flag...\n"
echo -e "$otool_aslr\n\n"

echo -e "\n[2] Checking for Stack Smashing Protector Flag (SSP)...\n"
echo -e "$otool_ssp\n\n"

echo -e "\n[3] Checking for Automatic Reference Counting (ARC)...\n"
echo -e "$otool_arc\n\n"

echo -e "\n[4] Extracting all strings to "$output_dir"...\n"
echo -e "$strings_full\n\n"

