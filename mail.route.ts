import { Router } from 'express';
import { Routes } from '../interfaces/routes.interface';
import MailController from './mail.controller';
import passport from 'passport';

class AuthenticatedMailRoute implements Routes {
    public router = Router();
    private readonly _mailController: MailController();

    constructor() {
        this._mailController = new MailController();
        this.initializeRoutes();
    }

    private initializeRoutes() {
        this.router.post('/send', 
        passport.authenticate('bearer', { session: false }),
        this._mailController.sendMail);
    }
}

export default AuthenticatedMailRoute;
