CREATE TABLE articoli (
    codice VARCHAR(10) PRIMARY KEY ,
    descrizione VARCHAR(100) ,
    prezzoUnitario DECIMAL(10,2)
);

CREATE TABLE clienti (
    codice VARCHAR(10) PRIMARY KEY,
    Nome VARCHAR(100) ,
    Indirizzo VARCHAR(150) ,
    citta VARCHAR(100) ,
    provincia CHAR(2) ,
    codfiscale CHAR(16) ,
    piva CHAR(11)
);

CREATE TABLE Fatture (
    numeroFattura INT PRIMARY KEY,
    cliente VARCHAR(10), 
    data DATE ,
    pagata BOOLEAN,
    FOREIGN KEY (cliente)REFERENCES clienti(codice)
);

CREATE TABLE RigheFatture (
    numeroFattura INT ,
    articolo VARCHAR(10) ,
    quantita INT ,
    prezzoUnitario DECIMAL(10,2),
    PRIMARY KEY(numeroFattura, articolo, quantita),
    FOREIGN KEY(articolo) REFERENCES articoli(codice),
    FOREIGN KEY(numeroFattura) REFERENCES Fatture(numeroFattura)
);

INSERT INTO articoli (codice, descrizione, prezzoUnitario) VALUES
('A001', 'Mouse ottico USB', 12.90),
('A002', 'Tastiera meccanica', 59.99),
('A003', 'Monitor 24 pollici LED', 149.50),
('A004', 'Hard Disk esterno 1TB', 74.00),
('A005', 'Chiavetta USB 64GB', 18.75),
('A006', 'Webcam HD 1080p', 39.90),
('A007', 'Cuffie wireless Bluetooth', 89.99);

INSERT INTO clienti (codice, Nome, Indirizzo, citta, provincia, codfiscale, piva) VALUES
('C001', 'Mario Rossi', 'Via Roma 10', 'Milano', 'MI', 'RSSMRA80A01F205X', '12345678901'),
('C002', 'Luca Bianchi', 'Corso Italia 25', 'Verona', 'VR', 'BNCLCU85B12L219Z', '23456789012'),
('C003', 'Giulia Verdi', 'Via Garibaldi 7', 'Bologna', 'BO', 'VRDGLI90C45A944K', '34567890123'),
('C004', 'Anna Neri', 'Via Dante 18', 'Firenze', 'FI', 'NREANN88D50D612W', '45678901234'),
('C005', 'Paolo Galli', 'Piazza Duomo 3', 'Verona', 'VR', 'GLLPLA82E22F839T', '56789012345'),
('C006', 'Francesca Conti', 'Via Mazzini 44', 'Genova', 'GE', '67890123456', '67890123456'),
('C007', 'Marco Ricci', 'Viale Europa 12', 'Roma', 'RM', 'RCCMRC87G15H501Y', '78901234567');

INSERT INTO Fatture (numeroFattura, cliente, data, pagata) VALUES
(1001, 'C001', '2025-10-10', TRUE),
(1002, 'C003', '2025-12-15', FALSE),
(1003, 'C005', '2025-12-01', TRUE),
(1004, 'C002', '2026-02-05', FALSE),
(1005, 'C007', '2026-02-12', TRUE);

INSERT INTO RigheFatture (numeroFattura, articolo, quantita, prezzoUnitario) VALUES
(1001, 'A001', 2, 12.90),
(1001, 'A005', 1, 18.75),
(1002, 'A003', 1, 149.50),
(1002, 'A006', 2, 39.90),
(1003, 'A004', 1, 74.00),
(1004, 'A002', 1, 59.99),
(1004, 'A007', 1, 89.99),
(1005, 'A001', 3, 12.90),
(1005, 'A006', 1, 39.90);
-- Elencare gli articoli venduti nella fattura 1002
SELECT a.codice , a.descrizione, a.prezzoUnitario
FROM articoli a
JOIN righefatture r ON a.codice = r.articolo
WHERE r.numeroFattura = 1002;

-- Elencare le fatture non pagate del cliente Rossi
SELECT f.numeroFattura, f.cliente, f.data, f.pagata
FROM fatture f
JOIN clienti c ON f.cliente = c.codice
WHERE nome="Rossi" AND !pagata;

-- Fornire gli articoli dei clienti che abitano a Verona
SELECT a.codice, a.descrizione, a.prezzoUnitario
FROM articoli a
JOIN righefatture r ON a.codice = r.articolo
JOIN fatture f ON r.numeroFattura = f.numeroFattura
JOIN clienti c ON f.cliente = c.codice
WHERE c.provincia = "VR";

-- Di ciascun articolo fornire il numero e data delle sue fatture
SELECT f.numeroFattura, f.data
FROM fatture f
JOIN righefatture r ON f.numeroFattura = r.numeroFattura
JOIN articoli a ON a.codice = r.articolo
ORDER BY a.codice;

-- Indicare quali sono le fatture non pagate con Importo di riga (prezzo * Qtà) superiore a 200€
SELECT f.numeroFattura
FROM fatture f
JOIN righefatture r ON f.numeroFattura = r.numeroFattura
WHERE r.prezzoUnitario * r.quantita > 200 AND !f.pagata;

-- Indicare gli articoli venduti lo scorso anno per un importo (prezzo * Qtà) dai 100€ ai 300€ a Verona
SELECT a.codice, a.descrizione, a.prezzoUnitario
FROM articoli a
JOIN righefatture r ON a.codice = r.articolo
JOIN fatture f ON r.numeroFattura = f.numeroFattura
JOIN clienti c ON f.cliente = c.codice
WHERE ((YEAR(CURRENT_DATE) - year(data)) = 1 )AND (r.prezzoUnitario * r.quantita BETWEEN 100 AND 300) AND (c.provincia = "VR");

-- Fornire le fatture pagate dai clienti di Milano negli ultimi 3 anni
SELECT f.numeroFattura, f.cliente, f.data
FROM fatture f
JOIN clienti c ON f.cliente = c.codice
WHERE pagata AND c.provincia = "MI" AND year (CURRENT_DATE) - year(f.data) BETWEEN 1 AND 3;