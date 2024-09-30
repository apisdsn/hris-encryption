package com.services.hris.service;

import com.services.hris.entity.Employee;
import com.services.hris.model.EmployeeRequest;
import com.services.hris.model.EmployeeResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.List;

public interface EmployeeService {
    List<EmployeeResponse> getAllEmployees();

    List<EmployeeResponse> getAllEmployeesNoEnc() ;

    EmployeeResponse getEmployeeByName(String name) ;

    void createEmployee(EmployeeRequest employeeRequest);

    EmployeeResponse updateEmployee(EmployeeRequest employeeRequest, String name);

    void deleteEmployee(String name);


}
