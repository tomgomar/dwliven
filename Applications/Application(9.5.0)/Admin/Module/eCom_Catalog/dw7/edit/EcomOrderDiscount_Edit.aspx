﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomOrderDiscount_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomOrderDiscount_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Ecommerce.Extensibility.Controls" Assembly="Dynamicweb.Ecommerce" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />
    <link rel="Stylesheet" type="text/css" href="/Admin/Module/eCom_Catalog/images/ObjectSelector.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Module/eCom_Catalog/dw7/css/ToolTip.css" />
    <script type="text/javascript" src="/Admin/Images/Controls/CustomSelector/CustomSelector.js"></script>
    <script type="text/javascript" src="/Admin/Images/Controls/EditableList/EditableListEditors.js"></script>
    <script type="text/javascript" src="../js/EcomOrderDiscount_Edit.js"></script>
    <script type="text/javascript" src="../images/layermenu.js"></script>
    <script src="/Admin/Resources/js/layout/Actions.js"></script>
    <script type="text/javascript">
        document.observe('dom:loaded', function () {
            Dynamicweb.eCommerce.OrderDiscounts.init();
        });

        function deleteDiscount() {
            var discountIDs = <%= CLng(IIf(Core.Converter.ToString(Request("OrderDiscountID")) <> "", Core.Converter.ToInt32(Request("OrderDiscountID")), 0))%>;
            var act = <%=GetDiscountDeleteAction()%>;
            act.OnSubmitted.Parameters.DiscountID = discountIDs;
            Action.Execute(act);
        }
    </script>
