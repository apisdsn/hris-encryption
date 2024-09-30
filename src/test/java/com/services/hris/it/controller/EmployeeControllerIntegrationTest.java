package com.services.hris.it.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.services.hris.model.EmployeeRequest;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.web.servlet.MockMvc;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class EmployeeControllerIntegrationTest  {
    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    void testInsertBulkEmployeesAndGetAllEmployee() throws Exception {
        String[] fileNames = {
                "1_data.json", "10_data.json", "50_data.json", "100_data.json",
                "150_data.json", "200_data.json", "250_data.json", "300_data.json",
                "350_data.json", "400_data.json", "450_data.json", "500_data.json"
        };

        List<Map<String, Object>> allResults = new ArrayList<>();

        for (String fileName : fileNames) {
            File jsonFile = new File("src/test/resources/" + fileName);
            String jsonData = new String(Files.readAllBytes(Paths.get(jsonFile.toURI())));

            List<EmployeeRequest> employeeRequests = Arrays.asList(objectMapper.readValue(jsonData, EmployeeRequest[].class));
            int jumlahData = employeeRequests.size();
            String algoritma = "aes256";
            String metodeHttpInsert = "insert";
            String metodeHttpGet = "get";
            String metodeEnkripsi = "asymmetric";

            // INSERT
            long startTimeInsert = System.currentTimeMillis();

            for (EmployeeRequest request : employeeRequests) {
                mockMvc.perform(post("/api/employee")
                                .content(objectMapper.writeValueAsString(request))
                                .accept(MediaType.APPLICATION_JSON)
                                .contentType(MediaType.APPLICATION_JSON))
                        .andExpect(status().isCreated());
            }

            long endTimeInsert = System.currentTimeMillis();
            long responseTimeInsert = endTimeInsert - startTimeInsert;

            // GET
            long startTimeGet = System.currentTimeMillis();

            mockMvc.perform(get("/api/employees/all")
                            .accept(MediaType.APPLICATION_JSON)
                            .contentType(MediaType.APPLICATION_JSON))
                    .andExpect(status().isOk());

            long endTimeGet = System.currentTimeMillis();
            long responseTimeGet = endTimeGet - startTimeGet;

            Map<String, Object> combinedResult = new HashMap<>();

            Map<String, Object> resultInsert = new HashMap<>();
            resultInsert.put("jumlah_data", jumlahData);
            resultInsert.put("response_time_insert", responseTimeInsert + " ms");
            resultInsert.put("algoritma", algoritma);
            resultInsert.put("metode_http", metodeHttpInsert);
            resultInsert.put("metode_enkripsi", metodeEnkripsi);

            Map<String, Object> resultGet = new HashMap<>();
            resultGet.put("jumlah_data", jumlahData);
            resultGet.put("response_time_get", responseTimeGet + " ms");
            resultGet.put("algoritma", algoritma);
            resultGet.put("metode_http", metodeHttpGet);
            resultGet.put("metode_enkripsi", metodeEnkripsi);

            combinedResult.put("insert_result", resultInsert);
            combinedResult.put("get_result", resultGet);

            allResults.add(combinedResult);

            jdbcTemplate.execute("TRUNCATE TABLE employee");
        }

        String combinedJsonResult = objectMapper.writeValueAsString(allResults);

        File outputCombinedJsonFile = new File("src/test/resources/combined_response_asym_aes_files.json");
        Files.write(Paths.get(outputCombinedJsonFile.toURI()), combinedJsonResult.getBytes());

        System.out.println(combinedJsonResult);
    }
}