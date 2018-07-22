#!/bin/bash
# Put all the domain names in domains.txt, one per line
# then run in the terminal: bash domains.sh
# this will print each domain in the terminal as it looks it up
# The result csv will contain the domain, IP, MX records & Nameservers in each column

# Get reseller name from user input
echo "What would you like to save the CSV as?"

read spreadsheet

# Provide name for spreadsheet
spreadsheet=$spreadsheet'.csv'

# Give each column the relevant header titles
echo "Domain Name,IP Address,HTTP Status,Registrar,MX,MX,Nameserver,Nameserver,Nameserver,Nameserver" > $spreadsheet

while read -r domain
do
  # Get IP address defined in domain's root A-record
  ipaddress=`dig "$domain" +short`

  # Get MX-records
  mx=`dig mx "$domain" +short| sort | tr '\n' ','`

  # Get list of all nameservers
  ns=`dig ns "$domain" +short| sort | tr '\n' ','`

  # Get HTTP status code
  http=$( curl -w %{http_code} -s --output /dev/null --max-time 15 $domain)

  # Get Registrar
  registrar=`whois "$domain" | grep "Registrar:" | cut -d ":" -f 2 |  sed 's/ //' | sed -n '2!p'`

  echo "$domain"

  # Prints all the values fetched into the CSV file
  echo -e "$domain,$ipaddress,$http,$registrar,$mx,$ns" >> $spreadsheet

# Defines the text file from which to read domain names
done < domains.txt
