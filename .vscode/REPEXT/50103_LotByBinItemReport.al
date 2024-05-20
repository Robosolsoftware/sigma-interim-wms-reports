// need to check ++

// report 50103 LotByBinItemReport
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './LotByBinItemReport.rdlc';
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     Caption = 'Lot By Bin Item Report';
//     //ProcessingOnly = true;

//     dataset
//     {
//         dataitem(LotbinBufferCount; Integer)
//         {

//             column(Item_No_; LotbinBuffer."Item No.")
//             {

//             }
//             column(Item_Description; LotbinBuffer."Item Description")
//             {

//             }
//             column(Item_Category; LotbinBuffer."Item Category")
//             {

//             }
//             column(Aggreagate_Code; LotbinBuffer."Aggreagate Code")
//             {

//             }
//             column(Warehouse_Class_Code; LotbinBuffer."Warehouse Class Code")
//             {

//             }
//             column(Location_Code; LotbinBuffer."Location Code")
//             {

//             }
//             column(Zone_Code; LotbinBuffer."Zone Code")
//             {

//             }
//             column(Bin_Code; LotbinBuffer."Bin Code")
//             {

//             }
//             column(Lot_No_; LotbinBuffer."Lot No.")
//             {

//             }
//             column(Expiry_Date; format(LotbinBuffer."Expiry Date"))
//             {

//             }
//             column(Qty___Base_; LotbinBuffer."Qty. (Base)")
//             {

//             }
//             trigger OnAfterGetRecord()
//             var

//             begin
//                 if LotbinBuffer.Count > 0 then begin
//                     if LotbinBufferCount.Number = 1 then begin
//                         if LotbinBuffer.FindFirst() then;
//                     end else
//                         LotbinBuffer.Next();
//                 end;

//             end;

//             trigger OnPreDataItem()
//             var
//             // Counts: Decimal;
//             begin
//                 LotbinBuffer.Reset();
//                 Clear(LotbinBuffer);
//                 //counts := LotbinBuffer.Count;
//                 LotbinBufferCount.SETRANGE(Number, 1, LotbinBuffer.COUNT);
//             end;
//         }
//     }
//     trigger OnPreReport()
//     var
//         LotNosByBinCode: Query "LotNumber WarehouseEntry New";
//         RecItemCategory: Record "Item Category";
//         ItemTrackingManagement: Codeunit 6500;
//         EntriesExist: Boolean;
//         ItemTrackingSetup: Record "Item Tracking Setup";
//         LotFound: Boolean;
//     begin
//         LotbinBuffer.DELETEALL;
//         itemT.Reset();

//         itemT.SetRange(Blocked, false);
//         if itemT.FindSet() then begin
//             repeat

//                 itemT.CalcFields(Inventory);
//                 if itemT.Inventory > 0 then begin
//                     InitiallizeLotByBinItem(itemT."No.");

//                 end;
//             until itemT.next = 0;

//         end;

//     end;

//     trigger OnPostReport()
//     var
//         myInt: Integer;
//     begin
//         LotbinBuffer.DELETEALL;
//     end;


//     // requestpage
//     // {
//     //     layout
//     //     {
//     //         area(Content)
//     //         {
//     //             group(GroupName)
//     //             {
//     //                 field(Name; SourceExpression)
//     //                 {
//     //                     ApplicationArea = All;

//     //                 }
//     //             }
//     //         }
//     //     }

//     //     actions
//     //     {
//     //         area(processing)
//     //         {
//     //             action(ActionName)
//     //             {
//     //                 ApplicationArea = All;

//     //             }
//     //         }
//     //     }
//     // }



//     var
//         myInt: Integer;
//         itemN: Code[50];
//         itemT: Record Item;
//         //LotbinBuffer: Record "Lot Bin Buffer" temporary;
//         ItemTrackingSetup: Record "Item Tracking Setup";
//         ItemTrackingManagement: Codeunit 6500;
//         LotbinBuffer: Record "Lot Bin Buffer" temporary;

//     local procedure InitiallizeLotByBinItem(itemN: Code[50])
//     var
//         LotNosByBinCode: Query "LotNumber WarehouseEntry New";
//         Reclocation: Record Location;
//         RecItemCategory: Record "Item Category";
//         itemT2: Record Item;
//         EntriesExist: Boolean;


//     begin

//         LotNosByBinCode.SETRANGE(Item_No, itemN);
//         // // Manish ++
//         // IF UserSetup.GET(USERID) THEN BEGIN
//         //     IF ResponsibilityCenter.GET(UserSetup."Sales Resp. Ctr. Filter") THEN BEGIN
//         //         //SETFILTER("Location Filter",ResponsibilityCenter."Location Code");
//         //         //CALCFIELDS(Inventory);
//         //         LotNosByBinCode.SETRANGE(LotNosByBinCode.Location_Code, ResponsibilityCenter."Location Code");
//         //     END
//         // END;
//         // // Manish --

//         LotNosByBinCode.OPEN;


//         WHILE LotNosByBinCode.READ DO BEGIN
//             LotbinBuffer.INIT;
//             LotbinBuffer."Item No." := LotNosByBinCode.Item_No;
//             LotbinBuffer."Variant Code" := LotNosByBinCode.Variant_Code;
//             LotbinBuffer."Location Code" := LotNosByBinCode.Location_Code;
//             LotbinBuffer."Zone Code" := LotNosByBinCode.Zone_Code;
//             LotbinBuffer."Bin Code" := LotNosByBinCode.Bin_Code;
//             LotbinBuffer."Lot No." := LotNosByBinCode.Lot_No;
//             ItemTrackingSetup."Lot No." := LotNosByBinCode.Lot_No;
//             LotbinBuffer."Expiry Date" := ItemTrackingManagement.ExistingExpirationDate(LotNosByBinCode.Item_No, LotNosByBinCode.Variant_Code, ItemTrackingSetup, FALSE, EntriesExist);
//             LotbinBuffer."Qty. (Base)" := LotNosByBinCode.Sum_Quantity;

//             itemT2.Reset();
//             itemT2.SetRange("No.", LotNosByBinCode.Item_No);
//             if itemT2.FindFirst() then begin
//                 LotbinBuffer."Item Description" := itemT2.Description;
//                 LotbinBuffer."Item Category" := itemT2."Item Category Code";
//                 RecItemCategory.Reset();
//                 RecItemCategory.SetRange(Code, itemT2."Item Category Code");
//                 if RecItemCategory.FindFirst() then begin
//                     LotbinBuffer."Aggreagate Code" := RecItemCategory."Parent Category";
//                 end;

//                 LotbinBuffer."Warehouse Class Code" := itemT2."Warehouse Class Code";

//             end;

//             IF LotbinBuffer."Qty. (Base)" <> 0 THEN
//                 LotbinBuffer.INSERT;


//         END;
//     end;
// }