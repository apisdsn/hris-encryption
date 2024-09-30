package com.services.hris.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class EmployeeResponse {
    private UUID id;
    private UUID id_workspaces;
    private UUID id_karir;
    private String name;
    private String gender;
    private Date start_work;
    private String nip;
    private String nik;
    private String npwp;
    private String no_kk;
    private String alamat;
    private String grup;
    private String id_atasan;
    private Date resign_date;
    private Boolean is_deleted;
    private LocalDateTime created_at;
    private LocalDateTime updated_at;
    private LocalDateTime deleted_at;
}
