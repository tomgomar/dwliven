<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomOrderContext_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomOrderContext_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form2" runat="server">
            <asp:Literal ID="BoxStart" runat="server"></asp:Literal>
            <dw:List ID="List1" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25">
                <Filters></Filters>
                <Columns>
                    <dw:ListColumn ID="colId" runat="server" Name="Id" Width="150" EnableSorting="true" />
                    <dw:ListColumn ID="colName" runat="server" Name="Navn" Width="200" EnableSorting="true" />
                    <dw:ListColumn ID="colShops" runat="server" Name="Shops" Width="400" EnableSorting="true" />
                </Columns>
            </dw:List>
            <asp:Literal ID="BoxEnd" runat="server"></asp:Literal>
        </form>
    </div>
</body>
</html>

<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
