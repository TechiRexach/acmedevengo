require 'rails/all'
require 'csv'
require "awesome_print"

#leemos todos los datos del csv
csv_hcm = CSV.read("hcm.csv", headers: true)
#ap csv_hcm.map{|l| l.to_h}

#creamos el hash nuevo
employees_data = Hash.new

#de cada row seleccionamos el ID como identificador y rellenamos el hash nuevo
csv_hcm.each do |employee|
    employees_data[ employee["ID"] ] = employee.to_h
end

#ap employees_data

csv_payroll = CSV.read("payroll.csv", headers: true)

#preparamos las dos posibles uniones, las que dan error y las que estan ok
merge = {errors: [], ok: []}

def valid?(e)
    e['ID'] != nil
  #ap e['TELEPHONE'] != nil
#   xxxx
    #e[:errors] = "Falta teléfono"
    e
end

#recorremos fichero nominas
csv_payroll.each do |payroll|
    #traemos el id del empleado desde el cvs de empleados (OJO QUE SIN DATOS DE NOMINA NO LO TRAE)
    employee = employees_data[payroll['worker_id']]
    #ap employee
    #comprobamos que ese empleado existe en el fichero
    if employee
        employee_payroll = payroll.to_h.merge(employee)
        # ap employee_payroll
        if employee_payroll = valid?(employee_payroll)
            merge[:ok] << employee_payroll
            #ap merge[:ok]
        else
            merge[:errors] << employee_payroll
            ap employee_payroll
        end
    else
        
        employee_payroll = payroll.to_h
        employee_payroll[:errors] = 'Nómina sin datos de empleado'
        merge[:errors] << employee_payroll
        #ap merge[:errors]
    end
end

CSV.open('result.csv', 'w') do |csv|

    csv << %w(id dni name surname telephone email user_principal_name area iban start_date end_date company_id company_name net_salary extrapayroll_1 extrapayroll_2 extrapayroll_3 )

    merge[:ok].each do |employee| 
        ap employee
        csv << employee.values_at('ID', 'DNI', 'NAME', 'SURNAME', 'TELEPHONE', 'EMAIL', 'USER_PRINCIPAL_NAME', 'AREA', 'IBAN', 'START_DATE', 'END_DATE', 'COMPANY_ID', 'COMPANY_NAME', 'net_salary', 'extrapayroll_1', 'extrapayroll_2', 'extrapayroll_3')
    end
end

CSV.open('errors.csv', 'w') do |csv|

    csv << %w(id dni name surname telephone email user_principal_name area iban start_date end_date company_id company_name net_salary extrapayroll_1 extrapayroll_2 extrapayroll_3 )

    merge[:errors].each do |employee| 
        csv << employee.values_at('ID', 'DNI', 'NAME', 'SURNAME', 'TELEPHONE', 'EMAIL', 'USER_PRINCIPAL_NAME', 'AREA', 'IBAN', 'START_DATE', 'END_DATE', 'COMPANY_ID', 'COMPANY_NAME', 'net_salary', 'extrapayroll_1', 'extrapayroll_2', 'extrapayroll_3')
    end
end
