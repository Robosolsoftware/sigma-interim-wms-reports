report 50104 LotByBinReportEmail
{
    ProcessingOnly = true;
    UseRequestPage = false;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    //Permissions = TableData 91 = rimd;

    dataset
    {
        // dataitem(DataItemName; SourceTableName)
        // {
        //     column(ColumnName; SourceFieldName)
        //     {

        //     }
        // }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                // group(GroupName)
                // {
                //     field(Name; SourceExpression)
                //     {
                //         ApplicationArea = All;

                //     }
                // }
            }
        }


    }

    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        userS.Reset();
        userS.SETRANGE("Sent Lot By Bin", true);
        userS.SetFilter("E-Mail", '<>%1', '');
        if userS.FindSet() then begin
            repeat
                SendEmailLotbyBin(userS, userS."E-Mail", 50103);
            until userS.Next = 0;
        end;
    end;

    var
        userS: Record "User Setup";
        RecCustomer: Record Customer;
        RecCustomreportselection: Record "Custom Report Selection";
        Name: Text[100];
        CompanyInfo: Record "Company Information";

    LOCAL procedure SendEmailLotbyBin(Var UserSetup: Record "User Setup"; RecipientEmail: Text; ReportIDVar: Integer)
    var
        TempBlob_lRec: Codeunit "Temp Blob";
        OutStrm: OutStream;
        RecRef: RecordRef;
        InStrm: InStream;
        BodyText: Text[100];
        L_User: Record "User Setup";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Subject: Text;
        Body: Text;
        Reciepts: List of [Text];
    //lotBinBuffere:Record "Lot Bin Buffer";
    begin
        Clear(Name);
        L_User.Reset();
        L_User.SetRange("User ID", UserSetup."User ID");
        if L_User.FindFirst() then begin
            Clear(Reciepts);
            Reciepts.Add(RecipientEmail);
            CompanyInfo.Get();
            Name := CopyStr(CompanyInfo.Name, 1, 30);
            Clear(Subject);
            Subject := Name + '- Lot By Bin ' + L_User."E-Mail";

            Clear(Body);
            Body += ('<br>');
            Body += ('<br>');
            Body += ('Please find the attached "Lot By Bin" Report');
            Body += ('<br>');
            Body += ('<br>');

            EmailMessage.Create(RecipientEmail, Subject, Body, true);
            //EmailMessage.Create(RecipientEmail, Subject, Name + '- Sales Invoice ' + L_SalesInvoiceHeader."No.");


            // RecRef.GetTable(L_User);

            TempBlob_lRec.CreateOutStream(OutStrm);
            Report.SaveAs(ReportIDVar, '', ReportFormat::Excel, OutStrm);
            TempBlob_lRec.CreateInStream(InStrm);
            EmailMessage.AddAttachment('Lot By Bin ' + L_User."E-Mail" + '.' + 'Xlsx', 'Excel', InStrm);


            //Email.Enqueue(EmailMessage, Enum::"Email Scenario"::Default);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

        end;
    end;

}