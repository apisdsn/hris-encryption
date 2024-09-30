package com.services.hris.service.impl;

import com.services.hris.entity.Employee;
import com.services.hris.model.EmployeeRequest;
import com.services.hris.model.EmployeeResponse;
import com.services.hris.repository.EmployeeRepository;
import com.services.hris.service.EmployeeService;
import io.micrometer.common.util.StringUtils;
import jakarta.persistence.Id;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
@Slf4j
public class EmployeeServiceImpl implements EmployeeService {

    @Autowired
    private final EmployeeRepository employeeRepository;

    @Override
    public List<EmployeeResponse> getAllEmployees() {
        List<Employee> employees = employeeRepository.getAllDataEmployee();
        return employees.stream().map(this::toEmployeeResponse).toList();
    }

    @Override
    public List<EmployeeResponse> getAllEmployeesNoEnc() {
        List<Employee> employees = employeeRepository.getAllDataEmployeeNoEnc();
        return employees.stream().map(this::toEmployeeResponse).toList();
    }

    @Override
    public EmployeeResponse getEmployeeByName(String name) {
        if (StringUtils.isBlank(name)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Name cannot be null or empty");
        }

        Employee employee = employeeRepository.getEmployeesByName(name)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Employee with name " + name + " not found"));

        return toEmployeeResponse(employee);
    }

    @Transactional
    @Override
    public void createEmployee(EmployeeRequest request) {
        validateEmployeeRequest(request);

        if(employeeRepository.existsEmployeeByNip(request.getNip())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Employee with NIP " + request.getNip() + " already exists");
        }

        Employee employee = new Employee();

        employee.setId(UUID.randomUUID());
        employee.setId_workspaces(UUID.randomUUID());
        employee.setId_karir(UUID.randomUUID());
        employee.setName(request.getName());
        employee.setGender(request.getGender());
        employee.setStart_work(request.getStart_work());
        employee.setNip(request.getNip());
        employee.setNik(request.getNik().getBytes());
        employee.setNpwp(request.getNpwp().getBytes());
        employee.setNo_kk(request.getNo_kk().getBytes());
        employee.setAlamat(request.getAlamat().getBytes());
        employee.setGrup(request.getGrup());
        employee.setId_atasan(request.getId_atasan());
        employee.setCreated_at(LocalDateTime.now());
        employee.setResign_date(request.getResign_date());
        employee.setIs_deleted(false);

        employeeRepository.save(employee);
    }

    @Transactional
    @Override
    public EmployeeResponse updateEmployee(EmployeeRequest request, String name) {
        Employee employee = employeeRepository.getEmployeesByName(name)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Employee with name " + name + " not found"));

        Optional.ofNullable(request.getName()).ifPresent(employee::setName);
        Optional.ofNullable(request.getGender()).ifPresent(employee::setGender);
        Optional.ofNullable(request.getStart_work()).ifPresent(employee::setStart_work);
        Optional.ofNullable(request.getNip()).ifPresent(employee::setNip);

        Optional.ofNullable(request.getNik())
                .filter(nik -> !nik.isEmpty())
                .map(String::getBytes)
                .ifPresent(employee::setNik);

        Optional.ofNullable(request.getNpwp())
                .filter(npwp -> !npwp.isEmpty())
                .map(String::getBytes)
                .ifPresent(employee::setNpwp);

        Optional.ofNullable(request.getNo_kk())
                .filter(no_kk -> !no_kk.isEmpty())
                .map(String::getBytes)
                .ifPresent(employee::setNo_kk);

        Optional.ofNullable(request.getAlamat())
                .filter(alamat -> !alamat.isEmpty())
                .map(String::getBytes)
                .ifPresent(employee::setAlamat);

        Optional.ofNullable(request.getGrup()).ifPresent(employee::setGrup);
        Optional.ofNullable(request.getId_atasan()).ifPresent(employee::setId_atasan);
        Optional.ofNullable(request.getResign_date()).ifPresent(employee::setResign_date);
        Optional.ofNullable(request.getIs_deleted()).ifPresent(employee::setIs_deleted);

        employee.setUpdated_at(LocalDateTime.now());

        Employee updatedEmployee = employeeRepository.save(employee);

        return toEmployeeResponse(updatedEmployee);
    }


    private void validateEmployeeRequest(EmployeeRequest request) {
        if (request == null || request.getName() == null || request.getName().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid employee request");
        }
    }

    @Override
    public void deleteEmployee(String name) {
        Employee employee = employeeRepository.getEmployeesByName(name)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Employee with name " + name + " not found"));
        employeeRepository.delete(employee);
    }

    private EmployeeResponse toEmployeeResponse(Employee employee){
        return EmployeeResponse.builder()
                .id(employee.getId())
                .id_workspaces(employee.getId_workspaces())
                .id_karir(employee.getId_karir())
                .name(employee.getName())
                .gender(employee.getGender())
                .start_work(employee.getStart_work())
                .nip(employee.getNip())
                .nik(new String(employee.getNik()))
                .npwp(new String(employee.getNpwp()))
                .no_kk(new String(employee.getNo_kk()))
                .alamat(new String(employee.getAlamat()))
                .grup(employee.getGrup())
                .id_atasan(employee.getId_atasan())
                .resign_date(employee.getResign_date())
                .is_deleted(employee.getIs_deleted())
                .created_at(employee.getCreated_at())
                .updated_at(employee.getUpdated_at())
                .deleted_at(employee.getDeleted_at())
                .build();
    }
}
