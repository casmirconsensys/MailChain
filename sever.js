import { Mailchain } from '@mailchain/sdk';

const seed = process.env.SECRET_RECOVERY_PHRASE; // hex encoded seed bytes
const mailchain = Mailchain.fromSecretRecoveryPhrase(secretRecoveryPhrase);

async function mail() {
const user = await mailchain.user();
console.log(`username: ${user.username}, address: ${user.address}`);

const result = await mailchain.send({
    from: 'askcasmir@ens.mailchain.com',
    to: ['0x5C0b2E97109a6aee0F40D63B5d70F6e9DD137240@ethereum.mailchain.com'],
    subject: 'Hello World',
    content: {
        text: 'Hello World',
        html: '<h1>Hello World</h1>',
    },
    })
console.log(result);
}
