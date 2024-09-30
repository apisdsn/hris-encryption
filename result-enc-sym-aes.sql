CREATE EXTENSION pgcrypto;

-- CREATE TABLE EMPLOYEE FOR ENCRYPTION
CREATE TABLE employee (
                                     id UUID PRIMARY KEY,
                                     id_workspaces UUID NOT NULL,
                                     id_karir UUID NOT NULL,
                                     name VARCHAR(255) NOT NULL,
                                     gender VARCHAR(20) NOT NULL,
                                     start_work DATE NOT NULL,
                                     nip VARCHAR(50) NOT NULL,
                                     nik BYTEA NOT NULL,
                                     npwp BYTEA NOT NULL,
                                     alamat BYTEA NOT NULL,
                                     no_kk BYTEA NOT NULL,
                                     grup VARCHAR(100) NOT NULL,
                                     id_atasan VARCHAR(50),
                                     resign_date DATE,
                                     is_deleted BOOLEAN DEFAULT FALSE,
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     deleted_at TIMESTAMP
);

--INSERT MOCK DATA TO TABLE EMPLOYEE
INSERT INTO employee (id, id_workspaces, id_karir, name, gender, start_work, nip, nik, npwp, alamat, no_kk, grup, id_atasan, resign_date, is_deleted, created_at, updated_at, deleted_at)
VALUES (
           'a3d4e656-27b1-11ee-be56-0242ac120002',
           'e1b9d5e4-27b2-11ee-be56-0242ac120002',
           'd1c2f567-27b3-11ee-be56-0242ac120002',
           'Andi Saputra',
           'Male',
           '2020-01-15',
           '198765432',
           '1234567890123456',
           '0987654321098765',
           'Jl. Mawar No.123, Jakarta',
           '3210987654321098',
           'IT',
           '124567890',
           NULL,
           FALSE,
           NOW(),
           NOW(),
           NULL
       );

-- INSERT 10 MOCK DATA TO TABLE EMPLOYEE
INSERT INTO employee (id, id_workspaces, id_karir, name, gender, start_work, nip, nik, npwp, alamat, no_kk, grup, id_atasan, resign_date, is_deleted, created_at, updated_at, deleted_at)
VALUES
    (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'Andi Saputra', 'Male', '2020-01-15', '198765432', '1234567890123456', '0987654321098765', 'Jl. Mawar No.123, Jakarta', '3210987654321098', 'IT', '124567890', NULL, FALSE, NOW(), NOW(), NULL),
    (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'Budi Santoso', 'Male', '2019-06-01', '298765432', '1234567890321456', '0987654321098754', 'Jl. Melati No.456, Bandung', '4210987654321098', 'Finance', '223467890', NULL, FALSE, NOW(), NOW(), NULL),
    (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'Citra Dewi', 'Female', '2018-11-20', '398765432', '1234567890543216', '0987654321098763', 'Jl. Dahlia No.789, Surabaya', '5210987654321098', 'HR', '324567890', NULL, FALSE, NOW(), NOW(), NULL),
    (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'Doni Ramadhan', 'Male', '2021-03-05', '498765432', '1234567890654321', '0987654321098762', 'Jl. Kamboja No.321, Medan', '6210987654321098', 'Marketing', '424567890', NULL, FALSE, NOW(), NOW(), NULL),
    (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'Eka Yulianto', 'Male', '2017-09-25', '598765432', '1234567890765432', '0987654321098761', 'Jl. Kenanga No.654, Makassar', '7210987654321098', 'IT', '524567890', NULL, FALSE, NOW(), NOW(), NULL),
    (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'Fani Wijaya', 'Female', '2016-02-18', '698765432', '1234567890876543', '0987654321098760', 'Jl. Anggrek No.987, Yogyakarta', '8210987654321098', 'Operations', '624567890', NULL, FALSE, NOW(), NOW(), NULL),
    (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'Gilang Pratama', 'Male', '2022-07-12', '798765432', '1234567890987654', '0987654321098759', 'Jl. Cempaka No.123, Bali', '9210987654321098', 'Sales', '724567890', NULL, FALSE, NOW(), NOW(), NULL),
    (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'Hendra Kurniawan', 'Male', '2021-11-10', '898765432', '1234567891098765', '0987654321098758', 'Jl. Teratai No.456, Semarang', '1021987654321098', 'Legal', '824567890', NULL, FALSE, NOW(), NOW(), NULL),
    (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'Indah Lestari', 'Female', '2019-05-14', '998765432', '1234567891110987', '0987654321098757', 'Jl. Flamboyan No.789, Palembang', '1121987654321098', 'Finance', '924567890', NULL, FALSE, NOW(), NOW(), NULL),
    (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'Joko Setiawan', 'Male', '2020-08-19', '108765432', '1234567891221098', '0987654321098756', 'Jl. Tulip No.321, Malang', '1221987654321098', 'HR', '102456789', NULL, FALSE, NOW(), NOW(), NULL);

