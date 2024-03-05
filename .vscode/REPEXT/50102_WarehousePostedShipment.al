reportextension 50102 PostedWarehouseShipmentExt extends "Whse. - Posted Shipment"
{
    RDLCLayout = 'WarehouseShipment.rdl';
    dataset
    {
        add("Posted Whse. Shipment Header")
        {
            column(Transfer_to_Code; "Location Code")
            {
            }
            column(Transfer_from_Code; "Zone Code")
            {
            }
            column(PalletID; "Pallet ID")
            {
            }
            column(Vehicle_Reg_No_; "Vehicle Reg No.")
            {
            }
            column(Receipted_By; "Receipted By")
            {
                //Checked By move in header
            }
            column(Shipped_By; "Shipped By")
            {
                //Transfered by move is in the header
            }
            column(Requested_By; "Requested By")
            {
            }
            column(Shipment_Date; "Shipment Date")
            {
            }
            column(Time_of_Shipment; "Time of Shipment")
            {
            }
            // column(ReceiptDate; "Receipt Date")
            // {
            // }
            column(Time_of_Receipt; "Time of Receipt")
            {
            }
            // column(Transfer_from_Name; "Transfer-from Name")
            // {
            // }
            // column(Transfer_to_Name; "Transfer-to Name")
            // {
            // }
            column(Comments; Comments)
            {
            }
            column(Seal_No_; "Seal No.")
            {
            }
            column(Logo; G_CompInfo.Picture)
            {
            }
            column(PostDate; "Posting Date")
            {
            }
            column(TransferOrderNo; TransferOrderNo)
            {
            }
        }
        modify("Posted Whse. Shipment Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                wareshipline: Record "Posted Whse. Shipment Line";
            begin
                wareshipline.Reset();
                wareshipline.SetRange("No.", "Posted Whse. Shipment Header"."No.");
                if wareshipline.FindFirst() then begin
                    TransferOrderNo := wareshipline."Source No.";
                end;
            end;
        }

        add("Posted Whse. Shipment Line")
        {
            column(Line_No; "Line No.")
            {
            }
            column(PackSize; "Pack Size")
            {
            }
            column(Brand; Brand)
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(ControlledDrug; ControlledDrug)
            {
            }
            column(Pallet; Pallet)
            {
            }
        }


        modify("Posted Whse. Shipment Line")
        {
            trigger OnAfterAfterGetRecord()
            var

            begin
                G_Item.Reset();
                G_Item.SetRange("No.", "Posted Whse. Shipment Line"."Item No.");
                if G_Item.FindFirst() then begin
                    // ControlledDrug := G_Item."Warehouse Class Code";
                    Pallet := G_Item."Pallet Quantity";

                    if G_Item."Warehouse Class Code" <> '' then begin
                        ControlledDrug := 'Yes'
                    end else
                        ControlledDrug := 'No';
                end;

            end;
        }
    }
    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        G_CompInfo.GET;
        G_CompInfo.CALCFIELDS(G_CompInfo.Picture);
    end;

    var
        G_CompInfo: Record "Company Information";
        G_Item: Record Item;
        ControlledDrug: Code[20];
        Pallet: Decimal;
        TransferOrderNo: Code[20];

}