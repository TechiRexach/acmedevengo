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

csv_payroll = CSV.read("payroll.csv", headers: true)

payrolls_data = Hash.new

csv_payroll.each do |payroll|
    payrolls_data[payroll["worker_id"]] = payroll.to_h
end

#ap employees_data = payrolls_data.merge(employees_data)

 payrolls_data = employees_data.merge(payrolls_data)


#preparamos las dos posibles uniones, las que dan error y las que estan ok
merge = {errors: [], ok: []}

# creamos metodo de validación
def validate(e)

    if e['ID'].blank?
        e[:errors] = "Falta ID"
   end

   if e['DNI'].blank?
        e[:errors] = "Falta DNI"
    end

   if e['TELEPHONE'].blank?
        e[:errors] = "Falta teléfono"
   end

    e
end

#recorremos hash nominas
payrolls_data.each do |payroll|

    #traemos el id del empleado desde el cvs de empleados y del csv de nominas por si alguna no tiene datos de empleado
    employee = payrolls_data[payroll[0]] && employees_data[payroll[0]]

    #comprobamos que ese empleado existe en el fichero
    if employee

    #unimos la info de los dos csv segun la id
        employee_payroll = payroll[1].to_h.merge(employee)

    #añadimos errores
        employee_payroll = validate(employee_payroll)
        
    #mergeamos
        merge[:ok] << employee_payroll
      

    #nominas sin empleado asignado
    else
        employee_payroll = payroll[1].to_h
        
        employee_payroll[:errors] = 'Nómina sin datos de empleado'
           
        merge[:errors] << employee_payroll
    end

end


CSV.open("result_#{Date.today.strftime}.csv", 'w') do |csv|

    csv << %w(id dni name surname telephone email user_principal_name area iban start_date end_date company_id company_name net_salary extrapayroll_1 extrapayroll_2 extrapayroll_3, errors )

    merge[:ok].each do |employee| 
        csv << employee.values_at('ID', 'DNI', 'NAME', 'SURNAME', 'TELEPHONE', 'EMAIL', 'USER_PRINCIPAL_NAME', 'AREA', 'IBAN', 'START_DATE', 'END_DATE', 'COMPANY_ID', 'COMPANY_NAME', 'net_salary', 'extrapayroll_1', 'extrapayroll_2', 'extrapayroll_3', :errors)
    end
end

CSV.open("errors_#{Date.today.strftime}.csv", 'w') do |csv|

    csv << %w(id dni name surname telephone email user_principal_name area iban start_date end_date company_id company_name net_salary extrapayroll_1 extrapayroll_2 extrapayroll_3 errors)

    merge[:errors].each do |employee| 
        csv << employee.values_at('ID', 'DNI', 'NAME', 'SURNAME', 'TELEPHONE', 'EMAIL', 'USER_PRINCIPAL_NAME', 'AREA', 'IBAN', 'START_DATE', 'END_DATE', 'COMPANY_ID', 'COMPANY_NAME', 'net_salary', 'extrapayroll_1', 'extrapayroll_2', 'extrapayroll_3', :errors)
    end
end
