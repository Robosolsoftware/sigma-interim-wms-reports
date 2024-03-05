reportextension 50100 TransferOrderRepExt extends "Transfer Order"
{
    RDLCLayout = 'Transfer Order1.rdl';
    dataset
    {
        add("Transfer Header")
        {
            column(Transfer_to_Code; "Transfer-to Code")
            {
            }
            column(Transfer_from_Code; "Transfer-from Code")
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
            column(ReceiptDate; "Receipt Date")
            {
            }
            column(Time_of_Receipt; "Time of Receipt")
            {
            }
            column(Transfer_from_Name; "Transfer-from Name")
            {
            }
            column(Transfer_to_Name; "Transfer-to Name")
            {
            }
            column(Comments; Comments)
            {
            }
            column(Seal_No_; "Seal No.")
            {
            }
            column(Logo; G_CompInfo.Picture)
            {
            }
        }
        add("Transfer Line")
        {
            column(PackSize; "Pack Size")
            {
            }
            column(Brand; Brand)
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(Receipt_Date; "Receipt Date")
            {
            }
            column(ControlledDrug; ControlledDrug)
            {
            }
            column(Pallet; Pallet)
            {
            }
            column(G_transferbin; G_transferbin)
            {

            }
        }
        modify("Transfer Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                WarehouseActivityLine: Record "Warehouse Activity Line";
            begin
                G_Item.Reset();
                G_Item.SetRange("No.", "Transfer Line"."Item No.");
                if G_Item.FindFirst() then begin
                    // ControlledDrug := G_Item."Warehouse Class Code";
                    Pallet := G_Item."Pallet Quantity";

                    if G_Item."Warehouse Class Code" <> '' then begin
                        ControlledDrug := 'Yes'
                    end else
                        ControlledDrug := 'No';
                end;
                Clear(G_transferbin);
                WarehouseActivityLine.Reset();
                WarehouseActivityLine.SetRange("Item No.", "Transfer Line"."Item No.");
                WarehouseActivityLine.SetRange("Source No.", "Transfer Line"."Document No.");
                WarehouseActivityLine.SetRange("Source Line No.", "Transfer Line"."Line No.");
                WarehouseActivityLine.SetRange("Action Type", WarehouseActivityLine."Action Type"::Take);
                if WarehouseActivityLine.FindSet() then begin
                    repeat
                        if G_transferbin = '' then begin
                            G_transferbin := WarehouseActivityLine."Bin Code";
                        end
                        else begin
                            G_transferbin := G_transferbin + ',' + WarehouseActivityLine."Bin Code";
                        end;
                    //TransferLineQty := WarehouseActivityLine.Quantity;
                    until WarehouseActivityLine.Next() = 0;
                end else
                    G_transferbin := "Transfer Line"."Transfer-from Bin Code";


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
        G_transferbin: Text;
        TransferLineQty: Decimal;
}