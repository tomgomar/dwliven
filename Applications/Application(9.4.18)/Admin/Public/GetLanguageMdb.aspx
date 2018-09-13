<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GetLanguageMdb.aspx.vb" Inherits="Dynamicweb.Admin.GetLanguageMdb" %>
<!DOCTYPE html>
<link rel="stylesheet" href="../Stylesheet.css" />
<html xmlns="http://www.w3.org/1999/xhtml"  style="height: 100%;">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server" style="height: 100%;">
    <div style="width: 100%; height: 100%; text-align: center; vertical-align:bottom;">
		<img id="icon" src="../Images/Icons/Alert.gif" runat="server" />
		<asp:Literal id="Msg" runat="server" /><br /><br />
        <a href="http://www.microsoft.com/downloads/details.aspx?familyid=C06B8369-60DD-4B64-A44B-84B371EDE16D&displaylang=en" id="msLink" runat="server" visible="false" >AccessDatabaseEngine_x64.exe</a> <br /><br />
		<input type="button" id="download" onclick="document.location.href='GetLanguageMdb.aspx?fetch=true';" runat="server" value="Yes" class="buttonSubmit" />
		<input type="button" id="dw" onclick="document.location.href='/Admin/Access';" runat="server" value="Go to login" class="buttonSubmit" />
    </div>
    </form>
</body>
</html>
