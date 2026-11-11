Part 3 setup
============
1. Create an empty database, for example:   CREATE DATABASE library;
2. Run library_setup.sql in that database (MySQL Workbench: File > Open SQL Script, then Execute;
   command line: mysql -u root -p library < library_setup.sql).
   It contains the reference schema and a clean copy of YOUR team's data. Re-run it any time
   you want to reset your database.
3. Copy library_app.py and test_public.py into your part3/ folder.
4. pip install mysql-connector-python
5. Edit DB_CONFIG in test_public.py, then run: python test_public.py
