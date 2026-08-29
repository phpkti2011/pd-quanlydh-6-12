import dotenv from 'dotenv';
dotenv.config({ path: '.env.local' });

const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || '';
const TELEGRAM_CHAT_ID = process.env.TELEGRAM_CHAT_ID || '';

async function main() {
  if (!TELEGRAM_BOT_TOKEN || !TELEGRAM_CHAT_ID) {
    console.error('Missing TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID in .env.local');
    process.exit(1);
  }

  const pingId = Math.random().toString(36).slice(2, 8).toUpperCase();
  const now = new Date().toLocaleString('vi-VN', { timeZone: 'Asia/Ho_Chi_Minh' });
  const tokenTail = TELEGRAM_BOT_TOKEN.slice(-6);

  const text = [
    `PING #${pingId}`,
    `Thoi gian: ${now}`,
    `Bot token ...${tokenTail}`,
    `Chat ID: ${TELEGRAM_CHAT_ID}`,
    `Source: local test_ping_telegram.ts`,
  ].join('\n');

  console.log('--- Sending ---');
  console.log(text);
  console.log('---------------');

  const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ chat_id: TELEGRAM_CHAT_ID, text }),
  });

  const body = await res.text();
  console.log('Status:', res.status);
  console.log('Body:', body);

  console.log('\nKiem tra Telegram:');
  console.log(`- Neu nhan dung 1 tin "PING #${pingId}" -> code/chat OK, van de nam o cron production.`);
  console.log('- Neu nhan 2 tin cung PING ID -> bot/chat dang bi forward (re-check chat setup).');
}

main().catch(e => { console.error(e); process.exit(1); });
