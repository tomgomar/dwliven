<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomShop_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomShop_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server" enableviewstate="false">
            <input type="hidden" name="selctedRowID" id="selctedRowID" />
            <asp:Literal ID="BoxStart" runat="server"></asp:Literal>

            <dw:List ID="List1" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25">
                <Filters></Filters>
                <Columns>
                    <dw:ListColumn ID="colName" runat="server" Name="Navn" EnableSorting="true" Width="300" />
                    <dw:ListColumn ID="colCreated" runat="server" Name="Oprettet" EnableSorting="true" />
                    <dw:ListColumn ID="colStandard" runat="server" Name="Standard" EnableSorting="true" />
                </Columns>
            </dw:List>

            <asp:Literal ID="BoxEnd" runat="server"></asp:Literal>
        </form>
    </div>
    <%If Dynamicweb.Context.Current.Request("didDeleteAll") = "False" Then%>
    <script type="text/javascript">
        alert('<%=Translate.JsTranslate("Not all items were deleted due to insufficient permissions.") %>');
    </script>
    <%End If%>
</body>
</html>
<%Translate.GetEditOnlineScript()%>
