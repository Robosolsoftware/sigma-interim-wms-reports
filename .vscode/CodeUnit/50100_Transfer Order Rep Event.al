codeunit 50105 PostedTransferShipmentEvent
{
    [EventSubscriber(ObjectType::Table, database::"Transfer Shipment Header", 'OnAfterCopyFromTransferHeader', '', false, false)]

    local procedure OnAfterCopyFromTransferHeader(var TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferShipmentHeader."Time of Shipment" := TransferHeader."Time of Shipment";
        TransferShipmentHeader."Time of Receipt" := TransferHeader."Time of Receipt";
        TransferShipmentHeader."Vehicle Reg No." := TransferHeader."Vehicle Reg No.";
        TransferShipmentHeader."Pallet ID" := TransferHeader."Pallet ID";
        TransferShipmentHeader."Shipped By" := TransferHeader."Shipped By";
        TransferShipmentHeader."Receipted By" := TransferHeader."Receipted By";
        TransferShipmentHeader."Requested By" := TransferHeader."Requested By";
        TransferShipmentHeader.Comments := TransferHeader.Comments;
        TransferShipmentHeader."Seal No." := TransferHeader."Seal No.";

    end;

    [EventSubscriber(ObjectType::Table, database::"Transfer Receipt Header", 'OnAfterCopyFromTransferHeader', '', false, false)]

    local procedure OnAfterCopyFromTransferHeaderrcp(TransferHeader: Record "Transfer Header"; var TransferReceiptHeader: Record "Transfer Receipt Header")
    begin
        TransferReceiptHeader."Time of Shipment" := TransferHeader."Time of Shipment";
        TransferReceiptHeader."Time of Receipt" := TransferHeader."Time of Receipt";
        TransferReceiptHeader."Vehicle Reg No." := TransferHeader."Vehicle Reg No.";
        TransferReceiptHeader."Pallet ID" := TransferHeader."Pallet ID";
        TransferReceiptHeader."Shipped By" := TransferHeader."Shipped By";
        TransferReceiptHeader."Receipted By" := TransferHeader."Receipted By";
        TransferReceiptHeader."Requested By" := TransferHeader."Requested By";
        TransferReceiptHeader.Comments := TransferHeader.Comments;
        TransferReceiptHeader."Seal No." := TransferHeader."Seal No.";
    end;

    [EventSubscriber(ObjectType::Table, database::"Transfer Receipt Line", 'OnAfterCopyFromTransferLine', '', false, false)]

    local procedure OnAfterCopyFromTransferLinecp(TransferLine: Record "Transfer Line"; var TransferReceiptLine: Record "Transfer Receipt Line")
    begin
        TransferReceiptLine."Pack Size" := TransferLine."Pack Size";
        TransferReceiptLine.Brand := TransferLine.Brand;
    end;

    [EventSubscriber(ObjectType::Table, database::"Transfer Shipment Line", 'OnAfterCopyFromTransferLine', '', false, false)]

    local procedure OnAfterCopyFromTransferLine(TransferLine: Record "Transfer Line"; var TransferShipmentLine: Record "Transfer Shipment Line")
    begin
        TransferShipmentLine."Pack Size" := TransferLine."Pack Size";
        TransferShipmentLine.Brand := TransferLine.Brand;
    end;

}