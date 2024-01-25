using System;
using System.Collections.Generic;

using System.Data;
using System.Configuration;
using System.Web;
using System.Net.Mail;
using System.Net.Mime;

using System.IO;

using System.Text.RegularExpressions;
using System.Net;

namespace FSC.utils
{
    /// <summary>
    /// Handle the SMTP service. Send emails.
    /// If this module will become bigger it will be moved in a different assembly.
    /// </summary>
    public class Smtp //: IDisposable
    {
        public Smtp()
        {
        }

        private string GetSetting(string key)
        {
            string k = key;
            string ret = System.Configuration.ConfigurationManager.AppSettings[k];
            return ret;
        }

        private string Server
        {
            get { return GetSetting("Mail.Server"); }
        }

        private string From
        {
            get { return GetSetting("Mail.From"); }
        }

        private string ReplyTo
        {
            get { return GetSetting("Mail.ReplyTo"); }
        }

        private string Port
        {
            get { return GetSetting("Mail.Port"); }
        }

        private string AuthenticationType
        {
            get { return GetSetting("Mail.Authentication"); }
        }

        private string Domain
        {
            get { return GetSetting("Mail.Domain"); }
        }

        private string Username
        {
            get { return GetSetting("Mail.User"); }
        }

        private string Password
        {
            get { return GetSetting("Mail.Pass"); }
        }

        string _bcc = null;
        public string Bcc
        {
            get
            {
                string bcc = _bcc;
                if(bcc == null)
                    bcc = GetSetting("Mail.BccEmail");
                return bcc;
            }
            set
            {
                _bcc = value;
            }
        }

        public void SendMail(string to, string subject, string body)
        {
            string bcc = Bcc;
            SendMail(to, bcc, subject, body, null);
        }

        public void SendMail(string to, string subject, string body, System.Collections.ArrayList attachments)
        {
            string bcc = Bcc;
            SendMail(to, bcc, subject, body, attachments);
        }

        public void SendMail(string to, string bcc, string subject, string body, System.Collections.ArrayList attachments)
        {
            if (System.Configuration.ConfigurationManager.AppSettings["local"] == "true")
            {
                subject = "[Debug] - [" + to + "] - " + subject;

                bcc = null;
                to = "ilea.sorin@gmail.com";
            }

            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

            try
            {
                string[] to_addr = to.Split(';');
                using (MailMessage msg = new MailMessage(From, to_addr[0], subject, body))
                {
                    // create a client with default port
                    using (SmtpClient client = new SmtpClient(Server))
                    {
                        // create a client with a given port
                        if (Port != "")
                            client.Port = Convert.ToInt16(Port);

                        for (int i = 1; i < to_addr.Length; i++)
                        {
                            string email = to_addr[i].Trim();
                            if (IsValidEmailAddress(email))
                                msg.To.Add(email);
                        }
                        if (bcc != null && bcc != "")
                        {
                            string[] bcc_addr = bcc.Split(';');
                            for (int i = 0; i < bcc_addr.Length; i++)
                            {
                                if (bcc_addr[i].Length > 0)
                                    msg.Bcc.Add(bcc_addr[i]);
                            }
                        }

                        string auth_type = AuthenticationType;

                        switch (auth_type)
                        {
                            case "None":
                                break;
                            case "Basic":
                                client.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
                                client.UseDefaultCredentials = false;
                                if (Domain != "")
                                    client.Credentials = new System.Net.NetworkCredential(Username, Password, Domain);
                                else
                                    client.Credentials = new System.Net.NetworkCredential(Username, Password);
                                break;
                            case "SSL":
                                client.EnableSsl = true;
                                client.UseDefaultCredentials = false;
                                client.Credentials = new System.Net.NetworkCredential(Username, Password);
                                break;
                            case "TLS-1":
                                client.EnableSsl = true;
                                client.Credentials = new System.Net.NetworkCredential(Username, Password, Domain);
                                break;
                            case "TLS-2":
                                client.EnableSsl = true;
                                client.UseDefaultCredentials = false;
                                client.Credentials = new System.Net.NetworkCredential(Username, Password, Domain);
                                break;
                            case "TLS-3":
                                client.EnableSsl = true;
                                client.Credentials = new System.Net.NetworkCredential(Username, Password, Domain);
                                client.UseDefaultCredentials = false;
                                break;
                        }
                        if (ReplyTo != "")
                            msg.ReplyToList.Add(new MailAddress(ReplyTo));
                        else
                            msg.ReplyToList.Add(new MailAddress(to_addr[0]));

                        if (attachments != null)
                        {
                            foreach (AttachmentStructure att in attachments)
                            {
                                if (att.Attachment is System.IO.Stream)
                                {
                                    LinkedResource logo = new LinkedResource((System.IO.Stream)att.Attachment, new ContentType("image/png"));
                                    logo.ContentId = "barcode";
                                    AlternateView av1 = AlternateView.CreateAlternateViewFromString(body, null, MediaTypeNames.Text.Html);
                                    av1.LinkedResources.Add(logo);
                                    msg.AlternateViews.Add(av1);
                                }
                                if (att.Attachment is byte[])
                                {
                                    MemoryStream stream = new MemoryStream((byte[])att.Attachment);
                                    Attachment attachment = new Attachment(stream, att.ContentId);
                                    attachment.ContentType = new ContentType(att.ContentType);
                                    msg.Attachments.Add(attachment);
                                }
                            }
                        }

                        msg.IsBodyHtml = true;

                        client.Send(msg);
                        System.Threading.Thread.Sleep(100);
                    }                        
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private bool IsValidEmailAddress(string EmailAddress)
        {
            return Regex.IsMatch(EmailAddress,
              @"^(?("")(""[^""]+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))" +
              @"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$");
        }

        public class AttachmentStructure
        {
            public object Attachment;
            public string ContentId;
            public string ContentType;
        }
    }
}
