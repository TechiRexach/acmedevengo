require 'rails/all'
require 'csv'

hcm = 'hcm.csv'
payroll = 'payroll.csv'
result = 'result.csv'

# csv_hcm = CSV.read(hcm, headers: true)

# csv_pay = CSV.read(payroll, headers: true)

target1 = 'ID'
target2 = 'worker_id'

new_target = target1 + '/' + target2

csv1 = CSV.read(hcm, headers: true, header_converters: lambda {|header| header == target1 ? new_target : header})

csv2 = CSV.read(payroll, headers: true)

headers1 = csv1.headers

headers2 = csv2.headers - [target2]

# csv1[i][new_target] == csv2[i][target2]

CSV.open(result, 'w') do |csv|
    csv << headers1 + headers2
    [csv1.size, csv2.size].min.times do |i|
        csv << (headers1.map {|h| csv1[i][h]} + 
        headers2.map {|h| csv2[i][h] }) if 
            csv1[i][new_target] == csv2[i][target2]
    end 
end

puts File.read(result)