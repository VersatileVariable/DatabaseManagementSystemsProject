import csv
import datetime

filename = "data/loans.csv"
updatefilename = "Data_Normalization/Dates/cleaned_dates.csv"

fields = []
rows = []
updatedRows = []

with open (filename, 'r') as csvfile:
    csvreader = csv.reader(csvfile)

    fields = next(csvreader)
    for row in csvreader:
        rows.append(row)

    print("Row quantity: %d" % csvreader.line_num)

    counter= 0
    for row in rows:
        out_date = row[7]
        back_date = row[9]

        if("/" in out_date):
            updated = out_date.split("/")
            print(updated)
            year = int(updated[2])
            month = int(updated[0])
            day = int(updated[1])

            updated_out_date = datetime.datetime(year, month, day)

        if("-" in out_date):
            updated = out_date.split("-")
            print(updated)
            year = updated[0]
            month = updated[1]
            day = updated[2]

            updated_out_date = datetime.datetime(int(year), int(month), int(day))

        if("/" in back_date):
            updated = back_date.split("/")
            print(updated)
            year = int(updated[2])
            month = int(updated[0])
            day = int(updated[1])

            updated_back_date = datetime.datetime(year, month, day)

        if("-" in back_date):
            updated = back_date.split("-")
            print(updated)
            year = updated[0]
            month = updated[1]
            day = updated[2]

            updated_back_date = datetime.datetime(int(year), int(month), int(day))

        updatedRows.append([updated_out_date, updated_back_date]) 

with open(updatefilename, 'w') as updatedcsvfile:
    writer = csv.writer(updatedcsvfile)
    writer.writerows([out_date, back_date] for out_date, back_date in updatedRows)