-- FUNCTION TRIGGER ENCRYPTION EMPLOYEE SYMMETRIC ALGORITHM AES256
CREATE OR REPLACE FUNCTION encrypt_data_table_employee()
    RETURNS TRIGGER AS $$
DECLARE
    password TEXT := pg_read_file('/Library/PostgreSQL/16/data/keys/password-decrypt.txt');
    options TEXT := 'compress-algo=0, cipher-algo=aes256, unicode-mode=1';
BEGIN
    NEW.nik := pgp_sym_encrypt(NEW.nik::TEXT, password, options);
    NEW.npwp := pgp_sym_encrypt(NEW.npwp::TEXT, password, options);
    NEW.alamat := pgp_sym_encrypt(NEW.alamat::TEXT, password, options);
    NEW.no_kk := pgp_sym_encrypt(NEW.no_kk::TEXT, password, options);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- CREATE TRIGGER ENCRYPTION BEFORE INSERT OR UPDATE FOR TABLE EMPLOYEE SYMMETRIC ALGORITHM AES256
CREATE TRIGGER trigger_encrypt_data_sym_employee_algo_aes
    BEFORE INSERT OR UPDATE ON employee
    FOR EACH ROW
EXECUTE FUNCTION encrypt_data_table_employee();

SELECT * FROM employee;

DELETE FROM employee WHERE name = 'Andi Saputra';

TRUNCATE TABLE employee;

DROP TABLE employee;

DROP TRIGGER trigger_encrypt_data_sym_employee_algo_aes ON employee;

DROP FUNCTION decrypt_employee_data(BYTEA, BYTEA, BYTEA, BYTEA);

-- FUNCTION DECRYPTION EMPLOYEE FOR SYMMETRIC ALGORITHM AES256
CREATE OR REPLACE FUNCTION decrypt_employee_data(
    encrypted_nik BYTEA,
    encrypted_npwp BYTEA,
    encrypted_alamat BYTEA,
    encrypted_no_kk BYTEA
)
    RETURNS TABLE (
                      decrypted_nik TEXT,
                      decrypted_npwp TEXT,
                      decrypted_alamat TEXT,
                      decrypted_no_kk TEXT
                  ) AS $$
DECLARE
    password TEXT := pg_read_file('/Library/PostgreSQL/16/data/keys/password-decrypt.txt');
    unicode TEXT := 'UTF8';
BEGIN
    decrypted_nik := convert_from(pgp_sym_decrypt(encrypted_nik, password)::BYTEA, unicode);
    decrypted_npwp := convert_from(pgp_sym_decrypt(encrypted_npwp, password)::BYTEA, unicode);
    decrypted_alamat := convert_from(pgp_sym_decrypt(encrypted_alamat, password)::BYTEA, unicode);
    decrypted_no_kk := convert_from(pgp_sym_decrypt(encrypted_no_kk, password)::BYTEA, unicode);

    RETURN QUERY SELECT decrypted_nik, decrypted_npwp, decrypted_alamat, decrypted_no_kk;
END
$$ LANGUAGE plpgsql;

SELECT
    id,
    id_workspaces,
    id_karir,
    name,
    gender,
    start_work,
    NIP,
    d.decrypted_nik,
    d.decrypted_npwp,
    d.decrypted_alamat,
    d.decrypted_no_kk,
    grup,
    id_atasan,
    resign_date,
    is_deleted,
    created_at,
    updated_at,
    deleted_at
FROM
    employee e,
    LATERAL decrypt_employee_data(e.nik, e.npwp, e.alamat, e.no_kk) AS d(decrypted_nik, decrypted_npwp, decrypted_alamat, decrypted_no_kk)
LIMIT 10;

EXPLAIN ANALYZE
SELECT
    id,
    id_workspaces,
    id_karir,
    name,
    gender,
    start_work,
    NIP,
    d.decrypted_nik,
    d.decrypted_npwp,
    d.decrypted_alamat,
    d.decrypted_no_kk,
    grup,
    id_atasan,
    resign_date,
    is_deleted,
    created_at,
    updated_at,
    deleted_at
FROM
    employee e,
    LATERAL decrypt_employee_data(e.nik, e.npwp, e.alamat, e.no_kk) AS d(decrypted_nik, decrypted_npwp, decrypted_alamat, decrypted_no_kk)
LIMIT 10;
