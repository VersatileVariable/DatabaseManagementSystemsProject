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