use alerts;

# Load the metrics connection to InfluxDB into the configuration DB

INSERT INTO metricsinfluxdb
       (url, org, token)
   values
       ('http://InfluxDB:8086', 'qumulo', '36r2JNh87NlYYChGdPMikuMEMf7zh5dImkcl-mwMfx0eUwvCs34Vj11y5SctXLvmkZmPGl9R0qvnAQSQxMH-Xw==');


