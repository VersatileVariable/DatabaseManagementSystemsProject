https://github.com/VersatileVariable/DatabaseManagementSystemsProject

Date: October 17, 2026
Tool: ChatGPT
What was asked and What was Done with the Answer: A variety of debugging questions as I was working through scripts to process the spreadsheet data. I used GeeksForGeeks to learn the libraries I needed to use, then when I ran into issues, I would ask ChatGPT to help explain why I was going wrong. I haven't used Python much, so most of this was beginner de-bugging as I was learning how to use the various libraries.

I asked it --> What I learned that I needed to have done with it:
- Why my whitespace stripping wasn't working --> I just needed to append .strip to row[4].lower so it would edit the stored string value
- Why my append was only adding one value instead of multiple --> I figured out the error on my own, ChatGPT didn't have the right advice
- Why variables were being parsed by letter, not variable --> I needed to wrap the string in a one-item list
- Why I couldn't compare two variables --> I needed to index, despite thinking I had isolated the variable on its own
- Why the index was claiming to be out of range --> I was mistaken in my indexing so had to update the counting
- Why it only recorded one instance instead of multiple identical rows --> I apparently had combined the email and id in one string, so the comparison only found the exact string once
- Why my datetime comparison wasn't working --> I apparently was trying to compare string datetime with seconds.




Date: October 18, 2026
Tool: Gemini

Use:
Advise as to what the errors within the Clean_Dates.py was. Gemini returned 62 whereas we were getting 69 (I did NOT ask for the purpose of getting the answer I was trying to contextulize it). I had Gemini help me identify why (header issue and recording the null out and back dates incorrectly), then I had it tell me what char (or lack thereof) that the null values were in order to handle them. From there I nested everything into a bigger conditional statement and upon identification of the null values break/continue through the statement because there was no update needed for a nonexisting date.

Why ask:
The file wouldn't run at first on my machine and I sent the code through Gemini to contextulize and then ask why. Then it returned a value seperate from the one returned by the code previoulsy, this indicated there there was more debugging needed so I inquired on how to fix it.

Chat:
Me: Attached loans.csv and Clean_Dates.py
bad_return_rows: How many rows in loans.csv have a back_date earlier than their out_date? Dates appear in two formats, so parse them carefully. Count every row, including exact duplicates.


Gemini: To find how many rows in loans.csv have a back_date earlier than their out_date, we parse both date columns (which appear in mixed formats such as YYYY-MM-DD and MM/DD/YYYY) into standard datetime objects and compare them.
There are 62 rows where the back_date is earlier than the out_date.


Me: how many duplicate records are in loans?


Gemini: here are 82 duplicate records in loans.csv (representing 82 redundant row copies, or 164 total rows participating in 82 identical duplicate pairs).
Breakdown:
	•	Total Rows: 4,320
	•	Unique Rows: 4,238
	•	Duplicate Rows (extra occurrences): 82


Me: of those duplicates, how many are overdue?


Gemini: Out of the duplicate records in loans.csv:
	•	20 duplicate entries are overdue (back_date > due_date) if counting the 82 redundant/extra duplicate rows.
	•	If counting all 164 rows that form duplicate pairs, 40 total rows are overdue.
Summary
	•	Total duplicate pairs/sets: 82 unique records (164 total rows)
	•	Overdue duplicate pairs: 20 distinct loan records (40 rows in total)


Me: my code runs and returnes a count of 69, why?


Gemini: Your code returns 69 (instead of 62) due to a combination of variable carry-over on missing values, header handling, and implicit date comparisons.
Here are the specific reasons why your count is 69:
1. The Carry-Over Bug with Missing back_date Values (Clean_Dates.py)
In loans.csv, there are 31 rows where back_date is completely empty (null/blank).
	•	In your loop inside Clean_Dates.py:Pythonif("/" in back_date):
	•	    ...
	•	if("-" in back_date):
	•	    ...
	•	When back_date is empty, neither if statement evaluates to true.
	•	Because updated_back_date was already defined in a previous iteration, Python carries over and reuses the back_date from the prior row for that empty row.
	•	This assigns incorrect dates to rows with missing data, altering the comparisons and adding extra false positives.
2. Header Inclusion in Count_Dates.py
In Count_Dates.py, you have:
Python

fields = next(csvreader)  # reads header
for row in csvreader:
    rows.append(row)
While next(csvreader) correctly skips the header when reading cleaned_dates.csv, your Clean_Dates.py script wrote updatedRows without writing a header row first:
Python

writer.writerows([out_date, back_date] for out_date, back_date in updatedRows)
Because no header row was written into cleaned_dates.csv, Count_Dates.py treats the very first row of data as if it were the header row (skipped by next(csvreader)), meaning your script actually skipped the first loan entry entirely!
How to Fix It
To make your scripts robust and get the correct count of 62, you should:
	1	Reset or handle empty back_date values explicitly in Clean_Dates.py (e.g., set updated_back_date = None or skip rows where back_date is empty).
	2	Include a header when writing cleaned_dates.csv (e.g., writer.writerow(['out_date', 'back_date'])), or ensure Count_Dates.py doesn't skip a valid data row.


Me: what is the char for a back date that doesnt exist


In loans.csv, missing/non-existent return dates (back_date) are represented as null (blank or NaN) values in the CSV file.
When read into Python using libraries like pandas or standard CSV readers, these missing entries show up as:
	•	NaN (Not a Number) / None in Python/pandas
	•	Empty strings ("") depending on how the line is read
