import { Router } from 'express';
import { Routes } from '../interfaces/routes.interface';
import MailController from './mail.controller';

class MailRoute implements Routes {
    public router = Router();
    private readonly _mailController: MailController();

    constructor() {
        this._mailController = new MailController();
        this.initializeRoutes();
    }

    private initializeRoutes() {
        this.router.post('/send', this._mailController.sendMail);
    }
}

export default MailRoute;
