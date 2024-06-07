################################################################################
##                                  PopRunner caselet                         ##
################################################################################

# This script is based on the PopRunner data - PopRunner is an online retailer
# Use the caselet and data (consumer.csv, pop_up.csv, purchase.csv, email.csv) 
# In this script, we will use SQL to do descriptive statistics

options(warn=-1) 
library(sqldf)

################################################################################

# Read the data in: consumer, pop_up, purchase and email tables

# set your working directory and use read.csv() to read files

setwd("/Users/SURGE/Desktop/Poprunner")

consumer<-read.csv("consumer.csv",header=TRUE)
pop_up<- read.csv("pop_up.csv",header=TRUE)
purchase<-read.csv("purchase.csv",header=TRUE)
email<-read.csv("email.csv",header=TRUE)

# Let us first start with exploring various tables

################################################################################

# Using SQL's LIMIT clause, display first 5 rows of all the four tables

# observe different rows and columns of the tables

################################################################################

# Query 1) Display first 5 rows of consumer table

sqldf("SELECT * FROM consumer LIMIT 5")

################################################################################

# Query 2) Display first 5 rows of pop_up table

sqldf("SELECT * FROM pop_up LIMIT 5")

################################################################################

# Query 3) Display first 5 rows of purchase table

sqldf("SELECT * FROM purchase LIMIT 5")

################################################################################

# Query 4) Display first 5 rows of email table

sqldf("SELECT * FROM email LIMIT 5")

################################################################################

# Now, let's look at the descriptive statistics one table at a time: consumer table

# Query 5: Display how many consumers are female and male (column alias: gender_count), 
#          also show what is the average age (column alias: average_age) of consumers by gender

# SELECT COUNT(*) AS <new column name>,
#        AVG(<column name>) AS <new column name>,
#        <grouping variable 1> FROM <table name> 
# GROUP BY <grouping variable 1>

# Hint: you will GROUP BY gender

sqldf("SELECT gender,COUNT(*) AS gender_count, AVG(gender) AS average_age FROM consumer GROUP BY gender")

sqldf("SELECT gender,COUNT(gender) AS gender_count, AVG(gender) AS average_age FROM consumer GROUP BY gender")

# Interpret your output in simple English (1-2 lines):

# In the above two queries we can say that the results display the number of consumers and their average age categorized by gender. In other terms it shows the count and average age of female consumers.

################################################################################

# Query 6: How many consumers are there in each loyalty status group (column alias: loyalty_count), 
# what is the average age (column alias: average_age) of consumers in each group

# Syntax: 

# SELECT COUNT(*) AS <new column name>,
#        AVG(<column name>) AS <new column name>,
#        <grouping variable 1> FROM <table name> 
# GROUP BY <grouping variable 1>

# Hint: you will GROUP BY loyalty_status

sqldf("SELECT loyalty_status, COUNT(*) AS loyalty_count, AVG(age) AS average_age FROM consumer GROUP BY loyalty_status")

# Interpret your output in simple English (1-2 lines):

# The results show the number of customers and their average age based on their loyalty status. It means we can see how many customers fall into each loyalty category and what their average age is.

################################################################################

# Next, let's look at the pop_up table

# Query 7: How many consumers (column alias: consumer_count) who received a
# pop_up message (column alias: pop_up)
# continue adding discount code to their card (column alias: discount_code) 
# opposed to consumers who do not receive a pop_up message

# Syntax: 

# SELECT COUNT(*) AS <new column name>,
#        <grouping variable 1> AS <new column name>, 
#        <grouping variable 2> AS <new column name> FROM <table name> 
# GROUP BY <grouping variable 1>, <grouping variable 2>

# Hint: you will use two grouping variable: GROUP BY pop_up, saved_discount

sqldf("SELECT pop_up, saved_discount AS discount_code, COUNT(*) AS consumer_count FROM pop_up GROUP BY pop_up, saved_discount")

# Interpret your output in simple English (1-2 lines):

