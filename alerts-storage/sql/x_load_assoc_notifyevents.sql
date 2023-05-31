use alerts;

# Pre-populate the Associative NotifyEvents table

# Build for the "NotifyAll" group

insert into assoc_notifyevents(group_id, event_id)
       select r.id as group_id, p.id as event_id
       from notifygroup r
       inner join notifyevents p
       where r.name = "NotifyAll";

