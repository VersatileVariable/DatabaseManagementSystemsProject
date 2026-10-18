from collections import Counter
import csv

filename = "cleaned_members.csv"

fields = []
rows = []

with open (filename, 'r') as csvfile:
    csvreader = csv.reader(csvfile)

    for row in csvreader:
        rows.append(row)

    print("Row quantity: %d" % csvreader.line_num)

    already_discovered = []
    dup_values = []

    #Finding unique email aggregates
    for row in rows:
        if row not in already_discovered:
            quantity = rows.count(row)
            quantity_without_og = quantity - 1
            
            already_discovered.append(row)
            dup_values.append([row,quantity_without_og])

    #Summing quantity of email aggregates
    duplicate_emails = 0
    for row in dup_values:
        duplicate_emails += row[1]

    print("Number of duplicate emails found: %d" % duplicate_emails)
        
        

    



    