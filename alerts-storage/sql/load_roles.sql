use alerts;

# Default Roles

insert into roles
       (name, description, protected)
   values
       ('Administrators', 'Full access and control of Qumulo Alerts', True),
       ('Observers', 'Access to all Alarms, Alerts, and Informational', True);
