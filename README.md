# acmedevengo

## Explanation:

We recieve daily an employees data file of the ACME Corp, wich is name we are going to assume that has been accorded as ```"hcm_YYYYMMDD.csv"```.

Equally, but monthly, we recieve a payroll data file, with the name accorded as ```"payroll_YYYYMMDD.csv"``` as well as the employee file.

(The files we are going to work with in this code are not named like this to make it easier to test them).

First we should keep a copy of the original files (one daily, one monthly), just in case the company notify any errors. This provides a way to check if it is ours fault or if the company sent a bad data.

As we recieve the payroll file just once per month, we will do the merge about this file, adding the updates we recieve daily in the employees file. Also, if it is needed by the company, like at the middle of the month, we could make an update of the payroll data without any inconvenience.

Both files are related by the employee ID, so this will be our key in all the development.

We read each csv file and store the data in two new hashes using the employees ID as the keys. We now have the ```employees_data``` hash and the ```payroll_data``` hash.

Now, we will do a merge between the employees hash and the payroll hash, adding the employees ID that do not exist in the payroll hash, such as employees without payroll data. This means that now our ```payroll_data``` has all the employees ID without any of them being duplicated.

We set two possible outputs ```(:ok and :errors)``` to control if any of the data contains any error, one will contain the data that when doing the merge does not give error and the other will contain the data that must be indicated to the company to be checked.

We will also define a ``(validate)`` method that allows us to add a new column for errors in the final output. These types of errors will not condition the merge between both data, but may be important for the HR team to be aware of.

Then we go through our payroll hash where we already have all the employees and declare a variable for each one. We check that each payroll has the employee's data and verify with our ```validate``` method that it has all the important data. If this is not the case, the corresponding information will be added in the new column we created previously.

After that, we save the resulting data in the ```:ok``` output, as we are considering that missing employee data does not break the process.

In case there is a payroll with an employee ID that does not exist in the employee file sent by the company, we will add that data to the output of ```:errors```, in order to inform the company.

Finally, we are going to export the outputs with the data merged in two files (```"result_YYYYMMDD.csv"``` and ```"errors_YYYYMMDD.csv"```) that will be automatically named the same but with the daily date so that they are not overwritten and we can maintain a good consistency of the data during the whole month. This will allow us to be able to send it at any time to the company if we are requested to do so at any time.

## Usage:

This code has been written in Ruby language, so make sure to have the Rails framework installed in your computer.

Clone the Github repository on your computer, open the project folder in your terminal and run the command `ruby employees_payroll.rb`.

