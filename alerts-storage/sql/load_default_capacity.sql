use alerts;

# Load the default capacity thresholds

insert into capacity
       (critical, error, warning)
   values
       (98, 90, 85);
