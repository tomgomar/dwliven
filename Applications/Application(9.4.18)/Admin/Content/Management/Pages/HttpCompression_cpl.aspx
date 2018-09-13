<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="HttpCompression_cpl.aspx.vb" Inherits="Dynamicweb.Admin.HttpCompression_cpl" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () {
            page.submit();
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Http" DoTranslate="false" />
        <dwc:CardBody runat="server">
            <dwc:GroupBox ID="gbInjection" Title="Http Compression" runat="server">
                <dwc:RadioGroup runat="server" Name="/Globalsettings/System/http/Compression/Type" Label="Type">
                    <dwc:RadioButton runat="server" Label="GZip (Default)" FieldValue="gzip" />
                    <dwc:RadioButton runat="server" Label="Deflate" FieldValue="deflate" />
                    <dwc:RadioButton runat="server" Label="Ingen" FieldValue="none" />
                </dwc:RadioGroup>
                <dwc:CheckBox runat="server" ID="MinifyMarkup" Name="/Globalsettings/Settings/Performance/MinifyMarkup" Value="True" Label="Minify html" Info="Removes spaces and line breaks (^\n|$\s+)" />
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" ID="groupbox1" Title="Settings" DoTranslation="False">
                <dwc:CheckBox runat="server" ID="DoNotIncludeBaseHref" Name="/Globalsettings/Settings/Designs/DoNotIncludeBaseHref" Value="True" Label="Do not add base href" />
                <dwc:CheckBox runat="server" ID="DisableBaseHrefPort" Name="/Globalsettings/System/http/DisableBaseHrefPort" Label="Disable portnumber in base href and Cart redirects" />
                <dwc:CheckBox runat="server" ID="DisablePerformanceComment" Name="/Globalsettings/Settings/DwInclude/DisablePerformanceComment" Value="True" Label="Disable performance comment" DoTranslate="false" />
                <dwc:CheckBox runat="server" ID="AddLastModifiedHeader" Name="/Globalsettings/System/http/AddLastModifiedHeader" Label="Add last modified header" />
                <dwc:CheckBox runat="server" ID="DeactivateBrowserCache" Name="/Globalsettings/Settings/Performance/DeactivateBrowserCache" Value="True" Label="Deaktiver browser cache" />
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" ID="groupbox2" Title="Image handler" DoTranslation="False">
                <dwc:InputNumber runat="server" ID="CacheHours" Name="/Globalsettings/Settings/ImageHandler/CacheHours" Label="Output cache hours" Placeholder="168" Info="Sets cache-control header (max-age=604800) on GetImage.ashx" />
            </dwc:GroupBox>
            
        </dwc:CardBody>
    </dwc:Card>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</asp:Content>
