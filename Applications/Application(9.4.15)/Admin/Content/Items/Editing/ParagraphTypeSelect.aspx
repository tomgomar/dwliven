<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ParagraphTypeSelect.aspx.vb" Inherits="Dynamicweb.Admin.ParagraphTypeSelect" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <dwc:ScriptLib runat="server" ID="ScriptLib1" />

    <script type="text/javascript" src="/Admin/Content/JsLib/prototype-1.7.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/require.js"></script>
    <script type="text/javascript" src="/Admin/Content/Items/js/Default.js"></script>
    <script type="text/javascript" src="/Admin/Content/Items/js/ParagraphTypeSelect.js"></script>
    <style>
        .large-icon {
            font-size: 64px;
        }

        .paragraphType {
            float: left;
            width: 256px;
            height: 192px;
            overflow: hidden;
            padding: 5px;
            text-align: center;
            cursor: pointer;
        }

            .paragraphType:hover {
                background-color: #f3f3f3;
            }

        .description {
            color: #cccccc;
        }
    </style>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Add Paragraph" />
            <dwc:GroupBox runat="server">
                <div onclick="Dynamicweb.Items.ParagraphTypeSelect.get_current().newParagraph(0);" class="paragraphType" id="tabBlankParagraph" runat="server">
                    <span id="iconSpan" runat="server" class="large-icon"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.FileTextO)%>"></i></span>
                    <div>
                        <dw:TranslateLabel runat="server" Text="Blank paragraph" UseLabel="false" />
                    </div>
                    <div class="description">
                        <small>
                            <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Choose this to create a new blank paragraph" />
                        </small>
                    </div>
                </div>
                <asp:Repeater ID="ItemTypeRepeater" runat="server" EnableViewState="false" OnItemDataBound="ItemTypeRepeater_ItemDataBound">
                    <ItemTemplate>
                        <div onclick="return Dynamicweb.Items.ParagraphTypeSelect.get_current().onParagraphTypeClick('<%#Eval("SystemName")%>');" class="paragraphType">
                            <span id="iconSpan" runat="server" class="large-icon"></span>
                            <div><%#Eval("Name")%></div>
                            <div class="description"><small><%# If(Converter.ToString(Eval("Description")).Length > 0, Eval("Description"), "")%></small></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </dwc:GroupBox>
            <dw:Dialog ID="NewParagraphDialog" runat="server" Title="New paragraph" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" OkAction="Dynamicweb.Items.ParagraphTypeSelect.get_current().newParagraphSubmit(); ">
                <div class="form-group">
                    <label class="control-label" for="ParagraphName">
                        <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Paragraph name" />
                    </label>
                    <div class="form-group-input">
                        <input type="text" runat="server" id="ParagraphName" name="ParagraphName" class="form-control" maxlength="255" />
                        <div id="rowBasedOn" class="m-t-5">
                            <dw:TranslateLabel runat="server" Text="Based on" />
                            <label id="ChosenTemplateName"></label>
                        </div>
                    </div>
                </div>
            </dw:Dialog>

            <div class="center-block" id="MessageBlock" visible="False" runat="server">
                <div class="centered text-center">
                    <span class="label">
                        <dw:TranslateLabel Text="No content is available." runat="server" />
                    </span>
                </div>
            </div>

            <dw:Overlay ID="ribbonOverlay" runat="server"></dw:Overlay>

            <script type="text/javascript">
                Dynamicweb.Items.ParagraphTypeSelect.get_current().set_pageId(<%=Converter.ToInt32(Dynamicweb.Context.Current.Request("PageID")) %>);
                Dynamicweb.Items.ParagraphTypeSelect.get_current().set_parentPageId(<%=Converter.ToInt32(Dynamicweb.Context.Current.Request("ParentPageID")) %>);
                Dynamicweb.Items.ParagraphTypeSelect.get_current().set_areaId(<%=Converter.ToInt32(Dynamicweb.Context.Current.Request("AreaID"))%>);
                Dynamicweb.Items.ParagraphTypeSelect.get_current().set_container("<%=Dynamicweb.Context.Current.Request("container")%>");
                Dynamicweb.Items.ParagraphTypeSelect.get_current().set_sortDirection("<%=Dynamicweb.Context.Current.Request("ParagraphSortDirection")%>");
                Dynamicweb.Items.ParagraphTypeSelect.get_current().set_paragraphSortID("<%=Dynamicweb.Context.Current.Request("ParagraphSortID")%>");
                Dynamicweb.Items.ParagraphTypeSelect.get_current().get_terminology()['SpecifyParagraphName'] = '<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>';
                Dynamicweb.Items.ParagraphTypeSelect.get_current().get_terminology()['ItemType'] = '<%=Translate.JsTranslate("item type")%>';
                Dynamicweb.Items.ParagraphTypeSelect.get_current().initialize();
            </script>

        </dwc:Card>

    </div>
</body>

<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
