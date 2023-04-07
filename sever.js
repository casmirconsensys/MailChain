import { Mailchain } from '@mailchain/sdk';
import App from '@/app';
import IndexRoute from '@/routes/index.route';
import MailRoute from '@/routes/mail.route';

const app = new App([new IndexRoute(), new AuthenticatedMailRoute()]);
app.listen();


const secretRecoveryPhrase = process.env.SECRET_RECOVERY_PHRASE; 
const mailchain = Mailchain.fromSecretRecoveryPhrase(secretRecoveryPhrase);
//SEDD
cont seed = mailchain.env.SEED!; // hex encoded seed bytes
const mailchain = Mailchain.fromAccountSeed(seed);

// Path: mailchain/sever.js
async function mail() {
    //Verify the user
const user = await mailchain.user();
console.log(`username: ${user.username}, address: ${user.address}`);

//The code below sends a mail.
const {data, error } = await mailchain.sendMail({
    from: 'askcasmir@ens.mailchain.com',
    to: ['0x5C0b2E97109a6aee0F40D63B5d70F6e9DD137240@ethereum.mailchain.com'],
    subject: 'Hello Mailchain',
    content: {
        text: 'Hello Mailchain',
        html: '<h1>Hello Mailchain</h1>',
    },
    });
    if (error) {
        // Handle error
        console.error('Mailchain error', error);
        return;
    }
    // Handle success
console.log(data);
}


    