# The results indicate the number of customers who received a pop up message divided into those who saved a discount code and those who didn't.In other words it shows how many customers were categorized based on whether they received a pop up message and saved a discount code or not.

################################################################################

# This is purchase table

# Query 8: On an average, how much did consumers spend on their 
# total sales (column alias: total_sales) during their online purchase

# Syntax:

# SELECT AVG(<column name>) AS <new column name> FROM <table name>

sqldf("SELECT AVG(sales_amount_total) AS average_sales FROM purchase")

# Interpret your output in simple English (1-2 lines):

# The result provides the sales value derived from the purchase records. It can be understood as the amount that customers spend when making purchases.

################################################################################

# Finally, let's look at the email table

# Query 9: How many consumers (column alias: consumer_count) of the total opened the email blast

# Syntax:

# SELECT COUNT(*) AS <new column name>,
#       <group variable 1> from <table name> 
#   GROUP BY <group variable 1>

sqldf("SELECT opened_email, COUNT(*) AS consumer_count FROM email GROUP BY opened_email")

# Interpret your output in simple English (1-2 lines):

# The result shows the count of individuals who accessed the email blast. In terms it represents the number of people who opened the email blast.

######################################################################################################

# Now we will combine/ merge tables to find answers

# Query 10: Was the pop-up advertisement successful? Mention yes/ no. 
# In other words, did consumers who received a pop_up message buy more

# Syntax:

# SELECT SUM(<column name>) AS <new column name>,
#        AVG(<column name>) AS <new column name>, 
#        <grouping variable 1> from <table 1>, <table 2>
#      WHERE <table 1>.<key column>=<table 2>.<key column> 
#      GROUP BY <grouping variable 1>

# Hint: you will calculate SUM of sales_amount_total (column alias: sum_sales)
# and AVG of sales_amount_total (column alias: avg_sales)
# GROUP BY pop_up
# Inner join on purchase and pop_up table on consumer_id

sqldf("SELECT pu.pop_up,SUM(p.sales_amount_total) AS sum_sales,AVG(p.sales_amount_total) AS avg_sales FROM purchase p INNER JOIN pop_up pu ON p.consumer_id = pu.consumer_id GROUP BY pu.pop_up")

sqldf("SELECT pop_up,SUM(sales_amount_total) AS sum_sales,AVG(sales_amount_total) AS avg_sales FROM pop_up INNER JOIN purchase ON pop_up.consumer_id = purchase.consumer_id GROUP BY pop_up")

# Interpret your output in simple English (1-2 lines):

# The output shows the sum and average of total sales amount for consumers who received or did not receive a pop-up message. Interpretation: Whether consumers who received a pop-up message made more purchases.

######################################################################################################

# Query 11) Did the consumer who spend the least during online shopping opened the pop_up message? Use nested queries.

# Write two separate queries 

# Query 11.1) Find the consumer_id who spent the least from the purchase table

# you can use ORDER BY and LIMIT clause together

# Syntax: 

# SELECT <column name> FROM <table name>
# ORDER BY <column name> LIMIT 1)

# Note: Here I am expecting details of only one consumer with minimum purchase. 
# Therefore, LIMIT 1. There are many consumers with sales_amount_total = 0, 
# however, you need information of any one for your second part of the project.

sqldf("SELECT consumer_id FROM purchase ORDER BY sales_amount_total LIMIT 1")

# Query 11.2) Use the consumer_id from the previous SELECT query to find if the consumer received a pop_up message from the pop_up table

sqldf("SELECT pu.consumer_id,pu.pop_up FROM pop_up pu INNER JOIN (SELECT consumer_id FROM purchase ORDER BY sales_amount_total LIMIT 1) p ON pu.consumer_id = p.consumer_id")

sqldf("SELECT consumer_id, pop_up FROM pop_up WHERE consumer_id = (SELECT consumer_id FROM purchase ORDER BY sales_amount_total LIMIT 1)")

