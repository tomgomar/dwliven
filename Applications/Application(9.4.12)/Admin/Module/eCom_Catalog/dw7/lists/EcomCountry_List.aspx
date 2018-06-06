<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomCountry_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomCountry_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
    <script type="text/javascript">
        var addAllMsg = '<%= AddAllMessage %>';
        function addAllCountries() {
            if (confirm(addAllMsg)) selectCountry('-1');
            else $('CountryLayer').hide();
        }
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server">
            <input type="hidden" name="selctedRowID" id="selctedRowID" />
            <asp:Literal ID="BoxStart" runat="server"></asp:Literal>
            <dw:List ID="List1" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25">
                <Filters></Filters>
                <Columns>
                    <dw:ListColumn ID="colCode" runat="server" Name="Landekode" EnableSorting="true" Width="300" />
                    <dw:ListColumn ID="colName" runat="server" Name="Navn" EnableSorting="true" />
                </Columns>
            </dw:List>
            <asp:Literal ID="BoxEnd" runat="server"></asp:Literal>
        </form>
    </div>

</body>
</html>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
