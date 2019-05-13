#!/bin/bash

name="$(echo $1 | sed 's/\.[^.]*$//')"
echo -e "\nBinary file to analyse: $name\n"

output_dir=/private/var/tmp/"$name"
mkdir $output_dir
chmod 777 $output_dir

###FUNCTIONS###
otool_aslr=$(otool -Vh "${name}")
otool_ssp=$(otool -I -v "${name}" | grep stack_chk_guard)
otool_arc=$(otool -I -v "${name}" | grep _objc_release)

strings_full=$(strings "${name}" > "$output_dir"/strings_full.txt)
strings_5=$(cat "$output_dir"/strings_full.txt | grep -E "\w{5}" > "$output_dir"/strings_5.txt)
keywords_grep=$(cat "$output_dir"/strings_5.txt | grep -e "admin" -e "administrator" -e "password" -e "pw" -e "user" -e "uname" -e "username" -e "usr" -e "select" -e "insert" -e "delete" -e "alter" -e "modify" -e "hostname" -e "key" -e "ip" -e "db" -e "database" -e "sql" -e "connection_string" > "$output_dir"/strings_keywords.txt)

###EXECUTION###
echo -e "\n[1] Checking for Address Space Layout Randomization (ASLR) PIE flag...\n"
echo -e "$otool_aslr\n\n"

echo -e "\n[2] Checking for Stack Smashing Protector Flag (SSP)...\n"
echo -e "$otool_ssp\n\n"

echo -e "\n[3] Checking for Automatic Reference Counting (ARC)...\n"
echo -e "$otool_arc\n\n"

echo -e "\n[4] Extracting all strings to "$output_dir"/strings_full.txt...\n"
echo -e "$strings_full\n"

echo -e "\n[5] Extracting all strings with more than 5 readable chars to "$output_dir"/strings_5.txt...\n"
echo -e "$strings_5\n"

echo -e "\n[6] Looking for keywords, output keywords found to "$output_dir"/strings_keywords.txt...\n"
echo -e "$keywords_grep\n\n"


