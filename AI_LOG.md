https://github.com/VersatileVariable/DatabaseManagementSystemsProject
Usage occured on October 17 and 18.
￼
Gemini Usage:
Context:
Originally, we tried to parse the data with a Google Sheet. The first question we asked AI was to understand the proper way to convert date formats. We meant for it to be contextualization, but it gave us the answer without having prompted for it. We already had a python script (which we had done by hand, only using ChatGPT for debugging, see log at end of document) that had an answer of 69. The AI response, however, was 62. Because the answers were different, we investigated what was resulting in two different answers. We ended up not using the Google Sheet and relying only on the python scripts, which is why that chat log was not submitted. But, given that the number of 62 came from that chat history, we should have included it, which was our error. Below is a screenshot of the query. All other queries from this log were related to parsing through the data using a google spreadsheet, which we decided to abandon because the python scripts seemed more promising. However, we can provide the remainder of that chat query if necessary.
￼

The full Gemini chat (the new log that we started when moving from the spreadsheet idea to fixing the python scripts) is pasted in screenshots below, but this is the link to the actual log: https://share.gemini.google/20MDyJq96m8w

Gemini was used in the spirit of checking answers. The final answer to Q3 was never copy/pasted or otherwise pulled from AI. It was left blank until we could understand and produce a genuine output. We were initially planning to use our value of 69, until we were able to de-bug and identify the missing null case. Doing so produced 62 by our own methods. We submitted 62 as our answer, but only because that was what we produced through a script that we felt was accurate, not because it was what AI said.

This question was put into AI for context. At this point, we had already received the answer from the earlier chat log (which we unintentionally omitted because that chat log had been for the Google Spreadsheet, which we had abandoned in favor of the scripts). My partner was trying to create a new, clean chat log, and tried supplying the question only to give it context. However, in supplying the question and not adding any additional rules, the AI thought it was supposed to answer it, and so it did. We have now learned to explicitly deliver the AI Policy at the start of any chat history and state that it is not allowed to deliver any answers, so as to not violate academic integrity.
￼
The chat continued with me inquiring to understand the logic error so that we could debug the code if it seemed appropriate.
￼
￼
It then explained its thoughts on the logic error and provided additional context. 
￼
￼
Having this information allowed us to understand and identify where we had gone wrong in our own thought process, then write our own code to fix our script. After we added the error checking for null entries, our code returned 62. As mentioned above, as we identified this number through our own means, we were confident in 62 being the correct answer and because we identified that value through our own code, we submitted that as our own answer.
￼

ChatGPT Usage:
BRIEF SUMMARY:
What was asked and What was Done with the Answer: 
A variety of debugging questions as I was working through scripts to process the CSV data. I used GeeksForGeeks to learn the libraries I needed to use, then when I ran into issues, I would ask ChatGPT to help explain why I was going wrong. I haven't used Python much, so most of this was beginner de-bugging as I was learning how to use the various libraries.
I asked it --> What I learned + what I did:
* Why my whitespace stripping wasn't working --> I just needed to append .strip to row[4].lower so it would edit the stored string value
* Why my append was only adding one value instead of multiple --> I figured out the error on my own, ChatGPT didn't have the right advice
* Why variables were being parsed by letter, not variable --> I needed to wrap the string in a one-item list
* Why I couldn't compare two variables --> I needed to index, despite thinking I had isolated the variable on its own
* Why the index was claiming to be out of range --> I was mistaken in my indexing so had to update the counting
* Why it only recorded one instance instead of multiple identical rows --> I apparently had combined the email and id in one string, so the comparison only found the exact string once
* Why my datetime comparison wasn't working --> I apparently was trying to compare string datetime with seconds.

After having spoken about properly using AI without violating Academic Integrity, I recognize that I also should have included in the first chat message that it was not allowed to provide any answers whatsoever. 

