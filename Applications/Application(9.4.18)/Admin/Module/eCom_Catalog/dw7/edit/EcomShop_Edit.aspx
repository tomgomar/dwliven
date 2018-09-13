<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomShop_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomShopEdit" EnableEventValidation="False" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.Security" %>
<%@ Import Namespace="Dynamicweb.Security.UserManagement" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title>Shops</title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/shopEdit.js" />
            <dw:GenericResource Url="/Admin/FormValidation.js" />
            <dw:GenericResource Url="../images/AjaxAddInParameters.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">
        var _saveId = '<%= SaveButton.ClientID %>'
        var _deleteId = '<%= DeleteButton.ClientID %>'

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('<%=NameStr.ClientID %>').focus();

            addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name needs to be specified")%>');
            activateValidation('Form1');
        });

        function newShop() {
            location.href = 'EcomShop_Edit.aspx?FromPIM=<%=Request("FromPIM")%>';
        }

        function save(doClose) {
            doClose = !!doClose;

            if (document.getElementById('NameStr').value.trim() == '') {
                dwGlobal.showControlErrors('NameStr', '<%= Translate.JsTranslate("Name cannot be empty") %>');
                return;
            }
            
            if (document.getElementById(_deleteId)) {
                document.getElementById(_deleteId).disabled = 'true';
            }

            if (document.getElementById('SaveAndCloseShopButton')) {
                document.getElementById('SaveAndCloseShopButton').disabled = 'true';
            }

            if (document.getElementById('SaveShopButton')) {
                document.getElementById('SaveShopButton').disabled = 'true';
            }

            if (document.getElementById('DeleteShopButton')) {
                document.getElementById('DeleteShopButton').disabled = 'true';
            }

            if (document.getElementById('NewShopButton')) {
                document.getElementById('NewShopButton').disabled = 'true';
            }

            if (document.getElementById('btnResetSortOrder')) {
                document.getElementById('btnResetSortOrder').disabled = 'true';
            }
            
            $('doClose').value = doClose;
            $(_saveId).click();
        }

        function deleteShop() {
            var alertmsg = getAjaxPage("EcomUpdator.aspx?CMD=ShopCheckForGroups&shopID=<%=ShopId%>");
            if (confirm(alertmsg)) {
                $(_deleteId).click();
            }
        }

        function serializeStockLocations() {
            $("StockLocationId").value = SelectionBox.getElementsRightAsArray("StockLocationSelector");

            var rightValues = $('StockLocationSelector_lstRight');
            var selectPicker = $('DdlStockLocation');
            var oldVal = null;

            if (selectPicker.selectedIndex != -1)
                oldVal = selectPicker[selectPicker.selectedIndex].value;

            for (i = selectPicker.options.length - 1; i >= 0; i--)
                selectPicker.remove(i);

            if (rightValues.options.length == 0 || (rightValues.options.length == 1 && rightValues.options[0].value == 'StockLocationSelector_lstRight_no_data'))
                selectPicker.disabled = true;
            else {
                var selIndex = 0;
                selectPicker.disabled = false;
                selectPicker.options[0] = new Option('<%= Translate.Translate("Nothing selected")%>', '0')

                for (i = 0; i < rightValues.length; i++) {
                    if (rightValues.options[i].value != 'StockLocationSelector_lstRight_no_data') {
                        selectPicker.options[i + 1] = new Option(rightValues.options[i].text, rightValues.options[i].value);

                        if (selectPicker.options[i + 1].value == oldVal)
                            selIndex = i + 1;
                    }
                }

                selectPicker.selectedIndex = selIndex;
            }
        }

        function serializeOrderLineFields() {
            $("OrderLineFieldsId").value = SelectionBox.getElementsRightAsArray("OrderLineFieldsSelector");
        }

        function serializeShopLanguages() {
            $("sboxLangsIDs").value = SelectionBox.getElementsRightAsArray('sboxLangs');

            var rArr = $('sboxLangs_lstRight');
            var sel = $('DdlDefLangId');
            var oldVal = null;

            if (sel.selectedIndex != -1)
                oldVal = sel[sel.selectedIndex].value;

            for (i = sel.options.length - 1; i >= 0; i--)
                sel.remove(i);

            if (rArr.options.length == 0 || (rArr.options.length == 1 && rArr.options[0].value == 'sboxLangs_lstRight_no_data'))
                sel.disabled = true;
            else {
                var selIndex = 0;
                sel.disabled = false;

                for (i = 0; i < rArr.length; i++) {

                    if (rArr.options[i].value != 'sboxLangs_lstRight_no_data') {
                        sel.options[i] = new Option(rArr.options[i].text, rArr.options[i].value);

                        if (sel.options[i].value == oldVal)
                            selIndex = i;
                    }
                }

                sel.selectedIndex = selIndex;
            }
        }
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="Form1" method="post" runat="server">
            <input type="hidden" id="doClose" name="doClose" value="" />
            <input type="hidden" id="FromPIM" name="FromPIM" value="" runat="server" />
            <% If Not String.IsNullOrEmpty(Request("ecom7mode")) AndAlso String.Compare(Request("ecom7mode"), "management", True) = 0 Then%>
            <asp:Literal ID="BoxStart" runat="server"></asp:Literal>
            <% Else %>
            <dw:RibbonBar ID="RibbonBar" runat="server">
                <dw:RibbonBarTab ID="RibbonBarTab1" Name="Shop" runat="server">
                    <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">
                        <dw:RibbonBarButton ID="SaveShopButton" Text="Save" Icon="Save" Size="Small" runat="server" OnClientClick="save(false);"></dw:RibbonBarButton>
                        <dw:RibbonBarButton ID="SaveAndCloseShopButton" Text="Save and close" Icon="Save" Size="Small" runat="server" OnClientClick="save(true);"></dw:RibbonBarButton>
                        <dw:RibbonBarButton ID="btnResetSortOrder" Text="Close" Icon="Times" Size="Small" runat="server" EnableServerClick="true"></dw:RibbonBarButton>
                        <dw:RibbonBarButton ID="DeleteShopButton" Text="Delete" Icon="Delete" Size="Small" runat="server" OnClientClick="deleteShop();" Visible="false"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonInsertBarGroup" Name="Insert" runat="server" Visible="false">
                        <dw:RibbonBarButton ID="NewShopButton" Text="New shop" Icon="PlusSquare" Size="Large" runat="server" OnClientClick="newShop();" Visible="false"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>
            <% End If%>
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <dwc:InputText runat="server" ID="NameStr" Label="Navn" MaxLength="255" ValidationMessage="" />
                <dwc:InputText runat="server" ID="IdStr" Label="ID" Disabled="true" />
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel runat="server" ID="TLabelIcon" Text="Ikon"></dw:TranslateLabel>
                    </label>
                    <dw:FileArchive runat="server" ID="IconStr" ShowPreview="True" MaxLength="255" CssClass="std"></dw:FileArchive>
                </div>
                <dwc:CheckBox runat="server" ID="IsDefault" Label="Standard" />
                <dwc:CheckBox runat="server" ID="IsDefaultTmp" Label="Standard" Enabled="false" />
                <dwc:InputText runat="server" ID="CreatedStr" Label="Oprettet" Enabled="false" />
                <dwc:SelectPicker runat="server" ID="OrderflowSelect" Label="Orderflow"></dwc:SelectPicker>
                <%If License.IsModuleAvailable("eCom_MultiShopAdvanced") Then%>
                <dwc:SelectPicker runat="server" ID="StockStateList" Label="Default stock state"></dwc:SelectPicker>
                <%End If%>
                <dwc:SelectPicker runat="server" ID="OrderContextList" Label="Default cart"></dwc:SelectPicker>
                <dw:FileManager Folder="Templates/eCom7/Order" ID="PrintTemplate" Label="Default print template" runat="server" />
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel runat="server" Text="Preview page"></dw:TranslateLabel>
                    </label>
                    <dw:LinkManager runat="server" Name="PrimaryPage" ID="PrimaryPage" DisableParagraphSelector="true" DisableFileArchive="true"  />
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="PIM">
                <dwc:CheckBox runat="server" ID="IsProductWarehouse" Label="Use as PIM Product Warehouse" />
            </dwc:GroupBox>
            <%If License.IsModuleAvailable("eCom_MultiShopAdvanced") Then%>
            <dwc:GroupBox runat="server" Title="Languages" ID="languagesGroupBox">
                <dw:SelectionBox ID="sboxLangs" runat="server" Width="250" Label="Languages" ClientIDMode="Static" />
                <input type="hidden" name="sboxLangsIDs" id="sboxLangsIDs" value="" runat="server" clientidmode="Static" />
                <dwc:SelectPicker runat="server" ID="DdlDefLangId" Label="Default language" ClientIDMode="Static"></dwc:SelectPicker>
            </dwc:GroupBox>
            <%End If%>
            <dwc:GroupBox runat="server" Title="Stock locations" ID="stockLocationsGroupBox">
                <dw:SelectionBox ID="StockLocationSelector" Width="250" Label="Stock locations" runat="server" />
                <input type="hidden" name="StockLocationID" id="StockLocationId" value="" runat="server" clientidmode="Static" />
                <dwc:SelectPicker runat="server" ID="DdlStockLocation" Label="Default stock location" ClientIDMode="Static"></dwc:SelectPicker>
            </dwc:GroupBox>            
            <dwc:GroupBox runat="server" Title="Order notification" ID="orderNotificationGroupBox">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Select the users that should receive order notifications" />
                        </td>
                        <td>
                            <dw:UserSelector runat="server" HideAdmins="true" ID="SubscribersSelector" OnlyBackend="true" Show="Users" NoneSelectedText="Nothing selected"></dw:UserSelector>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Alternative images">
                <div id="PatternsWarningContainer" runat="server" >
                    <dw:Infobar runat="server" Type="Warning" Message="Using search in subfolders option can cause bad performance"></dw:Infobar>
                    <br/>
                </div>
                <dwc:CheckBox ID="UseAlternativeImages" runat="server" Label="Brug alternative billeder" OnClick="backend.toggleUseAltImage(this);" />                
                <div id="AlternativeImageSection" runat="server">
                    <dw:FolderManager ID="ImageFolder" runat="server" Label="Billed mappe"></dw:FolderManager>
                    <dwc:CheckBox ID="ImageSearchInSubfolders" runat="server" Label="Search in subfolders" OnClick="backend.toggleSearchInSubfolders(this);" />   
                    <div class="form-group">
                        <strong><%=Translate.Translate("File name pattern")%></strong>
                    </div>
                    <dwc:InputText runat="server" ID="ImagePatternS" Label="Lille" Value="" />
                    <dwc:InputText runat="server" ID="ImagePatternM" Label="Medium" Value="" />
                    <dwc:InputText runat="server" ID="ImagePatternL" Label="Stor" Value="" />

                    <dw:EditableGrid ID="UserDefinedPatterns" runat="server" AllowAddingRows="true" AllowDeletingRows="true" AddNewRowMessage="Click here to add new row">
                        <Columns>                            
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <dwc:InputText runat="server" ID="PatternName" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-Width="60%" >
                                <ItemTemplate>
                                    <dwc:InputText runat="server" ID="Pattern" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <dwc:InputText runat="server" ID="Width" Min="0" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <dwc:InputText runat="server" ID="Height" Min="0" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="center">
                                <ItemTemplate>
                                    <i ID="RemovePattern" runat="server" class='fa fa-remove color-danger pointer'></i>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </dw:EditableGrid>
                </div>
            </dwc:GroupBox>
            <input type="hidden" id="OrderLineFieldCount" name="OrderLineFieldCount" value="0" />            
            <dwc:GroupBox ID="OrderLineFields" runat="server" Title="Order line fields">
                <dw:SelectionBox ID="OrderLineFieldsSelector" ShowSortRight="false" runat="server" Width="250" Label="Order line fields" ClientIDMode="Static" />
                <input type="hidden" name="OrderLineFieldsId" id="OrderLineFieldsId" value="" runat="server" clientidmode="Static" />
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Indexing">
                <dwc:CheckBox runat="server" ID="BuildProductIndexAfterProductUpdate" Label="Auto build index when products update" />
                <div class="form-group">
                    <label class="control-label"><%= Translate.Translate("Index") %></label>
    	            <div class="form-group-input">
                        <dw:GroupDropDownList runat="server" ID="ProductIndex" CssClass="selectpicker" Label=""></dw:GroupDropDownList>
	                </div>
                </div>                
            </dwc:GroupBox>
            <dwc:GroupBox ID="ImagesGroupBox" runat="server" Title="Images" Visible="False">
                <dw:FolderManager ID="ImagesUploadFolder" runat="server" Label="Upload folder"></dw:FolderManager>
                <dwc:CheckBox runat="server" ID="CreateSubFoldersForProductImages" Label="Auto-create subfolders from Product Number" />
            </dwc:GroupBox>
            <asp:Button ID="SaveButton" Style="display: none" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" runat="server"></asp:Button>
        </form>
        <% If Not String.IsNullOrEmpty(Request("ecom7mode")) AndAlso String.Compare(Request("ecom7mode"), "management", True) = 0 Then%>
        <asp:Literal ID="BoxEnd" runat="server"></asp:Literal>
        <asp:Literal ID="RemoveDelete" runat="server"></asp:Literal>
        <% End If%>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
