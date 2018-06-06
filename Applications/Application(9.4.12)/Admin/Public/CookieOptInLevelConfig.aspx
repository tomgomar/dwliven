<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CookieOptInLevelConfig.aspx.vb" Inherits="Dynamicweb.Admin.CookieOptInLevelConfig" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>OptIn Cookie Management</title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="margin: 100px 0px 0px 100px;">
        <p><dw:TranslateLabel ID="lblCurrentCookie" runat="server" Text=""/><br /></p>
        <p><dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Change OptIn Level Cookie:"/><br /></p>
        <table>
            <tr>
                <td><dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="None:"/></td>
                <td><input type="radio" runat="server" id="rbNone" name="level" /></td>
            </tr>
            <tr>
                <td><dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Functional:"/></td>
                <td><input type="radio" runat="server" id="rbFunctional" name="level" /></td>
            </tr>
            <tr>
                <td><dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="All:"/></td>
                <td><input type="radio" runat="server" id="rbAll" name="level" /></td>
            </tr>
            <tr>
                <td></td>
                <td align="right"><input id="Submit1" type="submit" runat="server" value="Set" /></td>
            </tr>
        </table>                
    </div>
    </form>
</body>
</html>
<% 
    Translate.GetEditOnlineScript()
%>        