TRANSCRIPT:
Me:
I am using this code to lowercase and remove the trailing whitespaces of entries in my csv file. Why is it not actually removing whitespaces?

 for row in rows:
        updated = row[4].lower()
        updated.strip(" ")

        print(updated)

ChatGPT:
Strings are immutable, so strip() returns a new string. Your code calls it but discards the result.
To remove trailing whitespace, assign the result:

for row in rows:
    updated = row[4].lower().rstrip()
    print(updated)

rstrip() removes whitespace at the end, including spaces and tabs. Use .strip() instead if you want to remove whitespace from both ends.

Me:
Why is only one value getting added to the updated list? It should have each row, but it only prints the value from one row. 

 for row in rows:
        updated = row[4].lower().strip(" ")
        updatedRows.append(updated)

ChatGPT:
That loop should append one value to updatedRows for every row it processes. If you’re only seeing one value, check that updatedRows is initialized before the loop and that you print the list after the loop:

updatedRows = []

for row in rows:
    updatedRows.append(row[4].lower().strip())

print(updatedRows)

If you print updated after the loop, you’ll see only its final value. Also, .strip() with no argument removes whitespace such as spaces and tabs from both ends.

Me:
I got that working, I was just using the wrong variable it turns out. But now when all of it is added to the csv, it is all parsed by comma so only one letter per field. How do I fix that? This is what I had.

with open(updatefilename, 'w') as updatedcsvfile:
    writer = csv.writer(updatedcsvfile)
    writer.writerows(updatedRows)

ChatGPT:
writerows() expects each item to be a row. Since each item in updatedRows is a string, Python treats its characters as separate fields.
Wrap each string in a one-item list:

with open(updatefilename, "w", newline="") as updatedcsvfile:
    writer = csv.writer(updatedcsvfile)
    writer.writerows([value] for value in updatedRows)

That writes each value in its own row, in a single column.

Me:
I know this value is present in the csv file, why is it stating 0?

for row in rows:
        if row == 'michael.clark373@gmail.com':
            row_quantity = row_quantity + 1
            
    print(row_quantity)

ChatGPT:
csv.reader returns each row as a list of fields, so row isn’t equal to the email string. Since you previously accessed the email with row[4], compare that field instead:

row_quantity = 0

for row in rows:
    if row[4].strip().lower() == "michael.clark373@gmail.com":
        row_quantity += 1

print(row_quantity)

.strip().lower() also handles extra surrounding whitespace and capitalization differences.

Me:
Why is count out of range?

import csv

filename = "CSVs/members.csv"
updatefilename = "cleaned_members.csv"
fields = []
csv_rows = []
rows, cols = (372, 2)
updatedRows = [[0]*cols]*rows

with open (filename, 'r') as csvfile:
    csvreader = csv.reader(csvfile)

    fields = next(csvreader)
    for row in csvreader:
        csv_rows.append(row)

    print("Row quantity: %d" % csvreader.line_num)

    count = 0
    for row in csv_rows:
        updated = row[3].lower().strip(" ")
        id = row[0]

        updatedRows[0][count] = updated
        updatedRows[1][count] = id
        count = count + 1
…

ChatGPT:
updatedRows has 372 rows, each with only 2 slots. So when count reaches 2, updatedRows[0][count] is out of range.
You likely want each CSV record to become one output row with two fields: the cleaned value and the ID. Build those rows with append():

updatedRows = []

for row in csv_rows:
    updated = row[3].lower().strip()
    member_id = row[0]
    updatedRows.append([updated, member_id])

Then write them with writer.writerows(updatedRows). This also avoids [[0] * cols] * rows, which makes every row refer to the same inner list.

Me:
This seems to only record one occurence, though I believe it is supposed to discover multiple. Why is this?

from collections import Counter
import csv

filename = "cleaned_members.csv"

fields = []
rows = []

