
import fs from 'fs';
import csv from 'csv-parser';

const CSV_FILE = 'appscript/khach hang t12.csv';
const SQL_OUTPUT_FILE = 'import_customers_data.sql';

async function importCustomers() {
    const customers: any[] = [];
    const fileStream = fs.createReadStream(CSV_FILE);

    console.log(`Reading CSV from ${CSV_FILE}...`);

    let rowCount = 0;
    fileStream
        .pipe(csv())
        .on('data', (row) => {
            rowCount++;
            // Clean Keys (handle BOM)
            const cleanRow: any = {};
            Object.keys(row).forEach(key => {
                cleanRow[key.trim().replace(/^\ufeff/, '')] = row[key];
            });

            // Map CSV columns
            const code = cleanRow['MÃ KH']?.trim();
            const name = cleanRow['Tên KH']?.trim();

            if (code && name) {
                customers.push({
                    code: code,
                    name: name,
                    phone: cleanRow['SĐT']?.trim() || null,
                    address: cleanRow['Địa chỉ']?.trim() || null,
                    email: cleanRow['Email']?.trim() || null,
                    crm_notes: cleanRow['GhiChuCRM']?.trim() || null,
                });
            }
        })
        .on('end', async () => {
            console.log(`Read ${customers.length} customers. Generating SQL...`);

            const ws = fs.createWriteStream(SQL_OUTPUT_FILE);
            ws.write(`-- Import Customers Data via Bulk Insert\n`);

            customers.forEach(c => {
                const escape = (str: string | null) => str ? `'${str.replace(/'/g, "''")}'` : 'NULL';

                const codeVal = escape(c.code);
                const nameVal = escape(c.name);
                const phoneVal = escape(c.phone);
                const addrVal = escape(c.address);
                const emailVal = escape(c.email);
                const notesVal = escape(c.crm_notes);

                // Use ON CONFLICT to update existing customers
                const sql = `
INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES (${codeVal}, ${nameVal}, ${phoneVal}, ${addrVal}, ${emailVal}, ${notesVal}, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();
`;
                ws.write(sql);
            });

            ws.end();
            console.log(`Generated SQL file: ${SQL_OUTPUT_FILE}`);
        });
}

importCustomers();
