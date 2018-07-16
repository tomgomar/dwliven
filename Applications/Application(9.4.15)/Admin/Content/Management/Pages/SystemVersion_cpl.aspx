<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="SystemVersion_cpl.aspx.vb" Inherits="Dynamicweb.Admin.SystemVersion_cpl" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function() {
             document.getElementById('MainForm').submit();
        }

	</script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>
            <li><a href="#">System</a></li>
            <li class="active"><%= Translate.Translate("Version") %></li>
        </ol>
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Version"/>
        <dwc:CardBody runat="server">
            <dwc:GroupBox runat="server" ID="groupbox1" Title="Version">
                <dwc:InputText runat="server" ID="CurrentVersion" Name="/Globalsettings/System/Version/CurrentVersion" Label="Version" MaxLength="255" />
                <dw:List ID="lstVersions" ShowPaging="false" NoItemsMessage="" ShowTitle="false" ShowCollapseButton="false" runat="server">
                    <Columns>
                        <dw:ListColumn ID="colLimit" Name="Limit" runat="server"/>
                        <dw:ListColumn ID="colMaxAllowed" Name="Max allowed" runat="server" ItemAlign="Center" />
                        <dw:ListColumn ID="colCount" Name="Current count" Width="110" runat="server" ItemAlign="Center" HeaderAlign="Center" />
                        <dw:ListColumn ID="colCanCreate" Name="Editor can create" Width="110" runat="server" ItemAlign="Center"  HeaderAlign="Center"/>
                    </Columns>
                </dw:List>
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>

	<% Translate.GetEditOnlineScript()	%>
</asp:Content>
