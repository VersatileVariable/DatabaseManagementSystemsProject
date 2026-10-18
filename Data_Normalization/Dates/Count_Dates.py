import csv
from datetime import datetime

filename = "cleaned_dates.csv"
rows = []
aggregate = 0

with open (filename, 'r') as csvfile:
    csvreader = csv.reader(csvfile)

    fields = next(csvreader)
    for row in csvreader:
        rows.append(row)

    for row in rows:
        format = "%Y-%m-%d %H:%M:%S"
        out_date = datetime.strptime(row[0], format)
        back_date = datetime.strptime(row[1], format)
        
        if (back_date < out_date):
            aggregate += 1
            #print("Back_date is")
            #print(back_date)
            #print("Out_date is")
            #print(out_date)
            
    print("Number of occurences in which dates are off:")
    print(aggregate)
