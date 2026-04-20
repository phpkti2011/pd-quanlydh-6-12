const fs = require('fs');
const path = require('path');

const version = {
    timestamp: Date.now()
};

// 1. Write to public/version.json (Server-side reference)
const publicDir = path.join(__dirname, '../public');
if (!fs.existsSync(publicDir)) {
    fs.mkdirSync(publicDir, { recursive: true });
}
fs.writeFileSync(
    path.join(publicDir, 'version.json'),
    JSON.stringify(version, null, 2)
);

// 2. Write to src/version.ts (Client-side reference)
const srcDir = path.join(__dirname, '../src');
if (!fs.existsSync(srcDir)) {
    fs.mkdirSync(srcDir, { recursive: true });
}
const content = `export const APP_VERSION = ${JSON.stringify(version)};`;
fs.writeFileSync(
    path.join(srcDir, 'version.ts'),
    content
);

console.log('✅ Version updated to:', version.timestamp);
