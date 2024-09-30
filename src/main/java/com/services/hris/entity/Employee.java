package com.services.hris.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.UUID;

@Entity
@Table(name = "employee", schema = "public")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "id")
    private UUID id;

    @Column(name = "id_workspaces")
    private UUID id_workspaces;

    @Column(name = "id_karir")
    private UUID id_karir;

    @Column(name = "name", columnDefinition = "TEXT")
    private String name;

    @Column(name = "gender", columnDefinition = "TEXT")
    private String gender;

    @Column(name = "start_work")
    private Date start_work;

    @Column(name = "nip", columnDefinition = "TEXT")
    private String nip;

    @Column(name = "nik", columnDefinition = "BYTEA")
    private byte[] nik;

    @Column(name = "npwp", columnDefinition = "BYTEA")
    private byte[] npwp;

    @Column(name = "alamat", columnDefinition = "BYTEA")
    private byte[] alamat;

    @Column(name = "no_kk", columnDefinition = "BYTEA")
    private byte[] no_kk;

    @Column(name = "grup", columnDefinition = "TEXT")
    private String grup;

    @Column(name = "id_atasan", columnDefinition = "TEXT")
    private String id_atasan;

    @Column(name = "resign_date")
    private Date resign_date;

    @Column(name = "is_deleted")
    private Boolean is_deleted;

    @Column(name = "created_at")
    private LocalDateTime created_at;

    @Column(name = "updated_at")
    private LocalDateTime updated_at;

    @Column(name = "deleted_at")
    private LocalDateTime deleted_at;
}
