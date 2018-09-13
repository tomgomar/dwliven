<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditWorkflow.aspx.vb" Inherits="Dynamicweb.Admin.EditWorkflow" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
        </Items>
    </dw:ControlResources>
    <script>
        function createEditWorkflowPage(opts) {
            var options = opts;
            var workflowNameEl = document.getElementById(options.ids.name);
            var workflowNameIni = workflowNameEl.value;
            var hasValue = function (el) {
                return !!el.value;
            };
            var validate = function () {
                if (!hasValue(workflowNameEl)) {
                    dwGlobal.showControlErrors(workflowNameEl, options.labels.emptyName);
                    workflowNameEl.focus();
                    return false;
                }
                return true;
            };

            var obj = {
                init: function (opts) {
                    this.options = opts;
                    this.deletedStatesIds = [];
                    dwGrid_StatesList.onRowAdding = this.editState.bind(this);
                    dwGrid_StatesList.onRowsDeletedCompleted = this._deleteState.bind(this);
                },

                editState: function (evt, stateId) {
                    if (this._hasChangesOnPage()) {
                        Action.Execute(this.options.actions.confirmSaveToStateEdit, { WorkflowId: this.options.workflowId, StateId: stateId });
                    }
                    else {
                        Action.Execute(this.options.actions.stateEdit, { WorkflowId: this.options.workflowId, StateId: stateId });
                    }
                    return true;
                },

                _deleteState: function (rows) {
                    for (var i = 0; i < rows.length; i++) {
                        this.deletedStatesIds.push(rows[i].element.getAttribute("ItemId"));
                    }
                },

                _hasChangesOnPage: function() {
                    return this.options.workflowId < 1 || this.deletedStatesIds.length || workflowNameIni !== workflowNameEl.value;
                },

                save: function(close, redirectToEditState) {
                    if (validate()) {
                        if (close) {
                            document.getElementById('RedirectTo').value = typeof (redirectToEditState) == "undefined" ? "list" : redirectToEditState;
                        }
                        var deletedStatesEl = document.getElementById('DeletedStates');
                        deletedStatesEl.value = this.deletedStatesIds.join();
                        var cmd = document.getElementById('cmdSubmit');
                        cmd.value = "Save";
                        cmd.click();
                    }
                },

                saveBeforeEditState: function () {
                    this.save(true, 0)
                },

                cancel: function () {
                    Action.Execute(this.options.actions.list);
                },

                deleteStatesListRows: function (evt, el) {
                    evt.stopPropagation();
                    dwGrid_StatesList.deleteRows([dwGrid_StatesList.findContainingRow(el)]);
                }
            };
            obj.init(opts);
            return obj;
        }
    </script>
    <style type="text/css">
        .state-id-column {
            width: 40px;
            text-align: center !important;
        }
        .state-remove-row-column {
            width: 50px;
            text-align: center !important;
        }
    </style>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Edit workflow" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(close);" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="TimesCircle" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
                </dw:Toolbar>
                <dwc:CardBody runat="server">
                    <dwc:GroupBox ID="gbSettings" Title="Workflow settings" runat="server">
                        <dwc:InputText ID="WorkflowName" runat="server" Label="Workflow name" ValidationMessage="" />
                        <div class="form-group">
                            <label class="control-label">Workflow states</label>
                            <div class="form-group-input">
                                <dw:EditableGrid runat="server" ID="StatesList" AllowAddingRows="true" AllowDeletingRows="true" NoRowsMessage="No States" AddNewRowMessage="Add new workflow state" RowStyle-CssClass="pointer" >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Name" ItemStyle-CssClass="state-name-column">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="StateName" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Available states" ItemStyle-CssClass="available-states-column">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="AvailableStates" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Delete" ItemStyle-CssClass="row-delete state-remove-row-column" HeaderStyle-CssClass="state-remove-row-column">
                                            <ItemTemplate>
                                                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove) %>" onclick="currentPage.deleteStatesListRows(event, this);"></i>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </dw:EditableGrid>
                            </div>
                        </div>
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
            <input type="hidden" id="RedirectTo" name="RedirectTo" value="" />
            <input type="hidden" id="DeletedStates" name="DeletedStates" value="" />
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>

