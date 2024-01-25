using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FSC.Builder
{
    public class BaseBuilderPage : Outpost.Utils.BaseWebPage
    {
        protected override void OnInit(EventArgs e)
        {
            if (_Development_)
            {
                if (S["Builder.Id"] == null)
                {
                    S["Builder.Id"] = "1";
                    S["Builder.Type"] = "builder";
                }
            }

            base.OnInit(e);

        }

        public override bool IsAuthenticated()
        {
            return (string)S["Builder.Id"] != null;
        }
    }
}