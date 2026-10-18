import csv

filename = "CSVs/members.csv"
updatefilename = "Data_Normalization/Member_Emails/cleaned_members.csv"
fields = []
csv_rows = []
updatedRows = []

with open (filename, 'r') as csvfile:
    csvreader = csv.reader(csvfile)

    fields = next(csvreader)
    for row in csvreader:
        csv_rows.append(row)

    print("Row quantity: %d" % csvreader.line_num)

    for row in csv_rows:
        updated = row[3].lower().strip(" ")
        id = row[0]

        updatedRows.append([updated])
        
    print(updatedRows)

with open(updatefilename, 'w') as updatedcsvfile:
    writer = csv.writer(updatedcsvfile)
    writer.writerows(updated for updated in updatedRows)