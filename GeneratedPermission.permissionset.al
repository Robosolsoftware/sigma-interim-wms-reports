permissionset 50100 GeneratedPermission
{
    Assignable = true;
    Permissions = report "Auto Email Daily Sales Invoice"=X,
        report LotByBinReportEmail=X,
        codeunit PostedTransferShipmentEvent=X;
}