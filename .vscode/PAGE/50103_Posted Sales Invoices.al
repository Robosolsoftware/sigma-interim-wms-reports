pageextension 50103 "SPR Posted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Print)
        {
            action("Send Invoice")
            {
                ApplicationArea = All;
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AutoEmailDailySalesInvoice: Report "Auto Email Daily Sales Invoice";
                begin
                    Clear(AutoEmailDailySalesInvoice);
                    AutoEmailDailySalesInvoice.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}