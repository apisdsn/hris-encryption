CREATE EXTENSION pgcrypto;

-- CREATE TABLE EMPLOYEE FOR ENCRYPTION
CREATE TABLE employee (
                                     id UUID PRIMARY KEY,
                                     id_workspaces UUID NOT NULL,
                                     id_karir UUID NOT NULL,
                                     name VARCHAR(255) NOT NULL,
                                     gender VARCHAR(10) NOT NULL,
                                     start_work DATE NOT NULL,
                                     NIP VARCHAR(50) NOT NULL,
                                     NIK BYTEA NOT NULL,
                                     NPWP BYTEA NOT NULL,
                                     alamat BYTEA NOT NULL,
                                     NO_KK BYTEA NOT NULL,
                                     grup VARCHAR(100) NOT NULL,
                                     id_atasan VARCHAR(50),
                                     resign_date DATE,
                                     isDeleted BOOLEAN DEFAULT FALSE,
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     deleted_at TIMESTAMP
);

--INSERT MOCK DATA TO TABLE EMPLOYEE
INSERT INTO employee (id, id_workspaces, id_karir, name, gender, start_work, NIP, NIK, NPWP, alamat, NO_KK, grup, id_atasan, resign_date, isDeleted, created_at, updated_at, deleted_at)
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

-- FUNCTION DECRYPT EMPLOYEE DATA BASED ON ALGORITHM
CREATE OR REPLACE FUNCTION decrypt_employee_data(
    encrypted_NIK BYTEA,
    NIK_algorithm VARCHAR(50),
    encrypted_NPWP BYTEA,
    NPWP_algorithm VARCHAR(50),
    encrypted_alamat BYTEA,
    alamat_algorithm VARCHAR(50),
    encrypted_NO_KK BYTEA,
    NO_KK_algorithm VARCHAR(50)
)
    RETURNS TABLE (
                      decrypted_NIK TEXT,
                      decrypted_NPWP TEXT,
                      decrypted_alamat TEXT,
                      decrypted_NO_KK TEXT
                  ) AS $$
DECLARE
    sec_key BYTEA := dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/sec.key'));
    password TEXT := 'Ayam1232.!@';
    unicode TEXT := 'UTF8';
BEGIN
    IF NIK_algorithm = 'aes256' THEN
        decrypted_NIK := convert_from(
                pgp_pub_decrypt(encrypted_NIK, sec_key, password),
                unicode
                         );
    ELSIF NIK_algorithm = 'other_algorithm' THEN
    END IF;

    IF NPWP_algorithm = 'aes256' THEN
        decrypted_NPWP := convert_from(
                pgp_pub_decrypt(encrypted_NPWP, sec_key, password),
                unicode
                          );
    ELSIF NPWP_algorithm = 'other_algorithm' THEN
    END IF;

    IF alamat_algorithm = 'aes256' THEN
        decrypted_alamat := convert_from(
                pgp_pub_decrypt(encrypted_alamat, sec_key, password),
                unicode
                            );
    ELSIF alamat_algorithm = 'other_algorithm' THEN
    END IF;

    IF NO_KK_algorithm = 'aes256' THEN
        decrypted_NO_KK := convert_from(
                pgp_pub_decrypt(encrypted_NO_KK, sec_key, password),
                unicode
                           );
    ELSIF NO_KK_algorithm = 'other_algorithm' THEN
    END IF;

    RETURN QUERY
        SELECT decrypted_NIK, decrypted_NPWP, decrypted_alamat, decrypted_NO_KK;
END
$$ LANGUAGE plpgsql;
