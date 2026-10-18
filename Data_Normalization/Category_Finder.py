import csv


filename = "CSVs/loans.csv"
rows = []
category = []

with open (filename, 'r') as csvfile:
    csvreader = csv.reader(csvfile)

    fields = next(csvreader)
    for row in csvreader:
        rows.append(row)
        category.append(row[3])

    unique = list(dict.fromkeys(category))
    print(unique)