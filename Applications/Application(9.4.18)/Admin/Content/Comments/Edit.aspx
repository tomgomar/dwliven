<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Edit.aspx.vb" Inherits="Dynamicweb.Admin.Edit4" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>

    <script src="Comments.js" type="text/javascript"></script>
    <script type="text/javascript">
        var commentid = <%=cID %>;
        var ItemID = '<%=ItemID %>';
        var Type = '<%=Type %>';
        var LangID = '<%=LangID %>'; 
        
        function save(){            
            if (!validateEmail()) { return; }
            document.getElementById('form1').submit();
        }

        function validateEmail() {
            var email = document.getElementById('Email');
            if (!validateEmailAddress(email.value)) {
                dwGlobal.showControlErrors(email, '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Please use correct email format")%>');
                var overlay = new overlay("__ribbonOverlay");
                overlay.hide();
                email.focus();
                return false;
            }
            return true;
        }

        function validateEmailAddress(address) {
            var regExp = /^[\w\-_]+(\.[\w\-_]+)*@[\w\-_]+(\.[\w\-_]+)*\.[a-z]{2,4}$/i;
            return address == '' || regExp.test(address);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" name="id" id="CommentID" runat="server" />
        <dw:Toolbar ID="Toolbar1" runat="server">
            <dw:ToolbarButton ID="ToolbarButton1" runat="server" Divide="None" Icon="Save" Text="Save" OnClientClick="save();" ShowWait="true">
            </dw:ToolbarButton>
            <dw:ToolbarButton ID="ToolbarButton2" runat="server" Divide="None" Icon="Cancel" Text="Cancel" OnClientClick="location.href = 'List.aspx?Type=' + Type + '&ItemID=' + ItemID + '&LangID=' + LangID;" ShowWait="true">
            </dw:ToolbarButton>
            <dw:ToolbarButton ID="ToolbarButton3" runat="server" Divide="None" Icon="Delete" Text="Slet" OnClientClick="del(commentid);" ShowWait="true">
            </dw:ToolbarButton>
        </dw:Toolbar>
        <h2 class="subtitle">
            <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Rediger" />
        </h2>
        <div>
            <dw:GroupBox ID="GroupBox1" runat="server" Title="Egenskaber">
                <table width="100%">
                    <tr>
                        <td width="170">
                            <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Navn" />
                        </td>
                        <td>
                            <dwc:InputText ID="Name" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="E-mail" />
                        </td>
                        <td>
                            <dwc:InputText ID="Email" runat="server" ValidationMessage="" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Website" />
                        </td>
                        <td>
                            <dwc:InputText ID="Website" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="active">
                                <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Status" />
                            </label>
                        </td>
                        <td>
                            <dw:CheckBox ID="active" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Rating" />
                        </td>
                        <td>
                            <dwc:SelectPicker runat="server" ID="Rating">
                                <asp:ListItem Value="0" Text=""></asp:ListItem>
                                <asp:ListItem Value="1" Text="">1</asp:ListItem>
                                <asp:ListItem Value="2" Text="">2</asp:ListItem>
                                <asp:ListItem Value="3" Text="">3</asp:ListItem>
                                <asp:ListItem Value="4" Text="">4</asp:ListItem>
                                <asp:ListItem Value="5" Text="">5</asp:ListItem>
                            </dwc:SelectPicker>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Kommentar" />
                        </td>
                        <td>
                            <dwc:InputTextArea runat="server" ID="Comment" Rows="5" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
        </div>
    </form>
</body>
</html>
