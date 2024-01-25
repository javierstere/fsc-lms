<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="FSC._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>Food safety training & consulting</h1>
        <p class="lead">
            BD Food Safety Consultants offers Basic Food Safety training for food manufacturing employees.

            Our training consists of interactive food safety online courses that meet requirements for workforce training as outlined in the Food Safety Modernization Act and the Global Food Safety Initiative.
        </p>
        <p><a href="/Contact.aspx" class="btn btn-primary btn-lg">Learn more &raquo;</a></p>
    </div>

    <div class="row">
        <div class="col-md-4">
            <img src="/Resources/doceo01.jpg" />
            <h2>Module</h2>
            <p>
                The modules cover the following: FSMA & HACCP overview, Food Defense, Allergen Management, GMPs and GFSI / SQF Overview . Each training course lasts approximately 15 minutes and has assigned verification quiz.
            </p>
            <p>
                <a class="btn btn-default" href="/Contact.aspx">Learn more &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <img src="/Resources/doceo03.jpg" />
            <h2>LMS</h2>
            <p>
                By utilizing our LMS (Learning Management System), your company will significantly improve the effectiveness of employee training and will be provided with convenient reporting to keep you audit ready. Employees can take this training in time convenient for them simply by using an electronic device such as a tablet, smartphone or computer.
            </p>
            <p>
                <a class="btn btn-default" href="/Contact.aspx">Learn more &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <img src="/Resources/doceo02.jpg" />
            <h2>Goal</h2>
            <p>
                Our goal is to provide with innovative employee training solutions at a reasonable price.
            </p>
            <p>
                <a class="btn btn-default" href="/Contact.aspx">Learn more &raquo;</a>
            </p>
        </div>
    </div>

</asp:Content>
