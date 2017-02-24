#Using sqlite3 to laoddata into databse and do some data cleaning
import sqlite3
import csv
import pandas as pd
import re

#connect to database
conn=sqlite3.connect('NBAdata.db')
c=conn.cursor()

#drop all the table
#c.execute("DROP TABLE salary")

#read data(totals.csv,advanced.csv,salaries.csv,team.csv) into database
df=pd.read_csv('totals.csv')
df.to_sql('total',conn,if_exists='append',index=False)

df=pd.read_csv('advanced.csv')
df.to_sql('advance',conn,if_exists='append',index=False)

#remove the $ and , in salaries
df=pd.read_csv('salaries.csv')
for line in df:
    df[line] = df[line].str.replace("$","")
    df[line] = df[line].str.replace(",","")
df.to_sql('salary',conn,if_exists='append',index=False)

df=pd.read_csv('team.csv')
df.to_sql('team',conn,if_exists='append',index=False)

#define the season range
season=range(5,16)
    

#Create tables of different seasons
for year in season:
#    c.execute("DROP TABLE Season{:02}{:02}".format(year-1,year))
    c.execute("CREATE TABLE Season{:02}{:02} AS SELECT * FROM total WHERE season='{:02}/{:02}'".format(year-1,year,year-1,year))

#delete duplicte record
for year in season:
    c.execute("Select player From Season{:02}{:02} Where team_id='TOT'".format(year-1,year))
    for star in c.fetchall():
        print star
        c.execute("Delete From Season{:02}{:02} where player= ? and team_id!='TOT'".format(year-1,year),(star))
        
#
for year in season:
     print "Starting working on Season{:02}{:02}".format(year-1,year)
     pes=[]
     c.execute("ALTER TABLE Season{:02}{:02} ADD COLUMN salary TEXT".format(year-1,year))
     c.execute("Select pseudo From Season{:02}{:02}".format(year-1,year))
     for star in c.fetchall():
         pes.append(star)
     for pesd in pes:
         c.execute("Select Salary{:02} From salary WHERE pseudo=?".format(year),(pesd))
         temp=c.fetchone()[0]
         c.execute("UPDATE Season{:02}{:02} SET salary='{}' WHERE pseudo=?".format(year-1,year,temp),(pesd))

#delete the line if there is no salary
for year in season:
    c.execute("Delete From Season{:02}{:02} where salary='None'".format(year-1,year))

#Save into csv
c.execute("SELECT * FROM Season0405")
names = list(map(lambda x: x[0], c.description))   
with open("Season0405.csv","wb") as fout:
    csvout = csv.writer(fout)
    csvout.writerow(names)
    for row in c.fetchall():
        csvout.writerow(row)


#print out some data
c.execute("Select COUNT(*) FROM total")
print("total has {}".format(c.fetchone()[0])+" rows")
c.execute("Select COUNT(*) FROM advance")
print("advance has {} ".format(c.fetchone()[0])+" rows")
c.execute("Select COUNT(*) FROM team")
print("team has {}".format(c.fetchone()[0])+" rows")
c.execute("Select COUNT(*) FROM salary")
print("salary has {} ".format(c.fetchone()[0])+" rows")
c.execute("Select COUNT(*) FROM Season0405")
print("salary has {} ".format(c.fetchone()[0])+" rows")
c.execute("Select COUNT(*) FROM Season0506")
print("salary has {} ".format(c.fetchone()[0])+" rows")



    

    