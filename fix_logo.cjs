
const fs = require('fs');
try {
    const b64 = fs.readFileSync('temp_logo_base64.txt', 'utf8').trim();
    // Ensure no BOM in the input if possible, though readFileSync utf8 handles BOM often.
    // We construct the file manually.
    const content = `export const LOGO_BASE64 = "data:image/png;base64,${b64}";\n`;
    fs.writeFileSync('utils/logoData.ts', content, 'utf8');
    console.log('Successfully rewrote utils/logoData.ts with UTF-8');
} catch (e) {
    console.error('Error fixing logoData:', e);
    process.exit(1);
}