</head>
<body class="area-pink">
    <div class="card">
        <form id="formOrderDiscount_edit" runat="server" defaultfocus="txName">
            <input id="Close" type="hidden" name="Close" value="0" />
            <input type="hidden" name="isCopy" id="isCopy" value="" runat="server" />
            <div class="card-header">
                <h2 class="subtitle"><%=Translate.Translate("Edit discount")%></h2>
            </div>
            <dw:Toolbar ID="MainToolbar" runat="server" ShowEnd="false">
                <dw:ToolbarButton ID="SaveToolbarButton" runat="server" Divide="None" Icon="Save" Text="Save" OnClientClick="Dynamicweb.eCommerce.OrderDiscounts.submit(false);">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="SaveAndCloseToolbarButton" runat="server" Divide="None" Icon="Save" Text="Save and Close" OnClientClick="Dynamicweb.eCommerce.OrderDiscounts.submit(true);">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="DeleteToolbarButton" runat="server" Divide="None" Visible="false" Icon="Delete" Text="Delete" OnClientClick="deleteDiscount();">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="CloseToolbarButton" runat="server" Divide="None" Icon="TimesCircle" Text="Cancel" OnClientClick="Dynamicweb.eCommerce.OrderDiscounts.redirectToList();">
                </dw:ToolbarButton>
            </dw:Toolbar>
            <ecom:LanguageMenu ID="LangMenu" runat="server" MenuID="langMn" OnClientSelect="selectLang" />
            <dw:Infobar runat="server" ID="NotLocalizedInfo" Type="Warning" Message="The order discount is not localized to this language. Save the order discount to localize it." Visible="False" />
            <dw:Infobar runat="server" ID="CopyWarningVoucherListIsClean" Type="Warning" Message="" TranslateMessage="false" Visible="False" />

            <div id="GeneralDiv">
                <dwc:GroupBox Title="General" runat="server">
                    <dwc:InputText ID="txName" runat="server" Label="Name" />
                    <dwc:InputTextArea ID="txDescription" runat="server" Label="Description" />
                    <dwc:InputText runat="server" ID="CampaignName" Label="Campaign name" />
                    <dw:FileManager runat="server" ID="CampaignImage" AllowBrowse="true" Label="Campaign image" Extensions="jpg,gif,png,swf,pdf" CssClass="NewUIinput" FullPath="true" />
                    <dw:ColorSelect runat="server" ID="CampaignColor" Label="Campaign color" />
                    <dwc:CheckBox ID="chkDiscountActive" Name="DiscountActive" runat="server" Label="Active" />
                    <dwc:CheckBox ID="chkDiscountAssignableFromProducts" Name="DiscountAssignableFromProducts" runat="server" Label="Assignable from product catalog" />
                    <dw:DateSelector runat="server" ID="dsValidFrom" IncludeTime="true" Label="Valid From" />
                    <dw:DateSelector runat="server" ID="dsValidTo" IncludeTime="true" Label="Valid To" />
                </dwc:GroupBox>

                <dwc:GroupBox Title="Discount" runat="server">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Apply as" runat="server" />
                                <a class="tooltip">
                                    <i style="cursor: pointer;" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i>
                                    <span>
                                        <strong>Order Discount (Inclusive):</strong><br />
                                        <%=Translate.Translate("This discount will be calculated after all other orderline discounts have been calculated, based on the discounted price.")%><br />
                                        <strong>Order Discount (Exclusive):</strong><br />
                                        <%=Translate.Translate("This discount will be calculated based on the orderprice before any other discounts have been added.")%><br />
                                        <strong>Orderline Discount (Exclusive):</strong><br />
                                        <%=Translate.Translate("This discount will be calculated based on the the product before any other discounts have been added.")%><br />
                                    </span>
                                </a>
                            </td>
                            <td>
                                <dwc:SelectPicker runat="server" ID="ApplyAs"></dwc:SelectPicker>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Discount Type" />
                                <a class="tooltip">
                                    <i style="cursor: pointer;" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i>
                                    <span>
                                        <strong>Amount:</strong><br />
                                        <%=Translate.Translate("Enter a fixed discount sum (e.g. 100) which is subtracted from the price. If the dicount is set to 25 for EURO, then the customer will only get 25 EURO as discount for websites that use EURO as currency.")%>
                                        <br />
                                        <strong>Percentage:</strong><br />
                                        <%=Translate.Translate("Enter a discount percentage. If the discount percentage is set to 50, then the customer will only be charged half the price.")%>
                                        <br />
                                        <strong>Products:</strong><br />
                                        <%=Translate.Translate("Choose one or more products from your product catalog by clicking the Add products icon. When the sales discount is activated then the chosen product(s) will be added to the customer's cart.")%>
                                        <br />
                                        <strong>Free shipping:</strong><br />
                                        <%=Translate.Translate("Choose this if you want to give free shipping if all/selected products are bought.")%>
                                        <br />
                                    </span>
                                </a>
                            </td>
                            <td>
                                <dwc:SelectPicker runat="server" ID="DiscountType"></dwc:SelectPicker>
                            </td>
                        </tr>
                        <tr id="amountDiv" style="display: none;">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Amount" />
                            </td>
                            <td>
                                <omc:FloatingPointNumberSelector ID="numAmount" AllowNegativeValues="false" MinValue="0.00" MaxValue="100000000" runat="server" />
                            </td>
                        </tr>
                        <tr id="currencyDiv" style="display: none;">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Currency" />
                            </td>
                            <td>
                                <select id="orderDiscountCurrency" class="std" name="orderDiscountCurrency">
                                    <asp:Literal ID="ltCurrency" runat="server"></asp:Literal>
                                </select>
                            </td>
                        </tr>
                        <tr id="percentageDiv" style="display: none;">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Percentage" />
                            </td>
                            <td>
                                <omc:FloatingPointNumberSelector ID="numPercentage" AllowNegativeValues="false" MinValue="0.00" MaxValue="100" runat="server" />
                            </td>
                        </tr>
                        <tr id="productDiv" style="display: none;">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Product" />
                            </td>
                            <td>
                                <div class="input-group">
                                    <div class="form-group-input">
                                        <input type="hidden" id="ID_ProductAsDiscount" runat="server" />
                                        <input type="hidden" id="VariantID_ProductAsDiscount" runat="server" />
                                        <input type="text" id="Name_ProductAsDiscount" class="std" runat="server" />
                                    </div>
                                    <span class="input-group-addon" onclick="javascript:Dynamicweb.eCommerce.OrderDiscounts.AddProduct('DW_REPLACE_ProductAsDiscount');" title="<%= Translate.Translate("Add")%>">
                                        <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Plus, True, Core.UI.KnownColor.Success) %>"></i>
                                    </span>
                                    <span class="input-group-addon last" onclick="javascript:Dynamicweb.eCommerce.OrderDiscounts.RemoveProduct('ProductAsDiscount');" title="<%= Translate.Translate("Delete")%>">
                                        <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Remove, True, Core.UI.KnownColor.Danger) %>"></i>
                                    </span>
                                </div>
                            </td>
                        </tr>
                        <tr id="CustomFieldsDiv" style="display: none;">
                            <td>
                                <dw:TranslateLabel Text="Custom Field" runat="server" />
                            </td>
                            <td>
                                <select id="orderDiscountAmountCustomField" class="std" name="orderDiscountAmountCustomField">
                                    <asp:Literal ID="ltCustomFields" runat="server"></asp:Literal>
                                </select>
                            </td>
                        </tr>    
                        <tr id="applyToDiv" style="display: none;">
                            <td>
                                <dw:TranslateLabel Text="Apply to" runat="server" />
                            </td>
                            <td>
                                <dwc:RadioGroup runat="server" Indent="false" Name="ApplyToRadio" SelectedValue="1" ID="ApplyToRadio">
                                    <dwc:RadioButton runat="server" Label="All products" FieldValue="1" /> 
                                    <dwc:RadioButton runat="server" Label="Cheapest product" FieldValue="2" /> 
                                    <dwc:RadioButton runat="server" Label="Most expensive product" FieldValue="3" /> 
                                </dwc:RadioGroup>
                            </td>
                        </tr>                    
                    </table>
                </dwc:GroupBox>
            </div>

            <% If Dynamicweb.Security.UserManagement.License.IsModuleAvailable("UserManagementFrontend") Then%>
            <dwc:GroupBox Title="Users and Groups" runat="server">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="User" runat="server" />
                        </td>
                        <td>
                            <dw:EditableListColumnUserEditor ID="UserID_CustomSelector" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="User group" runat="server" />
                        </td>
                        <td>
                            <dw:EditableListColumnUserEditor ID="UserGroupID_CustomSelector" Select="Group" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Customer number" runat="server" />
                        </td>
                        <td>
                            <dwc:InputText ID="txtCustomerNumber" runat="server" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <%End If%>

            <dwc:GroupBox Title="Total Price" runat="server">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Condition" runat="server" />
                        </td>
                        <td>
                            <select id="orderDiscountPriceCondition" class="std" name="orderDiscountPriceCondition">
                                <asp:Literal ID="ltCondition" runat="server"></asp:Literal>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Total price" runat="server" />
                        </td>
                        <td>
                            <omc:FloatingPointNumberSelector ID="numTotalPrice" AllowNegativeValues="false" MinValue="0.00" MaxValue="100000000" runat="server" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox Title="Product Catalog" runat="server" ClassName="product-catalog">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Shop" runat="server" />
                        </td>
                        <td>
                            <select id="orderDiscountShop" class="std" name="orderDiscountShop">
                                <asp:Literal ID="ltShops" runat="server"></asp:Literal>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Language" runat="server" />
                        </td>
                        <td>
                            <select id="orderDiscountLanguage" class="std" name="orderDiscountLanguage">
                                <asp:Literal ID="ltLanguages" runat="server"></asp:Literal>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Products and groups" runat="server" />
                        </td>
                        <td class="epgs-cnt">
                            <de:ProductsAndGroupsSelector runat="server" ID="IncludedProductsAndGroupsSelector" Value="[some]" ShowAllRadio="false" ShowNoneRadio="False" EnableSubItems="false" ShowQueries="true" CallerForm="formOrderDiscount_edit" Width="168px" Height="60px" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Excluded products and/or groups" runat="server" />
                        </td>
                        <td class="epgs-cnt">
                            <de:ProductsAndGroupsSelector runat="server" ID="ExcludedProductsAndGroupsSelector" Value="[some]" ShowAllRadio="false" ShowNoneRadio="False" EnableSubItems="false" ShowQueries="true" CallerForm="formOrderDiscount_edit" Width="168px" Height="60px" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox Title="Order" runat="server">
                <table class="formsTable">
                    <tr id="OrderContextLine" runat="server">
                        <td>
                            <dw:TranslateLabel Text="Context" runat="server" />
                        </td>
                        <td>
                            <select id="orderContext" class="std" name="orderContext">
                                <asp:Literal ID="ltOrderContext" runat="server"></asp:Literal>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Country" runat="server" />
                        </td>
                        <td>
                            <select id="orderDiscountCountry" class="std" name="orderDiscountCountry">
                                <asp:Literal ID="ltCountry" runat="server"></asp:Literal>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Shipping" runat="server" />
                        </td>
                        <td>
                            <select id="orderDiscountShipping" class="std" name="orderDiscountShipping">
                                <asp:Literal ID="ltShipping" runat="server"></asp:Literal>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Payment" runat="server" />
                        </td>
                        <td>
                            <select id="orderDiscountPayment" class="std" name="orderDiscountPayment">
                                <asp:Literal ID="ltPayment" runat="server"></asp:Literal>
                            </select>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox Title="Product Quantity" runat="server">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Quantifier" runat="server" />
                        </td>
                        <td>
                            <select id="orderDiscountQuantifiery" class="std" name="orderDiscountQuantifier">
                                <asp:Literal ID="ltQuantifier" runat="server"></asp:Literal>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Product Quantity" runat="server" />
                        </td>
                        <td>
                            <omc:FloatingPointNumberSelector ID="numProductQuantity" AllowNegativeValues="false" MinValue="1.00" MaxValue="100000000" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox ID="chApplyDiscountOnce" FieldName="ApplyDiscountOnce" runat="server" />
                            <label for="ApplyDiscountOnce">
                                <dw:TranslateLabel runat="server" Text="Apply discount only once" />
                            </label>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox Title="Fields and Voucher" runat="server">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Order field" runat="server" />
                        </td>
                        <td>
                            <select id="orderFields" class="std" name="orderFields" onchange="Dynamicweb.eCommerce.OrderDiscounts.showOrderFieldsOption();">
                                <asp:Literal ID="ltOrderField" runat="server"></asp:Literal>
                            </select>
                        </td>
                    </tr>
                    <tr id="rbOrderFieldTypeDiv" style="display: none;">
                        <td></td>
                        <td>
                            <dw:RadioButton ID="rbOrderFieldValue" runat="server" FieldName="OrderFieldType" FieldValue="1" OnClientClick="Dynamicweb.eCommerce.OrderDiscounts.showOrderFieldType(1);" />
                            <label for="OrderFieldType1">
                                <dw:TranslateLabel Text="Order field value" runat="server" />
                            </label>
                            <br />
                            <dw:RadioButton ID="rbVoucherLists" runat="server" FieldName="OrderFieldType" FieldValue="2" OnClientClick="Dynamicweb.eCommerce.OrderDiscounts.showOrderFieldType(2);" />
                            <label for="OrderFieldType2">
                                <dw:TranslateLabel Text="Voucher list" runat="server" />
                            </label>
                        </td>
                    </tr>                    
                    <tr id="RadioOrderFieldTypeDiv" style="display: none;">
                        <td>
                            <dw:TranslateLabel Text="Order field value" runat="server" />
                        </td>
                        <td>
                            <dwc:InputText ID="txRadioOrderFieldValue" runat="server"/>
                        </td>
                    </tr>
                    <tr id="VoucherListsDiv" style="display: none;">
                        <td>
                            <dw:TranslateLabel Text="Voucher list" runat="server" />
                        </td>
                        <td>
                            <select id="orderDiscountVoucherList" class="std" name="orderDiscountVoucherList" >
                                <asp:Literal ID="ltVoucherLists" runat="server"></asp:Literal>
                            </select>
                        </td>
                    </tr>
                    <tr id="OrderFieldValueDiv" style="display: none;">
                        <td>
                            <dw:TranslateLabel Text="Field value" runat="server" />
                        </td>
                        <td>
                            <dwc:InputText ID="txOrderFieldValue" runat="server" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
        </form>
    </div>
</body>
<% 	Translate.GetEditOnlineScript()%>
</html>
