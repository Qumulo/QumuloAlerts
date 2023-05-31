use alerts;

# Default NotifyGroup

insert into notifygroup
       (name, description, protected)
   values
       ('NotifyAll', 'Access to all Alarms, Alerts, and Informational', True);
