CREATE table if NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

INSERT INTO users (username,email) values
('jonh_dees', 'jon@example.com'),
('arrya_dees', 'arya@example.com'),
('bran_dees', 'bran@example.com');

SELECT * from users;

SELECT * from employees LIMIT 5;