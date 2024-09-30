CREATE TABLE users(
                      user_id serial PRIMARY KEY,
                      username VARCHAR(50) UNIQUE NOT NULL,
                      email bytea
);

CREATE EXTENSION pgcrypto;

INSERT INTO users (username, email)
VALUES
    (
        'john doe',
        pgp_pub_encrypt (
                'johndoe166@gmail.com',
                dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/pub.key')),
                'compress-algo=0, cipher-algo=bf'
        )
    );


SELECT username,
       pgp_pub_decrypt(email, dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/sec.key')), 'Ayam1232.!@') AS decrypted_email
FROM users;

-- FUNCTION TRIGGER ENCRYPTION
CREATE OR REPLACE FUNCTION encrypt_data(email TEXT)
    RETURNS BYTEA AS $$
BEGIN
    RETURN pgp_pub_encrypt(
            email,
            dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/pub.key')),
            'compress-algo=0, cipher-algo=bf'
           );
END
$$ LANGUAGE plpgsql;

-- FUNCTION TRIGGER ENCRYPTION
CREATE OR REPLACE FUNCTION trigger_encrypt_data()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.email := pgp_pub_encrypt(
            NEW.email::TEXT,
            dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/pub.key')),
            'compress-algo=0, cipher-algo=aes256, unicode-mode=1'
                        );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- CREATE TRIGGER ENCRYPTION BEFORE INSERT OR UPDATE
CREATE TRIGGER before_insert_update_encrypt
    BEFORE INSERT OR UPDATE ON users
    FOR EACH ROW
EXECUTE FUNCTION trigger_encrypt_data();

-- CREATE FUNCTION DECRYPTION
CREATE OR REPLACE FUNCTION decrypt_email(encrypted_email bytea)
    RETURNS TEXT AS $$
BEGIN
    RETURN convert_from(pgp_pub_decrypt(encrypted_email, dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/sec.key')),'Ayam1232.!@')::BYTEA, 'UTF8');
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION decrypt_email(encrypted_email bytea)
    RETURNS TEXT AS $$
BEGIN
    RETURN convert_from(pgp_pub_decrypt(encrypted_email, dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/sec.key')),'Ayam1232.!@'), 'UTF8');
END;
$$ LANGUAGE plpgsql;

-- FUNCTION TRIGGER DECRYPTION
CREATE OR REPLACE FUNCTION decrypt_data()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.email := decrypt_email(NEW.email);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER AFTER INSERT OR UPDATE
CREATE TRIGGER trigger_decrypt_data
    AFTER INSERT OR UPDATE ON users
    FOR EACH ROW
EXECUTE FUNCTION decrypt_data();

SELECT username, convert_from(decrypt_email(email)::bytea, 'UTF8') AS decrypt_email FROM users;

SELECT username, decrypt_email(email) AS decrypt_email FROM users;

INSERT INTO users (username, email) VALUES ('dadang', encrypt_data('dadangwijaya166@gmail.com'));

INSERT INTO users (username, email) VALUES ('apis', 'hafizadha166@gmail.com');

DROP TRIGGER before_insert_update_encrypt ON users;

DROP TRIGGER trigger_decrypt_data ON users;

DELETE FROM users WHERE username = 'apis';

SELECT * FROM pg_extension;

SELECT * FROM users;

SELECT pgp_pub_decrypt(email, dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/sec.key')), 'Ayam1232.!@') AS decrypted_email
FROM users
WHERE username = 'dadang';


CREATE TABLE Employee (
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

-- FUNCTION TRIGGER ENCRYPTION EMPLOYEE ALGORITHM BLOWFISH
CREATE OR REPLACE FUNCTION encrypt_data_table_employee_algo_bf()
    RETURNS TRIGGER AS $$
DECLARE
    pub_key BYTEA := dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/pub.key'));
    options TEXT := 'compress-algo=0, cipher-algo=bf';
BEGIN
    NEW.NIK := pgp_pub_encrypt(NEW.NIK::TEXT, pub_key, options);
    NEW.NPWP := pgp_pub_encrypt(NEW.NPWP::TEXT, pub_key, options);
    NEW.alamat := pgp_pub_encrypt(NEW.alamat::TEXT, pub_key, options);
    NEW.NO_KK := pgp_pub_encrypt(NEW.NO_KK::TEXT, pub_key, options);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- CREATE TRIGGER ENCRYPTION BEFORE INSERT OR UPDATE FOR TABLE EMPLOYEE ALGORITHM BLOWFISH
CREATE TRIGGER trigger_encrypt_data_employee_algo_bf
    BEFORE INSERT OR UPDATE ON Employee
    FOR EACH ROW
EXECUTE FUNCTION encrypt_data_table_employee_algo_bf();

-- FUNCTION TRIGGER ENCRYPTION EMPLOYEE ALGORITHM AES256
CREATE OR REPLACE FUNCTION encrypt_data_table_employee_algo_aes256()
    RETURNS TRIGGER AS $$
DECLARE
    pub_key BYTEA := dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/pub.key'));
    options TEXT := 'compress-algo=0, cipher-algo=aes256, unicode-mode=1';
BEGIN
    NEW.NIK := pgp_pub_encrypt(NEW.NIK::TEXT, pub_key, options);
    NEW.NPWP := pgp_pub_encrypt(NEW.NPWP::TEXT, pub_key, options);
    NEW.alamat := pgp_pub_encrypt(NEW.alamat::TEXT, pub_key, options);
    NEW.NO_KK := pgp_pub_encrypt(NEW.NO_KK::TEXT, pub_key, options);

    RETURN NEW;
END
$$ LANGUAGE plpgsql;


-- CREATE TRIGGER ENCRYPTION BEFORE INSERT OR UPDATE FOR TABLE EMPLOYEE
CREATE TRIGGER trigger_encrypt_data_employee_algo_aes256
    BEFORE INSERT OR UPDATE ON Employee
    FOR EACH ROW
EXECUTE FUNCTION encrypt_data_table_employee_algo_aes256();

--INSERT MOCK DATA TO TABLE EMPLOYEE
INSERT INTO Employee (id, id_workspaces, id_karir, name, gender, start_work, NIP, NIK, NPWP, alamat, NO_KK, grup, id_atasan, resign_date, isDeleted, created_at, updated_at, deleted_at)
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

SELECT * FROM Employee;

DELETE FROM Employee WHERE name = 'Andi Saputra';

DROP TRIGGER trigger_encrypt_data_employee_algo_bf ON Employee;

DROP TRIGGER trigger_encrypt_data_employee_algo_aes256 ON Employee;

-- FUNCTION DECRYPTION EMPLOYEE FOR ALGORITHM BLOWFISH
CREATE OR REPLACE FUNCTION decrypt_employee_data_algo_bf(
    encrypted_NIK BYTEA,
    encrypted_NPWP BYTEA,
    encrypted_alamat BYTEA,
    encrypted_NO_KK BYTEA
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
    decrypted_NIK := convert_from(pgp_pub_decrypt(encrypted_NIK, sec_key, password)::BYTEA, unicode);
    decrypted_NPWP := convert_from(pgp_pub_decrypt(encrypted_NPWP, sec_key, password)::BYTEA, unicode);
    decrypted_alamat := convert_from(pgp_pub_decrypt(encrypted_alamat, sec_key, password)::BYTEA, unicode);
    decrypted_NO_KK := convert_from(pgp_pub_decrypt(encrypted_NO_KK, sec_key, password)::BYTEA, unicode);

    RETURN QUERY SELECT decrypted_NIK, decrypted_NPWP, decrypted_alamat, decrypted_NO_KK;
END
$$ LANGUAGE plpgsql;

-- FUNCTION DECRYPTION EMPLOYEE FOR ALGORITHM AES256
CREATE OR REPLACE FUNCTION decrypt_employee_data_algo_aes256(
    encrypted_NIK BYTEA,
    encrypted_NPWP BYTEA,
    encrypted_alamat BYTEA,
    encrypted_NO_KK BYTEA
)
    RETURNS TABLE (
                      decrypted_NIK TEXT,
                      decrypted_NPWP TEXT,
                      decrypted_alamat TEXT,
                      decrypted_NO_KK TEXT,

                      encode_NIK TEXT,
                      encode_NPWP TEXT,
                      encode_alamat TEXT,
                      encode_NO_KK TEXT
                  ) AS $$
DECLARE
    sec_key BYTEA := dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/sec.key'));
    password TEXT := 'Ayam1232.!@';
    unicode TEXT := 'UTF8';
BEGIN
    encode_NIK := encode(pgp_pub_decrypt(encrypted_NIK, sec_key, password)::BYTEA, 'hex');
    encode_NPWP := encode(pgp_pub_decrypt(encrypted_NPWP, sec_key, password)::BYTEA, 'hex');
    encode_alamat := encode(pgp_pub_decrypt(encrypted_alamat, sec_key, password)::BYTEA, 'hex');
    encode_NO_KK := encode(pgp_pub_decrypt(encrypted_NO_KK, sec_key, password)::BYTEA, 'hex');

    decrypted_NIK := convert_from(pgp_pub_decrypt(decode(encode_NIK, 'hex'), sec_key, password)::BYTEA, unicode);
    decrypted_NPWP := convert_from(pgp_pub_decrypt(decode(encode_NPWP, 'hex'), sec_key, password)::BYTEA, unicode);
    decrypted_alamat := convert_from(pgp_pub_decrypt(decode(encode_alamat, 'hex'), sec_key, password)::BYTEA, unicode);
    decrypted_NO_KK := convert_from(pgp_pub_decrypt(decode(encode_NO_KK, 'hex'), sec_key, password)::BYTEA, unicode);

    RETURN QUERY SELECT decrypted_NIK, decrypted_NPWP, decrypted_alamat, decrypted_NO_KK,
                        encode_NIK, encode_NPWP, encode_alamat, encode_NO_KK;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION decrypt_employee_data_algo_aes256_new(
    encrypted_NIK BYTEA,
    encrypted_NPWP BYTEA,
    encrypted_alamat BYTEA,
    encrypted_NO_KK BYTEA
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
BEGIN
    decrypted_NIK := convert_from(
            pgp_pub_decrypt(
                    decode(encode(pgp_pub_decrypt(encrypted_NIK, sec_key, password)::BYTEA, 'hex'), 'hex'),
                    sec_key,
                    'Ayam1232.!@'
            )::BYTEA,
            'UTF8'
                     );

    decrypted_NPWP := convert_from(
            pgp_pub_decrypt(
                    decode(encode(pgp_pub_decrypt(encrypted_NPWP, sec_key, password)::BYTEA, 'hex'), 'hex'),
                    sec_key,
                    'Ayam1232.!@'
            )::BYTEA,
            'UTF8'
                      );
    decrypted_alamat := convert_from(
            pgp_pub_decrypt(
                    decode(encode(pgp_pub_decrypt(encrypted_alamat, sec_key, password)::BYTEA, 'hex'), 'hex'),
                    sec_key,
                    'Ayam1232.!@'
            )::BYTEA,
            'UTF8'
                        );
    decrypted_NO_KK := convert_from(
            pgp_pub_decrypt(
                    decode(encode(pgp_pub_decrypt(encrypted_NO_KK, sec_key, password)::BYTEA, 'hex'), 'hex'),
                    sec_key,
                    'Ayam1232.!@'
            )::BYTEA,
            'UTF8'
                       );

    RETURN QUERY SELECT decrypted_NIK, decrypted_NPWP, decrypted_alamat, decrypted_NO_KK;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION decrypt_employee_data_algo_aes256_new(
    encrypted_NIK BYTEA,
    encrypted_NPWP BYTEA,
    encrypted_alamat BYTEA,
    encrypted_NO_KK BYTEA
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
BEGIN
    -- Decrypt each field directly from the encrypted BYTEA data
    decrypted_NIK := convert_from(pgp_pub_decrypt(encrypted_NIK, sec_key, password)::BYTEA, 'UTF8');
    decrypted_NPWP := convert_from(pgp_pub_decrypt(encrypted_NPWP, sec_key, password)::BYTEA, 'UTF8');
    decrypted_alamat := convert_from(pgp_pub_decrypt(encrypted_alamat, sec_key, password)::BYTEA, 'UTF8');
    decrypted_NO_KK := convert_from(pgp_pub_decrypt(encrypted_NO_KK, sec_key, password)::BYTEA, 'UTF8');

    -- Replace null characters from the decrypted result using CHR(0)
    decrypted_NIK := regexp_replace(decrypted_NIK, '\x00', '', 'g');
    decrypted_NPWP := regexp_replace(decrypted_NPWP, '\x00', '', 'g');
    decrypted_alamat := regexp_replace(decrypted_alamat, '\x00', '', 'g');
    decrypted_NO_KK := regexp_replace(decrypted_NO_KK, '\x00', '', 'g');

    RETURN QUERY SELECT decrypted_NIK, decrypted_NPWP, decrypted_alamat, decrypted_NO_KK;
END
$$ LANGUAGE plpgsql;



DROP FUNCTION decrypt_employee_data_algo_bf;

DROP FUNCTION decrypt_employee_data_algo_aes256;

DROP FUNCTION decrypt_employee_data_algo_aes256_new;

SELECT
    id,
    id_workspaces,
    id_karir,
    name,
    gender,
    start_work,
    NIP,
    d.decrypted_NIK,
    d.decrypted_NPWP,
    d.decrypted_alamat,
    d.decrypted_NO_KK,
    grup,
    id_atasan,
    resign_date,
    isDeleted,
    created_at,
    updated_at,
    deleted_at
FROM
    Employee e,
    LATERAL decrypt_employee_data_algo_aes256_new(e.NIK, e.NPWP, e.alamat, e.NO_KK) AS d(decrypted_NIK, decrypted_NPWP, decrypted_alamat, decrypted_NO_KK);

SELECT
    id,
    id_workspaces,
    id_karir,
    name,
    gender,
    start_work,
    NIP,
    pgp_pub_decrypt(NIK, dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/sec.key')), 'Ayam1232.!@'),
    pgp_pub_decrypt(NPWP, dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/sec.key')), 'Ayam1232.!@'),
    pgp_pub_decrypt(alamat, dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/sec.key')), 'Ayam1232.!@'),
    pgp_pub_decrypt(NO_KK, dearmor(pg_read_file('/Library/PostgreSQL/16/data/keys/sec.key')), 'Ayam1232.!@'),
    grup,
    id_atasan,
    resign_date,
    isDeleted,
    created_at,
    updated_at,
    deleted_at
FROM
    Employee ;
