<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="LanguageManagement_cpl.aspx.vb" Inherits="Dynamicweb.Admin.LanguageManagement_cpl" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function() {
             document.getElementById('MainForm').submit();
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Header">
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="ContentHeader" Title="Language management" />
        <dwc:CardBody runat="server">
            <dwc:GroupBox runat="server" Title="Language versions">
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/DeactivateParagraphOnNew" Label="Deactivate new paragraphs" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/DeactivatePageOnNew" Label="Deactivate new pages" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/AllowNewParagraphs" Label="Allow paragraph operations (Create, copy, move, delete, sort)" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/AllowGlobalParagraphs" Label="Allow new global paragraphs" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/AllowNewPages" Label="Allow page operations (Create, copy, move, delete, sort)" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/InheritPageChanges" Label="Copy master changes to language versions if values are the same. (Pages)" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/InheritParagraphChanges" Label="Copy master changes to language versions if values are the same. (Paragraph)" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/CompareParagraphAsText" Label="Compare paragraphs as text" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/UseAreaNamesForDropdowns" Label="Use area name in dropdowns instead of area culture name" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/DontCopyPageStateChangesToLangVersion" Label="Make published/unpublished status independent of master" />
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>

		
<% Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</asp:Content>