# Query 11.3) Using ? for inner query, create a template to write nested query

sqldf("SELECT pu.consumer_id FROM pop_up pu WHERE pu.consumer_id = (SELECT consumer_id FROM purchase ORDER BY sales_amount_total LIMIT 1)") 
 
sqldf("SELECT pu.consumer_id,pop_up,saved_discount FROM pop_up pu INNER JOIN (SELECT consumer_id FROM purchase ORDER BY sales_amount_total LIMIT 1) AS p ON pu.consumer_id = p.consumer_id")

sqldf("SELECT consumer_id, pop_up FROM pop_up WHERE consumer_id = (?)")

# Query 11.4) Replace ? with the inner query

# Syntax:

# SELECT <column name 1>, <column name 2> FROM <table name> WHERE consumer_id = 
#      (inner query from Query 11.1)

sqldf("SELECT pu.consumer_id,pu.pop_up,pu.saved_discount FROM pop_up pu WHERE pu.consumer_id = (SELECT consumer_id FROM purchase ORDER BY sales_amount_total LIMIT 1)")

sqldf("SELECT consumer_id,pop_up,saved_discount FROM pop_up pu WHERE consumer_id = (SELECT consumer_id FROM purchase ORDER BY sales_amount_total LIMIT 1)")

# Interpret your output in simple English (1-2 lines):

# The nested queries identify whether the consumer who spent the least during online shopping opened the pop-up message. Interpretation: Determining if consumers with minimal spending opened the pop-up message.


######################################################################################################

# Query 12: Was the email blast successful? Mention yes/ no. 
# In other words, did consumers who opened the email blast buy more

# Syntax:

# SELECT SUM(<column name>) AS <new column name>,
#        AVG(<column name>) AS <new column name>, 
#        <grouping variable 1> from <table 1>, <table 2>
#      WHERE <table 1>.<key column>=<table 2>.<key column> 
#      GROUP BY <grouping variable 1>

# Hint: you will calculate SUM of sales_amount_total (column alias: sum_sales) 
# and AVG of sales_amount_total (column alias: avg_sales)
# GROUP BY opened_email
# Inner join on purchase and email table on consumer_id

sqldf("SELECT opened_email, SUM(sales_amount_total) AS sum_sales, AVG(sales_amount_total) AS avg_sales FROM purchase INNER JOIN email ON purchase.consumer_id = email.consumer_id GROUP BY email.opened_email")

# Interpret your output in simple English (1-2 lines):

# The output shows the sum and average of total sales amount for consumers who opened or did not open the email blast. Interpretation: Whether consumers who opened the email blast made more purchases.


######################################################################################################

# Query 13) Did the consumer who spend the most during online shopping opened the email message? Use nested queries.

# Write two separate queries 

# Query 13.1) Find the consumer_id who spent the most from the purchase table

# you can use ORDER BY and LIMIT clause together

# Syntax: 

# SELECT <column name> FROM <table name>
# ORDER BY <column name> DESC LIMIT 1)

sqldf("SELECT consumer_id FROM purchase ORDER BY sales_amount_total DESC LIMIT 1")


# Query 13.2) Use the consumer_id from the previous SELECT query to find if the consumer opened the email from the email table

sqldf("SELECT e.consumer_id FROM email e WHERE e.consumer_id = (SELECT consumer_id FROM purchase ORDER BY sales_amount_total DESC LIMIT 1)")


# Query 13.3) Replace ? with the inner query

# Syntax:

# SELECT <column name 1>, <column name 2> FROM <table name> WHERE consumer_id IN 
#      (inner query from Query 13.1)


sqldf("SELECT e.consumer_id,e.opened_email FROM email e WHERE e.consumer_id = (SELECT consumer_id FROM purchase ORDER BY sales_amount_total DESC LIMIT 1)")

sqldf("SELECT consumer_id,opened_email FROM email WHERE consumer_id = (SELECT consumer_id FROM purchase ORDER BY sales_amount_total DESC LIMIT 1)")

