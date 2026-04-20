import fs from 'fs'

const content = fs.readFileSync('.env.local', 'utf-8')
const lines = content.split('\n')
console.log('Keys found in .env.local:')
lines.forEach(line => {
    const parts = line.split('=')
    if (parts.length > 1) {
        console.log(`Key: "${parts[0].trim()}"`)
    }
})
