import * as dotenv from 'dotenv'
import path from 'path'

console.log('Starting test env script...')
dotenv.config({ path: '.env.local' })

const url = process.env.VITE_SUPABASE_URL
const key = process.env.VITE_SUPABASE_ANON_KEY

console.log('URL:', url ? url.substring(0, 10) + '...' : 'MISSING')
console.log('Key:', key ? key.substring(0, 10) + '...' : 'MISSING')
console.log('Test complete.')
