require 'rails/all'
require 'csv'

hcm = 'hcm.csv'
payroll = 'payroll.csv'

csv_hcm = CSV.read(hcm, headers: true)

csv_pay = CSV.read(payroll, headers: true)

puts csv_hcm

puts 'holi'

puts csv_pay
