<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="EmailTypeSelect.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.EmailTypeSelect" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dw:Overlay ID="ribbonOverlay" runat="server" Message="" ShowWaitAnimation="True" />
        <dwc:CardHeader runat="server" DoTranslate="true" Title="New email" />
        <dwc:CardBody runat="server">
            <dwc:GroupBox Title="Choose email type" runat="server">
				<div class="newPage" onclick="EmailTypeSelect.newBlankEmail('<%=TopFolderSubject %>');">
					<span class="large-icon page-type-select-icon">
                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Email)%>"></i>
                    </span>
					<span class="page-type-select-btn-center">
						<a class="btn btn-link waves-effect waves-button" href="#" id="TemplateName0">
                            <dw:TranslateLabel runat="server" Text="Blank e-mail" />
						</a>
					</span>
                    <div class="description-text">
						<dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Choose this to create a new blank e-mail and select an already created page to send" />
                    </div>
				</div>
            </dwc:GroupBox>

            <div class="columns">
                <div id="colPageTemplates" class="column" runat="server">
                    <dwc:GroupBox runat="server" Title="E-mail templates">
	                    <asp:Repeater ID="TemplatesRepeater" runat="server" EnableViewState="false">		            
                            <ItemTemplate>
                                <div class="clearfix" onclick="EmailTypeSelect.newTemplateBasedEmail(<%#Eval("Id")%>, '<%#Eval("Subject")%>');">
                                    <span class="large-icon page-type-select-icon">
                                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Email)%>"></i>
                                    </span>
                                    <span class="page-type-select-btn-center">
                                        <a class="btn btn-link waves-effect waves-button" href="#" id='<%#Eval("Id")%>'>
                                            <%#Eval("TemplateName")%>
                                        </a>
                                    </span>
                                    <div class="description-text">
                                        <%#Eval("Subject")%>
                                        <br />
                                        <%#Eval("TemplateDescription")%>
                                    </div>
                                </div>
                            </ItemTemplate>		            
	                    </asp:Repeater>
                    </dwc:GroupBox>
                </div>
	        </div>
        </dwc:CardBody>
        <dwc:CardFooter runat="server">
            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Email)%>"></i>
            <span><dw:TranslateLabel runat="server" Text="Skabeloner" />:&nbsp;</span> 
            <span id="TemplateCount" runat="server"></span>
        </dwc:CardFooter>
    </dwc:Card>
    <input type="hidden" name="templateId" id="templateId" value="" />
    <input type="hidden" name="topFolderId" id="topFolderId" value="<%=TopFolderId%>" />
    <input type="submit" name="cmdSubmit" id="cmdSubmit" style="display: none;" />

    <dw:Dialog ID="NewEmailDialog" runat="server" Title="New e-mail" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" OkAction="EmailTypeSelect.newEmailOk();">
		<table border="0" style="width:350px;">
			<tr>
				<td style="width:100px;"><dw:TranslateLabel runat="server" Text="Subject" /></td>
				<td><input type="text" id="subject" name="subject" class="NewUIinput" maxlength="255" />
				</td>
			</tr>
		</table>
	</dw:Dialog>
</asp:Content>

