<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Optimize.aspx.vb" Inherits="Dynamicweb.Admin.Optimize" ValidateRequest="false" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
	<title></title>
	<dw:ControlResources ID="ControlResources1" runat="server">
	</dw:ControlResources>
	
	<link href="/Admin/Module/eCom_Catalog/dw7/css/Optimize.css" rel="stylesheet" text="text/css" />
	<script src="Optimize.js" type="text/javascript"></script>	

    <script type="text/javascript">
            function help() {
            <%=Dynamicweb.SystemTools.Gui.Help("page.optimizeexpress")%>
        }
    </script>
</head>
<body onload="init();">
<div id="savejs" runat="server" visible="false">
<script type="text/javascript">
	var reloadLocation = parent.location.toString();
	parent.location = reloadLocation;
	try{
		parent.optimizeExpressHide();
	}
	catch (err) {
	}
</script>
</div>
    <form id="form1" runat="server" enableviewstate="false" method="post">
    <input type="hidden" name="save" value="true" />
    <input type="hidden" name="phrase" value="<%=Dynamicweb.Context.Current.Request("phrase")%>" />
    <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowStart="false">
			<dw:ToolbarButton ID="ToolbarButton1" runat="server" Icon="Save" Text="Gem" OnClientClick="document.forms.form1.submit();">
			</dw:ToolbarButton>
			<dw:ToolbarButton ID="ToolbarButton2" runat="server" Icon="Cancel" Text="Annuller" OnClientClick="parent.optimizeExpressHide();">
			</dw:ToolbarButton>
			<dw:ToolbarButton ID="ToolbarButton3" runat="server" Divide="Before" Icon="Refresh" Text="Reset" OnClientClick="location = location;">
			</dw:ToolbarButton>
			<dw:ToolbarButton ID="ToolbarButton4" runat="server" Icon="Exchange" Text="Change phrase" OnClientClick="choosePhrase();">
			</dw:ToolbarButton>
			<dw:ToolbarButton ID="cmdHelp" Icon="Help" Divide="Before" Text="Help" OnClientClick="help();" runat="server" />
		</dw:Toolbar>
		<h2 class="subtitle">
			<dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Phrase" />: &laquo;<%=Dynamicweb.Context.Current.Request("phrase")%>&raquo;</h2>
    
    <div class="optimize-results">
        <div id="myContentContainer" class="optimize-results-fields" runat="server">
        </div>
        
        <div class="optimize-results-summary">
            <table border="0" width="100%" cellspacing="0" cellpadding="0">
                <tr>
                    <td id="elmctn_0" class="optimize-summary-fieldrow" onclick="enable(0);">
                        <table border="0" width="100%" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>
                                    <div class="optimize-summary-fieldtitle">
                                        <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="URL" />
                                    </div>
                                    
                                    <div id="value_0" class="optimize-summary-fieldvalue">
                                    </div>
                                </td>
                                <td align="right" width="16">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Warning, true, KnownColor.Warning) %>" title="Warning" id="iconWarning2_0"></i>
		                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.CheckCircleO, true, KnownColor.Success) %>" title="Ok" id="iconOk2_0"></i>
		                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.TimesCircleO, true, KnownColor.Danger) %>" title="Error" id="iconErr2_0"></i>
                                </td>
                            </tr>
                         </table>
                    </td>
                </tr>
                <tr>
                    <td id="elmctn_1" class="optimize-summary-fieldrow" onclick="enable(1);">
                        <table border="0" width="100%" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>
                                    <div class="optimize-summary-fieldtitle">
                                        <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Titel" />
                                    </div>
                                    
                                    <div id="value_1" class="optimize-summary-fieldvalue">
                                    </div>
                                </td>
                                <td align="right" width="16">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Warning, true, KnownColor.Warning) %>" title="Warning" id="iconWarning2_1"></i>
		                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.CheckCircleO, true, KnownColor.Success) %>" title="Ok" id="iconOk2_1"></i>
		                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.TimesCircleO, true, KnownColor.Danger) %>" title="Error" id="iconErr2_1"></i>
                                </td>
                            </tr>
                         </table>
                    </td>
                </tr>
                <tr>
                    <td id="elmctn_2" class="optimize-summary-fieldrow" onclick="enable(2);">
                        <table border="0" width="100%" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>
                                    <div class="optimize-summary-fieldtitle">
                                        <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Overskrift" />
                                    </div>
                                    
                                    <div id="value_2" class="optimize-summary-fieldvalue">
                                    </div>
                                </td>
                                <td align="right" width="16">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Warning, true, KnownColor.Warning) %>" title="Warning" id="iconWarning2_2"></i>
		                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.CheckCircleO, true, KnownColor.Success) %>" title="Ok" id="iconOk2_2"></i>
		                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.TimesCircleO, true, KnownColor.Danger) %>" title="Error" id="iconErr2_2"></i>
                                </td>
                            </tr>
                         </table>
                    </td>
                </tr>
                <tr>
                    <td id="elmctn_3" class="optimize-summary-fieldrow" onclick="enable(3);">
                        <table border="0" width="100%" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>
                                    <div class="optimize-summary-fieldtitle">
                                        <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Keywords" />
                                    </div>
                                    
                                    <div id="value_3" class="optimize-summary-fieldvalue">
                                    </div>
                                </td>
                                <td align="right" width="16">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Warning, true, KnownColor.Warning) %>" title="Warning" id="iconWarning2_3"></i>
		                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.CheckCircleO, true, KnownColor.Success) %>" title="Ok" id="iconOk2_3"></i>
		                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.TimesCircleO, true, KnownColor.Danger) %>" title="Error" id="iconErr2_3"></i>
                                </td>
                            </tr>
                         </table>
                    </td>
                </tr>
                <tr>
                    <td id="elmctn_4" class="optimize-summary-fieldrow" onclick="enable(4);">
                        <table border="0" width="100%" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>
                                    <div class="optimize-summary-fieldtitle">
                                        <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Beskrivelse" />
                                    </div>
                                    
                                    <div id="value_4" class="optimize-summary-fieldvalue">
                                    </div>
                                </td>
                                <td align="right" width="16">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Warning, true, KnownColor.Warning) %>" title="Warning" id="iconWarning2_4"></i>
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.CheckCircleO, true, KnownColor.Success) %>" title="Ok" id="iconOk2_4"></i>
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.TimesCircleO, true, KnownColor.Danger) %>" title="Error" id="iconErr2_4"></i>
                                </td>
                            </tr>
                         </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div id="divProgress" class="optimize-progress">
                            <div>
                                <span id="percent">56%</span>&nbsp;<dw:TranslateLabel ID="lbComplete" Text="complete" runat="server" />
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    
    <span id="spNoContent" style="display: none">(<dw:TranslateLabel id="lbNoContent" Text="No content" runat="server" />)</span>
    
    <script type="text/javascript">
        validateAll();
        </script>
    </form>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
