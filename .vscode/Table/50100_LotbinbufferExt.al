tableextension 50111 LotBinBufferExt1 extends "Lot Bin Buffer"
{
    fields
    {
        field(50100; "Item Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Item Category"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Aggreagate Code"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Warehouse Class Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}