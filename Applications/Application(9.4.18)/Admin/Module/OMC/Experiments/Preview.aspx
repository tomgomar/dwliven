<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Preview.aspx.vb" Inherits="Dynamicweb.Admin.Preview" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title><dw:TranslateLabel runat="server" Text="Preview" /></title>
	<dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="true"/>
	<link rel="StyleSheet" href="Preview.css" type="text/css" />
	<script type="text/javascript" src="Preview.js">
	</script>
</head>
<body>
	<form action="">
	<input type="hidden" id="testurl" value="<%=Dynamicweb.Context.Current.Request("original") %>" />
	</form>
    <div class="header">
		<h1 runat="server" id="previewHeading"></h1>
		<a href="javascript:test('1');" class="active" id="link1"><%= Dynamicweb.SystemTools.Translate.Translate("Original")%></a>
		<a href="javascript:test('2');" class="" id="link2"><%= Dynamicweb.SystemTools.Translate.Translate("Variants")%></a>
    </div>
	<div style="position:fixed;top:43px;bottom:0px;right:0px;left:0px;">
		<iframe id="previewFrame" src="<%=Dynamicweb.Context.Current.Request("original") %>&variation=1" style="border:0;width:100%;height:100%;">
	</iframe>
	</div>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
