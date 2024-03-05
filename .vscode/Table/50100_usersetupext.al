tableextension 50100 UsersetupExt extends "User Setup"
{
    fields
    {
        field(50100; "Sent Lot By Bin"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}