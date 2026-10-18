import csv

filename = "CSVs/loans.csv"
updatefilename = "Data_Normalization/Focus_Member/emails.csv"
fields = []
rows = []
updatedRows = []

with open (filename, 'r') as csvfile:
    csvreader = csv.reader(csvfile)

    fields = next(csvreader)
    for row in csvreader:
        rows.append(row)

    print("Row quantity: %d" % csvreader.line_num)

    for row in rows:
        updated = row[4].lower().strip(" ")
        updatedRows.append(updated) 

with open(updatefilename, 'w') as updatedcsvfile:
    writer = csv.writer(updatedcsvfile)
    writer.writerows([value] for value in updatedRows)