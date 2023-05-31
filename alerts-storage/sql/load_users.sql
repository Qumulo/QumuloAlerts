use alerts;

# admin user MUST be defined in a new system

insert into users
       (full_name, username, hashed_password, disabled, protected)
   values
       ('Administrator', 'admin', '$2b$12$w8DGRtBb4MvABjrx3tLMBeTBub7ftLK.hj8lAUQgh/Zm0UNHrWUbG', False, true);
