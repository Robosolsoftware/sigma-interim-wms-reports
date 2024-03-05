pageextension 50102 UserSetupExt extends "User Setup"
{
    layout
    {
        addafter("Register Time")
        {
            field("Sent Lot By Bin"; Rec."Sent Lot By Bin")
            {
                ApplicationArea = all;
                Caption = 'Email Lot by Bin Report';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}