with open (filename, 'r') as csvfile:
    csvreader = csv.reader(csvfile)

    fields = next(csvreader)
    for row in csvreader:
        rows.append(row)

    print("Row quantity: %d" % csvreader.line_num)

    count = list(set(i for j in rows for i in j))
    print(str(count))

    already_discovered = []
    dup_values = []
    for row in rows:
        if row not in already_discovered:
            quantity = rows.count(row)

            dup_values.append([row, quantity])
            already_discovered.append(row)

    print(dup_values)
…
Worked for 7s


ChatGPT:
Your loop treats a whole row as the value to compare. It counts repeated identical rows only; if the same email appears with a different ID, those rows are different. It also adds rows with a count of 1 to dup_values.
Since your cleaned file puts the email in column 0, count that field and keep only values that appear more than once:

email_counts = Counter(row[0].strip().lower() for row in rows)

dup_values = [
    [email, quantity]
    for email, quantity in email_counts.items()
    if quantity > 1
]

print(dup_values)

If you meant to find duplicate entire rows, count tuples instead:

row_counts = Counter(tuple(row) for row in rows)
dup_values = [[row, quantity] for row, quantity in row_counts.items() if quantity > 1]


Me:
This is an example of the dataset that I have:

"['robert.anderson34@hotmail.com', '2218']"
"['sharon.allen68@gmail.com', '1948']"
"['john.rivera190@outlook.com', '1889']"
"['carlos.jackson157@proton.me', '2215']"
"['jason.wilson131@hotmail.com', '2166']"
"['sharon.garcia499@yahoo.com', '2463']"
"['omar.ramirez809@proton.me', '1985']"
"['brian.moore935@yahoo.com', '1992']"
"['laura.kim504@icloud.com', '2111']"
Worked for 8s


ChatGPT:
Those examples suggest each CSV line contains one text field holding a string that looks like a Python list. So csv.reader likely returns a row like:

["['robert.anderson34@hotmail.com', '2218']"]

That means row[0] is the whole string, not just the email. You can parse that string with ast.literal_eval and then count its first item:

import ast
from collections import Counter

records = [ast.literal_eval(row[0]) for row in rows]
email_counts = Counter(record[0].strip().lower() for record in records)

duplicates = [
    [email, quantity]
    for email, quantity in email_counts.items()
    if quantity > 1
]

print(duplicates)

For future files, write each record as two CSV fields—email and ID—instead of writing the string representation of a list.

Me:
I’m working on datetime conversions to be able to see if a time happened before it was supposed to. I have this data and this code. Can you help me identify why it is not working?

2024-01-01 00:00:00,2024-01-25 00:00:00
2024-05-30 00:00:00,2024-05-30 00:00:00

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
        print(row[0])
        print("\n")
        print(row[1])

        out_date = datetime.datetime.strptime(row[0], "%S")
        back_date = datetime.datetime.strptime(row[1], "%S")
        
        if (back_date - out_date) < 0:
            aggregate += 1
            
   # print("Number of occurences in which dates are off:")
   # print(aggregate)
…
Worked for 7s


ChatGPT:
There are three issues:
1. from datetime import datetime imports the datetime class, so call datetime.strptime(...), not datetime.datetime.strptime(...).
2. "%S" matches only seconds. Your timestamps need "%Y-%m-%d %H:%M:%S".
3. Your sample has no header, so fields = next(csvreader) skips the first data row.
Here’s a corrected version that counts rows where the second timestamp is earlier than the first:

import csv
from datetime import datetime

filename = "cleaned_dates.csv"
aggregate = 0
date_format = "%Y-%m-%d %H:%M:%S"

with open(filename, "r", newline="") as csvfile:
    csvreader = csv.reader(csvfile)

    for row in csvreader:
        first_date = datetime.strptime(row[0], date_format)
        second_date = datetime.strptime(row[1], date_format)

        if second_date < first_date:
            aggregate += 1

print("Number of occurrences where the second date is earlier:", aggregate)

With the two sample rows shown, the count is 0: the second date is later in the first row and equal in the second. If your file does have a header, keep next(csvreader) to skip it.
