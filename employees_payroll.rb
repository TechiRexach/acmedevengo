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

#preparamos las dos posibles uniones, las que dan error y las que estan ok
merge = {errors: [], ok: []}

def valid?(e)
    ap e
ap e['TELEPHONE']
     e['ID'] == true
       
    e['worker_id'] == true
    
  
#   xxxx
    #e[:errors] = "Falta teléfono"
    e
end

#recorremos fichero nominas
csv_payroll.each do |payroll|
    #traemos el id del empleado desde el cvs de empleados (OJO QUE SIN DATOS DE NOMINA NO LO TRAE) hay que solucionarlo antes
    employee = employees_data[payroll['worker_id']]
   
    #comprobamos que ese empleado existe en el fichero
    if employee
        #unimos la info de los dos csv segun la id
        employee_payroll = payroll.to_h.merge(employee)
      #comprobamos errores
        if employee_payroll = valid?(employee_payroll)
            #ap employee_payroll
            merge[:ok] << employee_payroll
            #ap merge[:ok]
        else
            merge[:errors] << employee_payroll
            #ap merge[:errors]
        end
    else
        employee_payroll = payroll.to_h
        employee_payroll[:errors] = 'Nómina sin datos de empleado'
        merge[:errors] << employee_payroll
        #ap merge[:errors]
    end

end

# lines2.each do |l|  # recorremos fichero 2
#   from_1 = data1[ l[:worker_id] ] # cogemos los datos de esa linea del fichero 1
#   if from_1 # comprobamos si existía en fichero 1
#     m = l.to_h.merge(from_1) # juntamos los datos
#     if m = valid?(m) # comprobamos si son validos
#       merge[:ok] << m 
#     else
#       merge[:errors] << m
#     end
#   else # significa que no está en fichero 1
#     m = l.to_h
#     m[:error] = "Nómina sin empleado" # le ponemos un error para ser consistentes con valid?
#     merge[:errors] << m
#   end
# end

# # dump de ok

# CSV.open(xxxx) do |csv|
#   merge[:ok].each{|l| csv << l.values_at(xxxxx)  }
# end

# # dump de errors
# merge[:errors]


CSV.open('result.csv', 'w') do |csv|

    csv << %w(id dni name surname telephone email user_principal_name area iban start_date end_date company_id company_name net_salary extrapayroll_1 extrapayroll_2 extrapayroll_3 )

    merge[:ok].each do |employee| 
        csv << employee.values_at('ID', 'DNI', 'NAME', 'SURNAME', 'TELEPHONE', 'EMAIL', 'USER_PRINCIPAL_NAME', 'AREA', 'IBAN', 'START_DATE', 'END_DATE', 'COMPANY_ID', 'COMPANY_NAME', 'net_salary', 'extrapayroll_1', 'extrapayroll_2', 'extrapayroll_3')
    end
end

CSV.open('errors.csv', 'w') do |csv|

    csv << %w(id dni name surname telephone email user_principal_name area iban start_date end_date company_id company_name net_salary extrapayroll_1 extrapayroll_2 extrapayroll_3 )

    merge[:errors].each do |employee| 
        csv << employee.values_at('ID', 'DNI', 'NAME', 'SURNAME', 'TELEPHONE', 'EMAIL', 'USER_PRINCIPAL_NAME', 'AREA', 'IBAN', 'START_DATE', 'END_DATE', 'COMPANY_ID', 'COMPANY_NAME', 'net_salary', 'extrapayroll_1', 'extrapayroll_2', 'extrapayroll_3')
    end
end
