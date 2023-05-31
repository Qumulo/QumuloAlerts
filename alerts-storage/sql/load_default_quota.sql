use alerts;

# Load the default quota thresholds

insert into defaultquota
       (quota_prefix, critical, error, warning)
   values
       ('', 95, 85, 75);
