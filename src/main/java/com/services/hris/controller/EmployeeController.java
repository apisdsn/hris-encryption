package com.services.hris.controller;

import com.services.hris.model.EmployeeRequest;
import com.services.hris.model.EmployeeResponse;
import com.services.hris.model.WebResponse;
import com.services.hris.service.impl.EmployeeServiceImpl;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "Employee", description = "Controllers for Employee APIs")
@RestController
@RequestMapping("/api/")
public class EmployeeController {

    @Autowired
    private EmployeeServiceImpl employeeServiceImpl;

    @PostMapping(path = "/employee", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public WebResponse<String> createEmployee(@RequestBody EmployeeRequest employeeRequest){
        employeeServiceImpl.createEmployee(employeeRequest);
        return WebResponse.<String>builder().data("data employee has created").build();
    }

    @GetMapping(path = "/employees/all", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public WebResponse<List<EmployeeResponse>> getAllEmployees() {
        List<EmployeeResponse> employeeResponseAll = employeeServiceImpl.getAllEmployees();
        return WebResponse.<List<EmployeeResponse>>builder().data(employeeResponseAll).build();
    }

    @GetMapping(path = "/employees/all/noenc", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public WebResponse<List<EmployeeResponse>> getAllEmployeeNoEnc() {
        List<EmployeeResponse> employeeResponseAll = employeeServiceImpl.getAllEmployeesNoEnc();
        return WebResponse.<List<EmployeeResponse>>builder().data(employeeResponseAll).build();
    }

    @GetMapping(path = "/employee/{name}", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public WebResponse<EmployeeResponse> getEmployeeByName(@PathVariable String name) {
        EmployeeResponse getEmployeeByName = employeeServiceImpl.getEmployeeByName(name);
        return WebResponse.<EmployeeResponse>builder().data(getEmployeeByName).build();
    }

    @PatchMapping(path = "/employee/{name}", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public WebResponse<EmployeeResponse> updateEmployeeByName(@PathVariable String name, @RequestBody EmployeeRequest request){
        EmployeeResponse updatedEmployee = employeeServiceImpl.updateEmployee(request, name);
        return WebResponse.<EmployeeResponse>builder().data(updatedEmployee).build();
    }

    @DeleteMapping(path = "/employee/{name}", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public WebResponse<String> deleteEmployee(@PathVariable String name){
        employeeServiceImpl.deleteEmployee(name);
        return WebResponse.<String>builder().data("data employee has deleted").build();
    }
}
