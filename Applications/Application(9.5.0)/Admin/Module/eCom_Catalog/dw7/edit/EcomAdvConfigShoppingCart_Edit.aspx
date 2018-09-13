<%@ Page Language="vb" MasterPageFile="/Admin/Content/Management/EntryContent2.Master" AutoEventWireup="false" CodeBehind="EcomAdvConfigShoppingCart_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomAdvConfigShoppingCart_Edit" %>

<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">

    <script type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function () {

            document.getElementById('MainForm').submit();
        }

        page.onHelp = function () {
            <%=Dynamicweb.SystemTools.Gui.help("", "administration.controlpanel.ecom.cart") %>
        }

    	function switchCartOption() {
    		if ($('MergeCartOption').visible()) {
    			$('MergeCartOption').hide();
    			$('MergeAnonymousCartOnLoggingIn').checked = false;
    		}
    		else {
    			$('MergeCartOption').show();
    		}
    	}

    	document.observe('dom:loaded', function () {
    		if ($('UsePreviousCartInsteadOfNewCart').checked) {
    			$('MergeCartOption').show();
    		}
    		else {
    			$('MergeCartOption').hide();
    		}
    	});
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:GroupBox runat="server" Title="Indstillinger">
        <dwc:CheckBox runat="server" Label="Recalculate a user's cart when the user logs in" Name="/Globalsettings/Ecom/Cart/RecalculateOnUserLogin" ID="RecalculateOnUserLogin" Value="True" />
        <dwc:CheckBox runat="server" Label="Skip payment and shipping step if only one method exists" Name="/Globalsettings/Ecom/Cart/SkipMethodStep" ID="SkipMethodStep" Value="True" />
        <dwc:CheckBox runat="server" Label="Skip payment gateway if order amount is 0 or less" Name="/Globalsettings/Ecom/Cart/SkipPaymentGateway" ID="SkipPaymentGateway" Value="True" />
        <dwc:CheckBox runat="server" Label="Enable step validation" Name="/Globalsettings/Ecom/Cart/StepValidate" ID="StepValidate" Value="True" />
        <dwc:CheckBox runat="server" Label="Disable step validation when go back" Name="/Globalsettings/Ecom/Cart/DisableBackStepValidation" ID="DisableBackStepValidation" Value="True" Info="Notice that step validation requires changes to the AcceptCart.html template. Click ´Help´ for further information." />
        <dwc:CheckBox runat="server" Label="Organize orderlines so discounts and taxes are grouped with their parent orderlines" Name="/Globalsettings/Ecom/Cart/OrganizeDiscountAndTaxOrderLines" ID="OrganizeDiscountAndTaxOrderLines" Value="True" />
        <dwc:CheckBox runat="server" Label="Full cart isolation per browser, even for the same user" Name="/Globalsettings/Ecom/Cart/FullCartIsolation" ID="FullCartIsolation" Value="True" />
        <dwc:CheckBox runat="server" Label="Recalculate cart on reordering from Customer Center" Name="/Globalsettings/Ecom/Cart/DontUseFixedOrderLineTypeWhenReordered" ID="DontUseFixedOrderLineTypeWhenReordered" Value="True" />
        <dwc:CheckBox runat="server" Label="Do not delete carts with 0 orderlines" Name="/Globalsettings/Ecom/Cart/DoNotDeleteCartsWithZeroOrderlines" ID="DoNotDeleteCartsWithZeroOrderlines" Value="True" />
    </dwc:GroupBox>
    <dwc:GroupBox runat="server" Title="Extranet">
        <dwc:CheckBox runat="server" Label="Do not replace existing cart when user logs in" Name="/Globalsettings/Ecom/Cart/UsePreviousCartInsteadOfNewCart" ID="UsePreviousCartInsteadOfNewCart" Value="True" OnClick="switchCartOption();" />
        <div id="MergeCartOption">
            <dwc:CheckBox runat="server" Label="Merge the anonymous cart content with the cart saved on the user when logging in" Name="/Globalsettings/Ecom/Cart/MergeAnonymousCartOnLoggingIn" ID="MergeAnonymousCartOnLoggingIn" Value="True" />
        </div>
    </dwc:GroupBox>
    <dwc:GroupBox runat="server" Title="Saved for later">
        <dwc:InputNumber runat="server" Label="Saved for later valid time (days)" Name="/Globalsettings/Ecom/Cart/SavedForLaterValidTime" ID="SavedForLaterValidTime" />
    </dwc:GroupBox>      

    <% Translate.GetEditOnlineScript()%>
</asp:Content>
