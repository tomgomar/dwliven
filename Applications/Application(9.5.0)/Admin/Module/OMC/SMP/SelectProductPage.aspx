<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SelectProductPage.aspx.vb" Inherits="Dynamicweb.Admin.OMC.SMP.SelectProductPage" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <style type="text/css">
    #insertGlobalElementList_body tr
    {
        cursor:pointer;
    }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <dw:List ID="productPageList" runat="server" Title="Select page with product catalog" PageSize="20" ShowCollapseButton="False">
        <Filters>
            <dw:ListAutomatedSearchFilter ID="sFilter" runat="server" />
        </Filters>
        <Columns>
            <dw:ListColumn ID="imageCol" runat="server" Name="" Width="25">
            </dw:ListColumn>
            <dw:ListColumn ID="pageNameCol" runat="server" Name="Page name" Width="200" EnableSorting="true">
            </dw:ListColumn>
            <dw:ListColumn ID="fromCol" runat="server" Name="From" Width="310" EnableSorting="true">
            </dw:ListColumn>
        </Columns>
    </dw:List>
    </form>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
