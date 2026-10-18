import csv


filename = "data/inventory.csv"
rows = []
category = []
brands = []
condition = []


with open (filename, 'r') as csvfile:
    csvreader = csv.reader(csvfile)

    fields = next(csvreader)
    for row in csvreader:
        rows.append(row)
        brands.append(row[2])

        row_val = row[3].lower().strip(" ")
        category.append(row_val)

        cond_val = row[6].lower().strip(" ")
        condition.append(cond_val)

    print("Row quantity: %d" % csvreader.line_num)

    unique_brands = list(dict.fromkeys(brands))
    unique_category = list(dict.fromkeys(category))
    unique_condition = list(dict.fromkeys(condition))

    print("Brands")
    print(unique_brands)

    print("\n")

    print("Category")
    print(unique_category)

    print("\n")
    
    print("Condition")
    print(unique_condition)

