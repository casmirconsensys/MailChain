import { NextFunction, Request, Response } from 'express';
import mailService from './mail.service';

class MailController {
  public mailService = new mailService();

  public sendMail = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const mailData = req.body;
      const sendMail = await this.mailService.sendMail(req.body);
      res.status(200).json({ data: sendMail, message: 'send' });
    } catch (error) {
      next(error);
    }
  };
}
export default MailController;