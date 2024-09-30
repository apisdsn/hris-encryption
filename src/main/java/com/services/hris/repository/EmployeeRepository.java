package com.services.hris.repository;

import com.services.hris.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, UUID> {
    @Query(value = "SELECT e.id, e.id_workspaces, e.id_karir, e.name, e.gender, e.start_work, e.nip, " +
            "d.decrypted_nik AS nik, d.decrypted_npwp AS npwp, d.decrypted_alamat AS alamat, " +
            "d.decrypted_no_kk AS no_kk, e.grup, e.id_atasan, e.resign_date, e.is_deleted, " +
            "e.created_at, e.updated_at, e.deleted_at " +
            "FROM employee e, " +
            "LATERAL decrypt_employee_data(e.nik, e.npwp, e.alamat, e.no_kk) AS d(decrypted_nik, decrypted_npwp, decrypted_alamat, decrypted_no_kk)" +
            ";", nativeQuery = true)
    List<Employee> getAllDataEmployee();

    @Query(value = "SELECT e.id, e.id_workspaces, e.id_karir, e.name, e.gender, e.start_work, e.nip, " +
            "e.nik, e.npwp, e.alamat, " +
            "e.no_kk, e.grup, e.id_atasan, e.resign_date, e.is_deleted, " +
            "e.created_at, e.updated_at, e.deleted_at " +
            "FROM employee e " +
            "LIMIT 10;", nativeQuery = true)
    List<Employee> getAllDataEmployeeNoEnc();

    @Query(value = "SELECT e.id, e.id_workspaces, e.id_karir, e.name, e.gender, e.start_work, e.nip, " +
            "d.decrypted_nik AS nik, d.decrypted_npwp AS npwp, d.decrypted_alamat AS alamat, " +
            "d.decrypted_no_kk AS no_kk, e.grup, e.id_atasan, e.resign_date, e.is_deleted, " +
            "e.created_at, e.updated_at, e.deleted_at " +
            "FROM employee e, " +
            "LATERAL decrypt_employee_data(e.nik, e.npwp, e.alamat, e.no_kk) AS d(decrypted_nik, decrypted_npwp, decrypted_alamat, decrypted_no_kk) " +
            "WHERE e.name = ?1 ", nativeQuery = true)
    Optional<Employee> getEmployeesByName(String name);

    boolean existsEmployeeByNip(String nip);
}
