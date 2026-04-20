import fs from 'fs';
import path from 'path';

const logoPath = path.join(process.cwd(), 'public', 'logo.png');
const logoBuffer = fs.readFileSync(logoPath);
const base64Logo = logoBuffer.toString('base64');
const dataUrl = `data:image/png;base64,${base64Logo}`;

// Write to a TypeScript file
const outputPath = path.join(process.cwd(), 'utils', 'logoBase64.ts');
const content = `// Auto-generated logo base64
export const LOGO_BASE64 = '${dataUrl}';
`;

fs.writeFileSync(outputPath, content);
console.log('✅ Logo converted to base64 and saved to utils/logoBase64.ts');
console.log(`📦 Size: ${(base64Logo.length / 1024).toFixed(2)} KB`);
