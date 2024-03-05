page 50110 LotNoByItemAPI
{
    PageType = API;
    Caption = 'Lot No By Item API';
    APIPublisher = 'Robosol';
    APIGroup = 'orders';
    APIVersion = 'beta', 'v1.0';
    EntityName = 'LotNoByItemAPI';
    EntitySetName = 'LotNoByItemAPI';
    SourceTable = "Lot Bin Buffer";
    SourceTableTemporary = true;
    DelayedInsert = true;
    //ApplicationArea = all;
    ODataKeyFields = SystemId;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;



    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(itemN; rec."Item No.")
                {
                    ApplicationArea = all;
                    Caption = 'Item No.';
                }
                field(ItemDescription; Rec."Item Description")
                {
                    ApplicationArea = all;
                    Caption = 'Item Description';
                }
                field(ItemCategory; Rec."Item Category")
                {
                    ApplicationArea = all;
                    Caption = 'Item Category';
                }
                field(AggreagateCode; Rec."Aggreagate Code")
                {
                    ApplicationArea = all;
                    Caption = 'Aggreagate Code';
                }
                field(WarehouseClassCode; Rec."Warehouse Class Code")
                {
                    ApplicationArea = all;
                    Caption = 'Warehouse Class Code';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = All;
                    StyleExpr = Color;
                    Caption = 'Location Code';

                }
                field(ZoneCode; rec."Zone Code")
                {
                    ApplicationArea = all;
                    Caption = 'Zone Code';
                }
                field(BinCode; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    Caption = 'Bin Code';
                }
                field(LotNo; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    Caption = 'Lot No.';
                }
                field(ExpiryDate; Rec."Expiry Date")
                {
                    ApplicationArea = all;
                    Caption = 'Expiry Date';

                }
                field(QtyBase; Rec."Qty. (Base)")
                {
                    StyleExpr = Color;
                    ApplicationArea = All;
                    Caption = 'Inventory';
                }


            }
        }
    }

    actions
    {
    }


    trigger OnOpenPage()
    var
        LotNosByBinCode: Query "LotNumber WarehouseEntry New";
        RecItemCategory: Record "Item Category";
        ItemTrackingManagement: Codeunit 6500;
        EntriesExist: Boolean;
        ItemTrackingSetup: Record "Item Tracking Setup";
        LotFound: Boolean;
    begin
        Rec.DELETEALL;
        itemT.Reset();

        itemT.SetRange(Blocked, false);
        if itemT.FindSet() then begin
            repeat

                itemT.CalcFields(Inventory);
                if itemT.Inventory > 0 then begin
                    FillTempTable(itemT."No.");

                end;
            until itemT.next = 0;
            CurrPage.Update();
        end;

    end;

    var
        Color: Text;
        ManufacturerName: Text;
        ItemVariant: Record 5401;
        ExpDate: Text;
        TempLotNoBinBuffer: Record 7351 temporary;
        ItemTrackingManagement: Codeunit 6500;
        EntriesExist: Boolean;
        UserSetup: Record 91;
        ResponsibilityCenter: Record 5714;
        ExternalIdNo: Code[20];
        AsinNo: Code[20];
        ItemTrackingSetup: Record "Item Tracking Setup";
        itemT: Record Item;



    local procedure FillTempTable(itemN: Code[50])
    var
        LotNosByBinCode: Query "LotNumber WarehouseEntry New";
        Reclocation: Record Location;
        RecItemCategory: Record "Item Category";
        itemT2: Record Item;

    begin

        LotNosByBinCode.SETRANGE(Item_No, itemN);
        // // Manish ++
        // IF UserSetup.GET(USERID) THEN BEGIN
        //     IF ResponsibilityCenter.GET(UserSetup."Sales Resp. Ctr. Filter") THEN BEGIN
        //         //SETFILTER("Location Filter",ResponsibilityCenter."Location Code");
        //         //CALCFIELDS(Inventory);
        //         LotNosByBinCode.SETRANGE(LotNosByBinCode.Location_Code, ResponsibilityCenter."Location Code");
        //     END
        // END;
        // // Manish --

        LotNosByBinCode.OPEN;


        WHILE LotNosByBinCode.READ DO BEGIN
            Rec.INIT;
            Rec."Item No." := LotNosByBinCode.Item_No;
            Rec."Variant Code" := LotNosByBinCode.Variant_Code;
            Rec."Location Code" := LotNosByBinCode.Location_Code;
            Rec."Zone Code" := LotNosByBinCode.Zone_Code;
            Rec."Bin Code" := LotNosByBinCode.Bin_Code;
            Rec."Lot No." := LotNosByBinCode.Lot_No;
            ItemTrackingSetup."Lot No." := LotNosByBinCode.Lot_No;
            Rec."Expiry Date" := ItemTrackingManagement.ExistingExpirationDate(LotNosByBinCode.Item_No, LotNosByBinCode.Variant_Code, ItemTrackingSetup, FALSE, EntriesExist);
            Rec."Qty. (Base)" := LotNosByBinCode.Sum_Quantity;

            itemT2.Reset();
            itemT2.SetRange("No.", LotNosByBinCode.Item_No);
            if itemT2.FindFirst() then begin
                rec."Item Description" := itemT2.Description;
                rec."Item Category" := itemT2."Item Category Code";
                RecItemCategory.Reset();
                RecItemCategory.SetRange(Code, itemT2."Item Category Code");
                if RecItemCategory.FindFirst() then begin
                    rec."Aggreagate Code" := RecItemCategory."Parent Category";
                end;

                rec."Warehouse Class Code" := itemT2."Warehouse Class Code";

            end;

            IF Rec."Qty. (Base)" <> 0 THEN
                Rec.INSERT;


        END;
    end;

}