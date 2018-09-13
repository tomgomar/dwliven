<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomLoyaltyUserTransaction_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomLoyaltyUserTransaction_Edit" %>
<%@ Register assembly="Dynamicweb.Controls" namespace="Dynamicweb.Controls" tagprefix="dw" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server" IncludePrototype="true" IncludeUIStylesheet ="true">
        <Items>
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/css/UserTransactions.css" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/EcomLoyaltyUserTransaction_Edit.js" />
        </Items>
    </dw:ControlResources>
</head>
<body>
    <div id="containerNP" class="hidden"><dw:Infobar runat="server" ID="NoPoints" Type="Warning"  TranslateMessage="true" Message="User does not have enough points"/></div>
    <div id="containerED" class="hidden"><dw:Infobar runat="server" ID="EmptyData"   Type="Information" TranslateMessage ="true"  Message="Points is required" /></div> 
    <form id="form1" class="border" runat="server">
    <div>
        <table>
            <tr>
                <td><dw:TranslateLabel CssClass="NewUIinput lbl" runat="server" Text="Points" /></td>
                <td><asp:TextBox runat="server" TextMode="SingleLine" CssClass="NewUIinput" ID="pointsNum"></asp:TextBox></td>
            </tr>
            <tr>
                <td><dw:TranslateLabel CssClass="NewUIinput lbl"  runat="server" Text="Comment" /></td>
                <td><asp:TextBox runat="server" TextMode="MultiLine" Height="45" CssClass="NewUIinput" ID="transactionComment"></asp:TextBox></td>
            </tr>
        </table>
            <div class="buttobbox">
                <button type="button" class="NewUIinput button" onclick="Dynamicweb.eCommerce.Loyalty.Transactions.createTransaction(<%=UserID %>);"><%=Translate.Translate("OK")%></button>
                <button type="button" class="NewUIinput button" onclick="Dynamicweb.eCommerce.Loyalty.Transactions.closeWindow();"><%=Translate.Translate("Cancel")%></button>
            </div>
    </div>
    </form>
</body>
</html>
