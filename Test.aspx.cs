using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC
{
    public partial class Test : Outpost.Utils.BaseWebPage   // System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            

            utils.Smtp smtp = new utils.Smtp();
            //smtp.SendMail("dan.vladea@lbsc.eu", "test", "daca primesti acest email ....");
            smtp.SendMail("ilea.sorin@gmail.com", "test", "daca primesti acest email ....");

        }


        public override bool MustBeAuthenticated()
        {
            return false;
        }
    }
}