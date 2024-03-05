pageextension 50100 PostedWhseShipmentCardExt extends "Posted Whse. Shipment"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Print")
        {
            action("Print Transfer Shipment")
            {
                Image = Print;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    TransferShip: Report "Transfer Shipment";
                    warehshipline: Record "Posted Whse. Shipment Line";
                    PostedTransShip: Record "Transfer Shipment Header";
                begin
                    warehshipline.Reset();
                    PostedTransShip.Reset();
                    warehshipline.SetRange("No.", Rec."No.");
                    if warehshipline.FindFirst() then begin
                        if warehshipline."Posted Source Document" = warehshipline."Posted Source Document"::"Posted Transfer Shipment" then begin
                            PostedTransShip.SetRange("No.", warehshipline."Posted Source No.");
                            if PostedTransShip.FindFirst() then
                                REPORT.RUNMODAL(5704, TRUE, FALSE, PostedTransShip);
                        end;
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}