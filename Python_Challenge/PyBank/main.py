import os
import csv

#Import the csv file
pybank = os.path.join("..", "Resources", "budget_data.csv")

#Create variables for calculations
change_in_months = []
netchange_list = []
greatest_increase_value = 0
greatest_decrease_value = 9999999
net_total = 0
total_months = 0

#Open file using csv reader
with open(pybank, 'r') as input_file:
    csvreader = csv.reader(input_file, delimiter= ",")
    #Skip the header row
    csvheader = next(csvreader, None)
    first_row = next(csvreader, None)
    #Setting a counter for total months
    total_months = total_months + 1
    net_total = net_total + int(first_row[1])
    previous_total = int(first_row[1])
    
    #Read each row of the data after the header row
    for row in csvreader:
        total_months = total_months + 1
        net_total = net_total + int(row[1])
        #Calculate Change
        change = int(row[1]) - previous_total
        previous_total = int(row[1])
        netchange_list = netchange_list + [change]
        change_in_months = change_in_months + [row[0]]

        #Calculate greatest increase and greatest decrease
        if change > greatest_increase_value:
             greatest_increase_value = change
             greatest_increase_months = row[0]
           
        if change < greatest_decrease_value:
            greatest_decrease_value = change
            greatest_decrease_months = row[0]

#Calculate monthly average
monthly_average = round(sum(netchange_list)/len(netchange_list),2)

#Print the final analysis
print("Financial Analysis")
print(f"Total Months: {total_months}")
print(f"Total: ${net_total}")
print(f"Average Change: ${monthly_average}")
print(f"Greatest Increase in Profits: {greatest_increase_months} (${greatest_increase_value})")
print(f"Greatest Decrease in Profits: {greatest_decrease_months} (${greatest_decrease_value})")

#Write the output file
with open("output.txt", 'w') as output_file:
    output_file.write("Financial Analysis\n")
    output_file.write("----------------------------\n")
    output_file.write(f"Total Months:  {total_months}\n")
    output_file.write(f"Total:  ${net_total}\n")
    output_file.write(f"Average Change:  ${monthly_average}\n")
    output_file.write(f"Greatest Increase in Profits:  {greatest_increase_months} (${greatest_increase_value})\n")
    output_file.write(f"Greatest Decrease in Losses:  {greatest_decrease_months} (${greatest_decrease_value})\n")