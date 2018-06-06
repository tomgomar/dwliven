﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CombineProducts_BuildVariantsCombinations.aspx.vb" Inherits="Dynamicweb.Admin.CombineProducts_BuildVariantsCombinations" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title><dw:TranslateLabel runat="server" Text="Variants" /></title>
    <dw:ControlResources runat="server" IncludePrototype="true" IncludeUIStylesheet="true">
        <Items>
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/EditableGrid/EditableGrid.js" />
            <dw:GenericResource Url="ProductsFamily.js" />
        </Items>
    </dw:ControlResources>
    <style type="text/css">
        .dropdowncell select {
            width:100%;
        }
    </style>
</head>
<dwc:DialogLayout runat="server" Title="Variants" HidePadding="True">
    <Content>
        <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True"></dw:Overlay>
        <div class="col-md-0">
            <dw:EditableGrid runat="server" ID="VariantCombinations" AllowAddingRows="false" AllowDeletingRows="false" AutoGenerateColumns="false">
                <Columns>
                    <asp:TemplateField HeaderText="Name">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:HiddenField runat="server" Id="Id" />
                            <asp:Label runat="server" Id="ProductName" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Number">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:Label runat="server" Id="ProductNumber" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Master">
                        <HeaderStyle HorizontalAlign="Center"  Width="50px" />
                        <ItemStyle HorizontalAlign="Center" Width="50px" />
                        <ItemTemplate>
                            <dwc:RadioButton runat="server" FieldValue="" FieldName="IsMasterProduct" Name="IsMasterProduct" ID="IsMasterProduct" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </dw:EditableGrid>
        </div>
        <input type="hidden" id="json" name="json" value="" />
    </Content>
    <Footer>
        <a href="<%= GetBackPageUrl() %>" class="btn btn-link waves-effect pull-left" onclick="return prevWizardPage(event);"><dw:TranslateLabel runat="server" Text="Back" /></a>
        <button class="btn btn-link waves-effect pull-right" type="button" onclick="save(event);">Save</button>
    </Footer>
</dwc:DialogLayout>
    <script>
        function GetUpdatedData() {
            var jsonObj = <%=GetDataJson()%>;
            var rows = dwGrid_VariantCombinations.rows.getAll();
            Dynamicweb.Utilities.CollectionHelper.forEach(rows, function(row) {
                var id = row.findControl("Id").value;
                var idx = id.indexOf(".");
                var prodId = id.substr(0, idx);
                var variantId = id.substr(idx + 1);
                var product = Dynamicweb.Utilities.CollectionHelper.first(jsonObj.Products, function(p) {
                    return p.ProductId == prodId && p.VariantId == variantId;
                });
                if (product) {
                    var isMasterProductCtrl = row.findControl("IsMasterProduct_" + id);
                    if (isMasterProductCtrl.checked) {
                        jsonObj.MasterProductId = prodId;
                    }
                    var arr = [];
                    Dynamicweb.Utilities.CollectionHelper.forEach(jsonObj.VariantGroupsIds, function(vgId) {
                        var varGrpCtrl = row.findControl(vgId);
                        if (varGrpCtrl && varGrpCtrl.value) {
                            arr.push([vgId, varGrpCtrl.value]);
                        }
                    });
                    product.SelectedVariantCombinations = arr.length ? arr : null;
                }
            });
            return jsonObj;
        }

        function prevWizardPage(e) {
            e.stopPropagation();
            var jsonObj = GetUpdatedData();
            var jsonData = toQueryString(jsonObj, false);
            document.getElementById("json").value = jsonData;
            var url = "<%= GetBackPageUrl() %>";
            window.document.forms[0].setAttribute("action", url);
            Action.Execute({'Name':'Submit'})
            return false;            
        }

        function save(e) {
            e.stopPropagation();
            var obj = GetUpdatedData();
            if (isValid(obj)) {
                var ol = new overlay("wait");
                ol.show();
                var jsonData = toQueryString(obj, false);
                document.getElementById("json").value = jsonData;
                Action.Execute({'Name':'Submit'})
            }
        }

        function isValid(obj) {
            if (!obj.MasterProductId) {
                infoBox.masterProductNotSelected();
                return false;
            }

            if (!isCombinationsUnique(obj)) {
                infoBox.combinationsNotUnique();
                return false;
            }

            if (!isProductNumbersFilledOut(obj)) {
                infoBox.numbersNotFilled();
                return false;
            }

            if (!isProductNumbersUnique(obj)) {
                infoBox.numbersNotUnique();
                return false;
            }

            return true;
        }

        function isCombinationsUnique(obj) {
            var result = true;
            var combi = {};
            Dynamicweb.Utilities.CollectionHelper.forEach(obj.Products, function(prod) {
                if (!result) {
                    return result;
                }
                if (prod.SelectedVariantCombinations) {
                    var prodVarId = ".";
                    Dynamicweb.Utilities.CollectionHelper.forEach(prod.SelectedVariantCombinations, function(vc) {
                        prodVarId += vc[1] + ".";
                    });
                    if (!combi[prodVarId]) {
                        combi[prodVarId] = true;
                    } else {
                        result = false;
                    }
                }
            });
            return result;
        }

        function isProductNumbersFilledOut(obj) {
            var result = true;
            var combi = {};
            Dynamicweb.Utilities.CollectionHelper.forEach(obj.Products, function (prod) {
                if (!result) {
                    return result;
                }

                if (prod.Number == "" && obj.MasterProductId != prod.ProductId) {
                    result = false;
                }
            });
            return result;
        }


        function isProductNumbersUnique(obj) {
            var result = true;
            var combi = {};
            Dynamicweb.Utilities.CollectionHelper.forEach(obj.Products, function (prod) {
                if (!result) {
                    return result;
                }

                if (prod.Number) {
                    if (!combi[prod.Number]) {
                        combi[prod.Number] = true;
                    } else {
                        result = false;
                    }
                }
            });
            return result;
        }

        document.observe("dom:loaded", function() {
            document.body.select(".modal-dialog.dialog-md")[0].className = "modal-dialog dialog-lg";
        });

        var infoBox = {
            masterProductNotSelected: function() {
                showMessageBox("<%=Translate.JsTranslate("The master product should be selected")%>", "<%=Translate.JsTranslate("Information")%>");
            },

            combinationsNotUnique: function() {
                showMessageBox("<%=Translate.JsTranslate("The variants combinations should be unique")%>", "<%=Translate.JsTranslate("Information")%>");
            },

            numbersNotFilled: function () {
                showMessageBox("<%=Translate.JsTranslate("The product numbers should be filled out")%>", "<%=Translate.JsTranslate("Information")%>");
            },

            numbersNotUnique: function () {
                showMessageBox("<%=Translate.JsTranslate("The product numbers should be unique")%>", "<%=Translate.JsTranslate("Information")%>");
            }
        };
    </script>
</html>
<%
    Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
%>
