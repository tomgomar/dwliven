<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="EcomProductCategory_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomProductCategory_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>  
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />

    <script type="text/javascript" src="/Admin/FormValidation.js"></script>
    <script type="text/javascript">

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus(); 
            dwGrid_FieldsGrid.onRowAddedCompleted = function(row) {
                var arr = row.element.querySelectorAll(".hide-field-if-empty input[type=checkbox]");
                var propCtrl = document.getElementById("ProductProperties");
                productPropertiesChanged(propCtrl, arr);
            };
        });

        function showUsage() {
            dialog.show("UsageDialog");
        }

        function checkUsage() {
            if (<%= UsageCount %> > 0 ) {
                    dialog.show("DeleteDialog");
                }
                else {
                    if (confirm('<%= Translate.JsTranslate("Do you want delete category?") %>')) {
                        document.getElementById('Form1').DeleteButton.click(); 
                    }
                }
            }

            var selectedRow = null;
            function editField(link) {
                selectedRow = dwGrid_FieldsGrid.findContainingRow(link);

                if (selectedRow) {
                    var fieldName = selectedRow.findControl('Name').value
                    var fieldTag = selectedRow.findControl('TemplateTag').value;
                    var fieldType = selectedRow.findControl('Type').value;
                    var fieldTypeLock = selectedRow.findControl('Type').disabled ? "True" : "False";
                    var fieldDefault = selectedRow.findControl('DefaultValue').value;
                    var presentation = selectedRow.findControl('Presentation').value;
                    var fieldOptions = selectedRow.findControl('Options').value;
                        
                    var sessionTicket;
                    new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/edit/EcomProductCategory_Edit.aspx", {
                        asynchronous: false,
                        method: 'post',
                        parameters: {AjaxCmd: 'StoreOptions', Options: fieldOptions},
                        onSuccess: function (request) {
                            sessionTicket = request.responseText;
                        }
                    });

                    var contentURL = "/Admin/Module/eCom_Catalog/dw7/edit/EcomProductCategoryField_Edit.aspx?catfldName=".concat(fieldName, "&catfldTag=", fieldTag, "&catfldType=", fieldType, "&catfldTypeLock=", fieldTypeLock, "&catfldDefault=", fieldDefault, "&catfldPresentation=", presentation, "&catfldOptions=", sessionTicket);
                    dialog.show("FieldEditDialog", contentURL);
                }
            }

            //  If returns by OK from 'Edit field' dialog
            function OnFieldEditOk() {
                if (selectedRow)
                {
                    var frame = document.getElementById("FieldEditDialogFrame");
                    var wnd = frame.window || frame.contentWindow;
                    // Remove any error messages
                    removeErrorMsgs( wnd.document );

                    var txtName = wnd.document.getElementById('NameStr');
                    var txtTag = wnd.document.getElementById('TemplateNameStr');
                    var txtType = wnd.document.getElementById('ddTypes'); 
                    var chkDefault = wnd.document.getElementById('chkDefaultValue');
                    var txtPresentation = wnd.document.getElementById('ddPresentations');
                    var txtUniqueValues = (typeof(wnd.CheckUniquenessOfValues) == "function") ? wnd.CheckUniquenessOfValues() : "";
                    var txtOptions = "";
                    var errorMessages = "";
                    var htmlErrorMessages = "";
                    var rowsCount = wnd.document.getElementById('optionsList_optionsGrid').rows.length;
                    try{ 
                        txtOptions = getOptions( wnd.document ); 
                    }
                    catch(err){
                        errorMessages = err;
                        htmlErrorMessages = err;
                    }
                    if (txtName.value == ''){
                        wnd.document.getElementById('errNameStr').innerHTML = '<%=Translate.JsTranslate("A name is needed")%>';
                    }
                    if (txtTag.value == ''){
                        wnd.document.getElementById('errTemplateNameStr').innerHTML = '<%=Translate.JsTranslate("A templatetag-name is needed")%>';
                    }
                    if (txtUniqueValues != ""){
                        if (errorMessages != "")
                        {
                            errorMessages += "\n";
                            htmlErrorMessages += "<br />";
                        }
                        errorMessages += txtUniqueValues;
                        htmlErrorMessages += txtUniqueValues;
                    }

                    if (errorMessages != "") {
                        wnd.document.getElementById('errFieldOptions').innerHTML = htmlErrorMessages;
                        if (rowsCount > 12) {
                            alert(errorMessages);
                        }
                    }
                    else
                    {
                        selectedRow.findControl('Name').value = txtName.value;
                        selectedRow.findControl('TemplateTag').value = txtTag.value;
                        selectedRow.findControl('Type').value = txtType.value;
                        selectedRow.findControl('DefaultValue').value = chkDefault.checked ? "True" : "";
                        selectedRow.findControl('Presentation').value = txtPresentation.value;
                        selectedRow.findControl('Options').value = txtOptions; 

                        dialog.hide("FieldEditDialog");
                    }
                }      
            }

            //  If returns by Cancel from 'Edit field' dialog
            function OnFieldEditCancel() {
                var frame = document.getElementById("FieldEditDialogFrame");
                var w = frame.contentWindow ? frame.contentWindow : frame.window;
                frame.writeAttribute('src', '');
                w.location.reload();
                dialog.hide("FieldEditDialog");
            }

            function removeErrorMsgs( dlg ) {
                try {
                    dlg.getElementById('errNameStr').innerHTML = '';
                    dlg.getElementById('errTemplateNameStr').innerHTML = '';
                    dlg.getElementById('errFieldOptions').innerHTML = '';
                } catch(ex) {}
            }

            // Make option string from grid control
            function getOptions( dlg ) {
                var strOptions = '<Options>';  
                var optionRows = dlg.getElementById('optionsList_optionsGrid').rows;

                if (optionRows){
                    for (var i = 2; i < optionRows.length - 1; i++) 
                    {
                        var oName = dlg.getElementById( optionRows[i].id + '_txName').value;
                        var oValue = dlg.getElementById( optionRows[i].id + '_txValue').value;
                        var oDisabled = dlg.getElementById( optionRows[i].id + '_txValue').disabled;
                        var oDefault = dlg.getElementById( 'chkDefault' + (parseInt(optionRows[i].getAttribute("__rowid")) - 1).toString()).checked ? 'True' : '';

                        if (!oName) throw '<%= Translate.Translate("Empty field option name")%>';
                        
                        if (oValue && oValue.match(/[^a-z0-9_]+/i) && !oDisabled){
                            throw '<%= Translate.Translate("Option value could contain only a-z, 0-9 characters")%>';
                        }

                        var strOption = '<Option '.concat(
                            'Name = "', encodeAttribute(oName), '" ',
                            'Value = "', escape(oValue), '" ',
                            'Default = "', oDefault, '" ',
                            ' />' );
                        strOptions = strOptions.concat( strOption ); 
                    }
                }
                strOptions = strOptions.concat( '</Options>' ); 
                
                return strOptions;
            }

            function encodeAttribute(attribute) {
                return attribute.replace(/&/g, '&amp;')
                           .replace(/</g, '&lt;')
                           .replace(/>/g, '&gt;')
                           .replace(/"/g, '&quot;')
                           .replace(/'/g, '&apos;');
            };
           
            //  Delete row
            function delField(link) {
                var row = dwGrid_FieldsGrid.findContainingRow(link);

                if (row) {
                    if (confirm('<%= Translate.JsTranslate("Do you want delete field?") %>' )) {
                        dwGrid_FieldsGrid.deleteRows([row]);
                        if (row.findControl('Type').disabled){
                            dwGrid_FieldsGrid.footerRow.element.stopObserving('click');
                            $('FieldsGrid_footerText').innerHTML = '<%= Translate.JsTranslate("Save product category before adding new fields")%>';
                        }
                    }
                }
            }

            function setSystemName(fromObject, toObject) {
                var nameBox;
                var sysNameBox;
                if (typeof(fromObject) == 'string' && typeof(toObject) == 'object') {
                    nameBox = dwGrid_FieldsGrid.findContainingRow(toObject).findControl(fromObject);
                    sysNameBox = toObject;
                }else if (typeof(fromObject) == 'object' && typeof(toObject) == 'string') {
                    nameBox = fromObject;
                    sysNameBox = dwGrid_FieldsGrid.findContainingRow(fromObject).findControl(toObject);
                }else if (typeof(fromObject) == 'object' && typeof(toObject) == 'object') {
                    nameBox = fromObject;
                    sysNameBox = toObject;
                }else {return;}

                var sysName;
                if ($F(sysNameBox).strip().empty()) {
                    sysName = $F(nameBox);
                }else{
                    sysName = $F(sysNameBox);
                }
                sysNameBox.value = sysName.strip().replace(/\s+/g, "_").replace(/[^a-zA-Z0-9_]+/g, "");
            }

            function validateEditType(obj, spanID) {
                var spanObj = dwGrid_FieldsGrid.findContainingRow(obj).findControl(spanID);
                spanObj.style.visibility = (obj.options[obj.selectedIndex].value == "15") ? "visible" : "hidden";
            }
            function save(close) {
                document.getElementById("Close").value = close ? 1 : 0;
                document.getElementById('Form1').SaveButton.click();
            }

            function productPropertiesChanged(ctrl, arr) {
                if (!arr) {
                    arr = document.querySelectorAll(".hide-field-if-empty input[type=checkbox]");
                }
                for (var i = 0; i < arr.length; i++) {
                    arr[i].checked = ctrl.checked;
                    arr[i].disabled = ctrl.checked;
                }
            }
    </script>

</head>
<body class="area-pink screen-container">
    <div class="card">
        <asp:Literal ID="BoxStart" runat="server"></asp:Literal>
        <form id="Form1" method="post" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            <asp:Literal ID="TableIsBlocked" runat="server"></asp:Literal>
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn" />
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="std" runat="server" onblur="setSystemName(this, $('SystemNameStr'));" />
                            <small class="help-block error" id="errNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelSystemName" runat="server" Text="Systemnavn" />
                        </td>
                        <td>
                            <asp:TextBox ID="SystemNameStr" CssClass="std" runat="server" onblur="setSystemName($('NameStr'), this);" />
                            <small class="help-block error" id="errSystemNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelProductProperties" runat="server" Text="Product property" />
                        </td>
                        <td>
                            <dwc:CheckBox runat="server" ID="ProductProperties" Indent="false" OnClick="productPropertiesChanged(this)" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Fields">
                <dw:EditableGrid runat="server" ID="FieldsGrid">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="Name" Text="" CssClass="std" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="SystemName" Text="" CssClass="std" />
                                <asp:HiddenField runat="server" ID="SystemNameHidden" Value="" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TemplateTag" Text="" CssClass="std" />
                                <asp:HiddenField runat="server" ID="TemplateTagHidden" Value="" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-CssClass="hide-field-if-empty">
                            <ItemTemplate>
                                <dwc:CheckBox runat="server" ID="HideEmpty" CssClass="std" Indent="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <dwc:CheckBox runat="server" ID="DoNotRender" CssClass="std"  Indent="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:DropDownList runat="server" ID="Type" CssClass="NewUIinput" Width="190">
                                </asp:DropDownList>
                                <asp:HiddenField runat="server" ID="TypeHidden" Value="" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <div id="ErrorMessage" runat="server" style="color: Red;"></div>
                                <input runat="server" id="DefaultValue" type="hidden" />
                                <input runat="server" id="Presentation" type="hidden" />
                                <input runat="server" id="Options" type="hidden" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="20px">
                            <ItemTemplate>
                                <a href="javascript:void(0);" onclick="javascript:editField(this);" runat="server" id="EditImage">
                                    <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Pencil) %>" title="<%= Translate.Translate("Edit")%>""></i>
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="20px">
                            <ItemTemplate>
                                <a href="javascript:void(0);" onclick="javascript:delField(this);">
                                    <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Remove) %>" title="<%= Translate.Translate("Delete")%>""></i>
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </dw:EditableGrid>
            </dwc:GroupBox>

            <asp:Button ID="SaveButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
            <asp:HiddenField runat="server" ID="hiddenCategoryID" Value="" />

            <dw:Dialog runat="server" ID="UsageDialog" OkAction="dialog.hide('UsageDialog');" ShowCancelButton="false" ShowClose="false" ShowOkButton="true" Title="Usage" TranslateTitle="true">
                <div>
                    <asp:Literal runat="server" ID="UsageContent" />
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="DeleteDialog" OkAction="dialog.hide('DeleteDialog');" ShowCancelButton="false" ShowClose="false" ShowOkButton="true" Title="Cannot delete" TranslateTitle="true">
                <div>
                    <asp:Literal runat="server" ID="DeleteContent" />
                </div>
            </dw:Dialog>

            <dw:Dialog ID="FieldEditDialog" runat="server" Title="Edit field" HidePadding="true" ShowOkButton="true" ShowCancelButton="true"
                ShowClose="true" OkAction="OnFieldEditOk();" CancelAction="OnFieldEditCancel();">
                <iframe id="FieldEditDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

        </form>
    </div>
    <asp:Literal ID="BoxEnd" runat="server"></asp:Literal>

    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        addRegExRestriction('SystemNameStr', '^[a-zA-Z]+[a-zA-Z0-9_]*$', '<%=Translate.JsTranslate("System name is incorrect")%>');
        activateValidation('Form1');
    </script>

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
