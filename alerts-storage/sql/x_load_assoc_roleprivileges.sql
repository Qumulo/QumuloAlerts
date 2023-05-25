use alerts;

# Pre-populate the Associative Roleprivileges table

# Build for the "Administrators" role

insert into assoc_roleprivileges(roles_id, privilege_id)
       select r.id as roles_id, p.id as privilege_id
       from roles r
       inner join roleprivileges p
       where r.name = "Administrators";

# Build for the "Observers" role

insert into assoc_roleprivileges(roles_id, privilege_id)
       select r.id as roles_id, p.id as privilege_id
       from roles r
       inner join roleprivileges p
       where r.name = "Observers" and p.name like '%READ%';

