<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ChannelEdit.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Management.ChannelEdit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>
        <dw:TranslateLabel ID="lbTitle" Text="Edit channel" runat="server" />
    </title>
    <dw:ControlResources IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Module/OMC/js/ChannelEdit.js" />
            <dw:GenericResource Url="/Admin/Validation.js" />
        </Items>
    </dw:ControlResources>

    <asp:Literal ID="addInSelectorScripts" runat="server" />

    <script type="text/javascript">
        Dynamicweb.SMP.ChannelEdit.terminology = {
            ChannelNameRequired: '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Please specify the name of the channel.")%>',
                ProviderRequired: '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Please specify the social media provider.")%>',
                DeleteConfirm: '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Are you sure you want to delete this channel?")%>'
            };

            Dynamicweb.SMP.ChannelEdit.help = function () {
                <%=Dynamicweb.SystemTools.Gui.Help("socialmedia", "modules.omc.smp.channeledit")%>
            };

        document.observe("dom:loaded", function () {
            $('div_Dynamicweb.Content.Social.Adapter_parameters').observe('keydown', function (event) {
                if (event.target.tagName === 'INPUT') {
                    $$('.notification').each(Element.hide);
                }
            });

            $('OuterContainer').observe('keydown', function (event) {
                Dynamicweb.SMP.ChannelEdit.showLeaveConfirmation();
            });

            $('ckChannelActive').observe('click', function (event) {
                Dynamicweb.SMP.ChannelEdit.showLeaveConfirmation();
            });
        });
        
        function beforeChangeChannel() {
            var addInSelectorId = '<%=addInSelector.AddInTypeName & "_AddInTypes"%>';
            var saveButton = document.getElementById("cmdSave");
            var saveAndClosebutton = document.getElementById("cmdSaveAndClose");

            // Check selected value is not "None", cause in this case onAfterUpdateSelection will not called
            if ($(addInSelectorId).value) {
                saveButton.setAttribute("disabled", "disabled");
                saveAndClosebutton.setAttribute("disabled", "disabled");
            }
        }

        function afterChangeChannel() {
            var saveButton = document.getElementById("cmdSave");
            var saveAndClosebutton = document.getElementById("cmdSaveAndClose");
            
            saveButton.removeAttribute("disabled");
            saveAndClosebutton.removeAttribute("disabled");
        }
    </script>

    <style type="text/css">
        fieldset {
            width: auto !important;
        }

        .notification-box-holder .notification {
            display: none;
        }
    </style>
</head>

<body class="area-teal screen-container">
    <div class="card">
        <form id="ChannelForm" runat="server">
            <div class="card-header">
                <h2 class="subtitle">
                    <dw:TranslateLabel ID="lbSetup" Text="Edit channel" runat="server" />
                </h2>
            </div>

            <dw:Toolbar ID="Toolbar" runat="server" ShowEnd="false" ShowStart="false">
                <dw:ToolbarButton ID="cmdSave" runat="server" Disabled="false" Divide="None" Icon="Save" OnClientClick="Dynamicweb.SMP.ChannelEdit.save();" Text="Save" />
                <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Disabled="false" Divide="None" Icon="Save" OnClientClick="Dynamicweb.SMP.ChannelEdit.saveAndClose();" Text="Save and close" />
                <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Icon="Cancel" Text="Cancel" OnClientClick="Dynamicweb.SMP.ChannelEdit.cancel();" />
                <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="Before" Icon="Delete" Text="Delete" OnClientClick="Dynamicweb.SMP.ChannelEdit.deleteChannel();" />
                <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="Before" Icon="Help" Text="Help" OnClientClick="Dynamicweb.SMP.ChannelEdit.help();" />
            </dw:Toolbar>

            <input type="hidden" id="Cmd" value="" runat="server" />

            <dw:StretchedContainer ID="OuterContainer" Scroll="Auto" Stretch="Fill" Anchor="document" runat="server">
                <div style="margin-left: 5px; margin-top: 5px">
                    <div class="notification-box-holder">
                        <div class="notification notification-success">
                            <dw:Infobar ID="infoSuccess" Type="Information" Message="Authorization successful" runat="server" />
                        </div>
                        <div class="notification notification-error">
                            <dw:Infobar ID="infoFailure" Type="Error" Message="The channel is not authorized, please authorize again or change the parameters" runat="server" />
                        </div>
                    </div>

                    <dw:GroupBox ID="gbGeneral" Title="General" runat="server">
                        <table class="tabTable">
                            <tr>
                                <td style="width: 170px;">
                                    <dw:TranslateLabel ID="lbChannelname" Text="Name" runat="server" />
                                </td>
                                <td>
                                    <asp:TextBox ID="txChannelName" CssClass="std" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <asp:CheckBox ID="ckChannelActive" Checked="true" runat="server" ClientIDMode="Static" />
                                    <label for="ckChannelActive">
                                        <dw:TranslateLabel ID="lbChannelActive" Text="Active" runat="server" />
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>

                    <de:AddInSelector ID="addInSelector" runat="server" AddInGroupName="Providers" UseLabelAsName="False" AddInBreakFieldsets="False" 
                        onBeforeUpdateSelection="beforeChangeChannel(this)" onafterUpdateSelection="afterChangeChannel()"
                        AddInShowNothingSelected="true" NoParametersMessage="No provider selected." AddInParameterMargin="5px" AddInTypeName="Dynamicweb.Content.Social.Adapter" />
                </div>
            </dw:StretchedContainer>

            <dw:Overlay ID="WaitSpinner" runat="server"></dw:Overlay>
            <asp:Literal ID="addInSelectorLoadScript" runat="server"></asp:Literal>
        </form>
    </div>

    <% Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
