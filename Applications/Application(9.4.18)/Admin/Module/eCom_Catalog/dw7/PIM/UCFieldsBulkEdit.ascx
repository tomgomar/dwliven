<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UCFieldsBulkEdit.ascx.vb" Inherits="Dynamicweb.Admin.UCFieldsBulkEdit" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>


<dwc:GroupBox runat="server">
    <dwc:CheckBoxGroup ID="MultiEditLanguages" runat="server" Label="Languages"></dwc:CheckBoxGroup>
</dwc:GroupBox>
<dwc:GroupBox runat="server" ID="VariantsTreeGroupbox" Visible="False">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Affected Products" />
            </td>
            <td>
                <div id="ProductsTree" runat="server" class="variant-selection-tree"></div>
            </td>
        </tr>
    </table>
</dwc:GroupBox>
<dwc:GroupBox runat="server">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Fields" />
            </td>
            <td>
                <div style="display: none">
                    <%--
                            INFO: Don't remove it! this is initial ckeeditor initialization to support editor from editablegrid
                    --%>
                    <dw:Editor runat="server" ID="DontRemoveIt1" />
                    <dw:DateSelector id="DontRemoveItToo2" IncludeTime="true" runat="server" />
                    <dw:FileManager runat="server" ID="DontRemoveItToo3" AllowBrowse="true" />
                </div>
                <dw:EditableGrid runat="server" ID="FieldsGrid" AllowAddingRows="true" AllowDeletingRows="true" NoRowsMessage="No Fields">
                    <Columns>
                        <asp:TemplateField ItemStyle-CssClass="multi-edit-field-selector-column" ItemStyle-Width="25%" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <dwc:SelectPicker runat="server" ID="Fields"></dwc:SelectPicker>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-CssClass="multi-edit-field-selector-column">
                            <ItemTemplate>
                                <dwc:InputText runat="server" ID="TextFieldEditor" />
                                <dwc:InputTextArea runat="server" ID="TextLongFieldEditor" Rows="5" />
                                <dw:Editor runat="server" ID="EditorTextFieldEditor" Height="200" />

                                <dwc:SelectPicker runat="server" ID="SelectFieldEditor" />
                                <dwc:SelectPicker Multiple="True" DropdownSize="15" CssClass="multiple-list" runat="server" ID="MultiSelectListFieldEditor" />
                                <dwc:SelectPicker runat="server" ID="RadioButtonListFieldEditor" />
                                <dwc:SelectPicker Multiple="True" DropdownSize="15" CssClass="multiple-list" runat="server" ID="CheckBoxListFieldEditor" />

                                <dwc:CheckBox runat="server" ID="BoolFieldEditor" />
                                <dwc:CheckBox runat="server" ID="CheckBoxFieldEditor" />

                                <dwc:InputNumber runat="server" ID="IntegerFieldEditor" IncrementSize="1" ClientIDMode="Static" />
                                <dwc:InputNumber runat="server" ID="DoubleFieldEditor" IncrementSize="0.01" ClientIDMode="Static" />

                                <dw:FileManager runat="server" ID="FilemanagerFieldEditor" AllowBrowse="true" FullPath="false" Folder="Images" />
                                <dw:LinkManager runat="server" ID="LinkFieldEditor" />
                                <div class="form-group">
                                    <div class="form-group-input">
                                        <dw:GroupDropDownList runat="server" Id="GroupDropDownListFieldEditor" CssClass="selectpicker" />
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-CssClass="multi-edit-remove-row-column" ItemStyle-Width="75px" ItemStyle-VerticalAlign="Top" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <div style="padding-top: 8px;">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove) %>" onclick="dwGrid_FieldsGrid.deleteRows([dwGrid_FieldsGrid.findContainingRow(this)]);"></i>
                                    <div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </dw:EditableGrid>
            </td>
        </tr>
    </table>
</dwc:GroupBox>
