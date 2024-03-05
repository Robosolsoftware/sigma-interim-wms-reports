report 50100 "Auto Email Daily Sales Invoice"
{
    UsageCategory = Administration;
    UseRequestPage = false;
    ProcessingOnly = true;
    Permissions = tabledata 112 = m;

    dataset
    {
        dataitem(DataItemName; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            trigger OnPreDataItem()
            var
                RecSalesInvoiceHeader: Record "Sales Invoice Header";
                RecCustomer: Record Customer;
                RecCustomreportselection: Record "Custom Report Selection";
                L_RecSalesInvoiceHeader: Record "Sales Invoice Header";
            begin

                RecSalesInvoiceHeader.RESET;
                RecSalesInvoiceHeader.SetFilter("Send By", '%1|%2', RecSalesInvoiceHeader."Send By"::Email, RecSalesInvoiceHeader."Send By"::"Email & Print");
                //RecSalesInvoiceHeader.SetRange("Email Sent", false);
                IF RecSalesInvoiceHeader.FINDFIRST THEN BEGIN
                    REPEAT
                        RecCustomer.RESET;
                        RecCustomer.SETRANGE("No.", RecSalesInvoiceHeader."Bill-to Customer No.");
                        IF RecCustomer.FINDFIRST THEN BEGIN
                            RecCustomreportselection.RESET;
                            RecCustomreportselection.SETRANGE("Source Type", 18);
                            RecCustomreportselection.SETRANGE("Source No.", RecCustomer."No.");
                            RecCustomreportselection.SETRANGE(Usage, RecCustomreportselection.Usage::"S.Invoice");
                            IF RecCustomreportselection.FINDFIRST THEN BEGIN
                                IF RecCustomreportselection."Send To Email" <> '' THEN BEGIN
                                    IF RecCustomreportselection."Report ID" > 0 THEN BEGIN
                                        SendEmailInvoiceCopy(RecSalesInvoiceHeader, RecCustomreportselection."Send To Email", RecCustomreportselection."Report ID");

                                        L_RecSalesInvoiceHeader.Reset();
                                        L_RecSalesInvoiceHeader.SetRange("No.", RecSalesInvoiceHeader."No.");
                                        if L_RecSalesInvoiceHeader.FindFirst() then begin
                                            L_RecSalesInvoiceHeader."Email Sent" := true;
                                            L_RecSalesInvoiceHeader.Modify();
                                        end;
                                    END;
                                END;
                            END;
                        END;
                    UNTIL RecSalesInvoiceHeader.NEXT = 0;
                END;
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {

            }
        }
    }

    var
        myInt: Integer;
        AttachmentName: Text[100];
        RecSalesInvoiceHeader: Record "Sales Invoice Header";
        Fileman: Codeunit "File Management";




    // LOCAL procedure SendEmailInvoiceCopy1(var SalesInvHeader: Record "Sales Invoice Header"; RecipientEmail: Text)
    // var
    //     TempBlob_lRec: Codeunit "Temp Blob";
    //     OutStrm: OutStream;
    //     RecRef: RecordRef;
    //     InStrm: InStream;
    //     BodyText: Text[100];
    //     L_SalesInvoiceHeader: Record "Sales Invoice Header";
    //     Reciepts: List of [Text];
    // begin
    //     L_SalesInvoiceHeader.Reset();
    //     L_SalesInvoiceHeader.SetRange("No.", SalesInvHeader."No.");
    //     if L_SalesInvoiceHeader.FindFirst() then begin
    //         RecRef.GetTable(L_SalesInvoiceHeader);
    //         TempBlob_lRec.CreateOutStream(OutStrm);
    //         Report.SaveAs(70194931, '', ReportFormat::Pdf, OutStrm, RecRef);
    //         TempBlob_lRec.CreateInStream(InStrm);

    //         SMTPMailSetup.Get();
    //         CLEAR(SMTPMail);
    //         Clear(Reciepts);
    //         Reciepts.Add(RecipientEmail);
    //         SMTPMail.CreateMessage('', SMTPMailSetup."Send As", Reciepts, '', '', TRUE);
    //         SMTPMail.AddAttachmentStream(InStrm, 'Sales Invoice ' + L_SalesInvoiceHeader."Sell-to Customer Name" + L_SalesInvoiceHeader."No." + '.pdf');
    //         SMTPMail.AppendBody('Hi ' + L_SalesInvoiceHeader."Sell-to Customer Name" + ',');
    //         SMTPMail.AppendBody('<BR>');
    //         SMTPMail.AppendBody('<BR/>');
    //         SMTPMail.AppendBody('Please find attached your Sales Invoice');
    //         SMTPMail.AppendBody('<HR>');
    //         SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this mail!');
    //         SMTPMail.Send;

    //     end;
    // end;


    LOCAL procedure SendEmailInvoiceCopy(Var SalesInvHeader: Record "Sales Invoice Header"; RecipientEmail: Text; ReportIDVar: Integer)
    var
        TempBlob_lRec: Codeunit "Temp Blob";
        OutStrm: OutStream;
        RecRef: RecordRef;
        InStrm: InStream;
        BodyText: Text[100];
        L_SalesInvoiceHeader: Record "Sales Invoice Header";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Subject: Text;
        Body: Text;
        Reciepts: List of [Text];
    begin
        L_SalesInvoiceHeader.Reset();
        L_SalesInvoiceHeader.SetRange("No.", SalesInvHeader."No.");
        if L_SalesInvoiceHeader.FindFirst() then begin
            Clear(Reciepts);
            Reciepts.Add(RecipientEmail);

            Clear(Subject);
            Subject := 'Sales Invoice' + L_SalesInvoiceHeader."Bill-to Name" + L_SalesInvoiceHeader."No.";

            Clear(Body);
            Body += ('Dear Customer,');
            Body += ('<br>');
            Body += ('Thank you for your order, please see attached your invoice.');
            Body += ('<br>');

            EmailMessage.Create(RecipientEmail, Subject, Body, true);
            RecRef.GetTable(L_SalesInvoiceHeader);
            TempBlob_lRec.CreateOutStream(OutStrm);
            Report.SaveAs(ReportIDVar, '', ReportFormat::Pdf, OutStrm, RecRef);
            TempBlob_lRec.CreateInStream(InStrm);
            EmailMessage.AddAttachment('Sales Invoice ' + L_SalesInvoiceHeader."No." + '.' + 'pdf', 'PDF', InStrm);
            Email.Enqueue(EmailMessage, Enum::"Email Scenario"::Default);
            // SMTPMailSetup.Get();
            // CLEAR(SMTPMail);
            // Clear(Reciepts);
            // Reciepts.Add(RecipientEmail);
            // SMTPMail.CreateMessage('', SMTPMailSetup."Send As", Reciepts, '', '', TRUE);
            // SMTPMail.AddAttachmentStream(InStrm, 'Sales Invoice ' + L_SalesInvoiceHeader."Sell-to Customer Name" + L_SalesInvoiceHeader."No." + '.pdf');
            // SMTPMail.AppendBody('Hi ' + L_SalesInvoiceHeader."Sell-to Customer Name" + ',');
            // SMTPMail.AppendBody('<BR>');
            // SMTPMail.AppendBody('<BR/>');
            // SMTPMail.AppendBody('Please find attached your Sales Invoice');
            // SMTPMail.AppendBody('<HR>');
            // SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this mail!');
            // SMTPMail.Send;

        end;
    end;

}