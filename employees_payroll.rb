require 'rails/all'
require 'csv'
require "awesome_print"

csv_hcm = CSV.read("hcm.csv", headers: true)

employees_data = Hash.new

csv_hcm.each do |employee|
    employees_data[ employee["ID"] ] = employee.to_h
end

csv_payroll = CSV.read("payroll.csv", headers: true)

payrolls_data = Hash.new

csv_payroll.each do |payroll|
    payrolls_data[payroll["worker_id"]] = payroll.to_h
end

payrolls_data = employees_data.merge(payrolls_data)

merge = {errors: [], ok: []}

def validate(e)

    if e['ID'].blank?
        e[:errors] = "Missing ID"
    end

    if e['DNI'].blank?
        e[:errors] = "Missing DNI"
    end

    if e['TELEPHONE'].blank?
        e[:errors] = "Missing telephone"
    end

    if e['EMAIL'].blank?
        e[:errors] = "Missing email"
    end

    e
end

payrolls_data.each do |payroll|

    employee = payrolls_data[payroll[0]] && employees_data[payroll[0]]

    if employee

        employee_payroll = payroll[1].to_h.merge(employee)

        employee_payroll = validate(employee_payroll)
        
        merge[:ok] << employee_payroll
      
    else
        employee_payroll = payroll[1].to_h
        
        employee_payroll[:errors] = 'Payroll without employee data'
           
        merge[:errors] << employee_payroll
    end

end


CSV.open("result_#{Date.today.strftime}.csv", 'w') do |csv|

    csv << %w(id dni name surname telephone email user_principal_name area iban start_date end_date company_id company_name net_salary extrapayroll_1 extrapayroll_2 extrapayroll_3 errors )

    merge[:ok].each do |employee| 
        csv << employee.values_at('ID', 'DNI', 'NAME', 'SURNAME', 'TELEPHONE', 'EMAIL', 'USER_PRINCIPAL_NAME', 'AREA', 'IBAN', 'START_DATE', 'END_DATE', 'COMPANY_ID', 'COMPANY_NAME', 'net_salary', 'extrapayroll_1', 'extrapayroll_2', 'extrapayroll_3', :errors)
    end
end

CSV.open("errors_#{Date.today.strftime}.csv", 'w') do |csv|

    csv << %w(id dni name surname telephone email user_principal_name area iban start_date end_date company_id company_name net_salary extrapayroll_1 extrapayroll_2 extrapayroll_3 worker_id errors)

    merge[:errors].each do |employee| 
        csv << employee.values_at('ID', 'DNI', 'NAME', 'SURNAME', 'TELEPHONE', 'EMAIL', 'USER_PRINCIPAL_NAME', 'AREA', 'IBAN', 'START_DATE', 'END_DATE', 'COMPANY_ID', 'COMPANY_NAME', 'net_salary', 'extrapayroll_1', 'extrapayroll_2', 'extrapayroll_3', 'worker_id', :errors)
    end
end
