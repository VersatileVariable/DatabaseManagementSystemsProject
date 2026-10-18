import csv

filename = "emails.csv"
rows = []
row_quantity = 0

with open (filename, 'r') as csvfile:
    csvreader = csv.reader(csvfile)

    for row in csvreader:
        rows.append(row)

    for row in rows:
        if row[0] == 'michael.clark373@gmail.com':
            row_quantity = row_quantity + 1
            
    print("Number of occurences of michael.clark373@gmail.com:")
    print(row_quantity)

    
