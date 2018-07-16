<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomProductRelatedLimitations_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomProductRelatedLimitations_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />

    <script type="text/javascript">
        $(document).observe('dom:loaded', function () {

            var frame = window.frameElement;
            var container = $(frame).up('div#RelatedLimitationDialog');
            parent.dialog.set_okButtonOnclick(container, function () {
                document.getElementById('MainForm').submit();
            });

            toggleLanguages();
            toggleCountries();
            toggleShops();
            toggleVariants();
        });

        function toggleLanguages() {
            if ($('LanguageRadioAll').checked) {
                $('SelectedLanguages').hide();
            }
            else {
                $('SelectedLanguages').show();
            }
        }

        function toggleCountries() {
            if ($('CountryRadioAll').checked) {
                $('SelectedCountries').hide();
            }
            else {
                $('SelectedCountries').show();
            }
        }

        function toggleShops() {
            if ($('ShopRadioAll').checked) {
                $('SelectedShops').hide();
            }
            else {
                $('SelectedShops').show();
            }
        }

        function toggleVariants() {
            if ($('VariantsRadioAll')) {
                if ($('VariantsRadioAll').checked) {
                    $('SelectedVariants').hide();
                }
                else {
                    $('SelectedVariants').show();
                }
            }
        }
    </script>
    <style type="text/css">
        html, body {
            background-color: #f0f0f0;
            border-right: none !important;
            overflow: auto;
        }

        .content {
            margin: 10px;
        }

        .form-container {
            border: 1px solid #6593cf;
            background-color: #ffffff;
            position: relative;
        }

        .separator-10 {
            height: 10px;
        }

        tr.limitation-head td {
            white-space: nowrap;
        }

        .removecheckbox {
            font-weight: bolder;
        }

        .removecheckbox input {
            display: none;
        }
    </style>

</head>
<body>
    <form id="MainForm" runat="server">
        <div class="content">
            <div class="form-container">
                <dw:GroupBox ID="gbVariants" Title="Variants" runat="server">
                    <table>
                        <tr class="limitation-head">
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel3" Text="Apply to" runat="server" />
                            </td>
                            <td>
                                <input type="radio" runat="server" id="VariantsRadioAll" name="VariantsRadio" onclick="toggleVariants();" />
                                <label for="VariantsRadioAll">
                                    <dw:TranslateLabel runat="server" Text="All" />
                                </label>
                            </td>
                            <td>
                                <input type="radio" runat="server" id="VariantsRadioSelected" name="VariantsRadio" onclick="toggleVariants();" />
                                <label for="VariantsRadioSelected">
                                    <dw:TranslateLabel runat="server" Text="Selected" />
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td>
                                <asp:CheckBoxList ID="SelectedVariants" runat="server"></asp:CheckBoxList>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox ID="gbLanguages" Title="Languages" runat="server">
                    <table>
                        <tr class="limitation-head">
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel2" Text="Apply to" runat="server" />
                            </td>
                            <td>
                                <input type="radio" runat="server" id="LanguageRadioAll" name="LanguageRadio" onclick="toggleLanguages();" />
                                <label for="LanguageRadioAll">
                                    <dw:TranslateLabel runat="server" Text="All" />
                                </label>
                            </td>
                            <td>
                                <input type="radio" runat="server" id="LanguageRadioSelected" name="LanguageRadio" onclick="toggleLanguages();" />
                                <label for="LanguageRadioSelected">
                                    <dw:TranslateLabel runat="server" Text="Selected" />
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td>
                                <asp:CheckBoxList ID="SelectedLanguages" runat="server"></asp:CheckBoxList>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox ID="gbCountries" Title="Countries" runat="server">
                    <table>
                        <tr class="limitation-head">
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel6" Text="Apply to" runat="server" />
                            </td>
                            <td>
                                <input type="radio" runat="server" id="CountryRadioAll" name="CountryRadio" onclick="toggleCountries();" />
                                <label for="CountryRadioAll">
                                    <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="All" />
                                </label>
                            </td>
                            <td>
                                <input type="radio" runat="server" id="CountryRadioSelected" name="CountryRadio" onclick="toggleCountries();" />
                                <label for="CountryRadioSelected">
                                    <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Selected" />
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td>
                                <asp:CheckBoxList ID="SelectedCountries" runat="server"></asp:CheckBoxList>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox ID="gbShops" Title="Shops" runat="server">
                    <table>
                        <tr class="limitation-head">
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel7" Text="Apply to" runat="server" />
                            </td>
                            <td>
                                <input type="radio" runat="server" id="ShopRadioAll" name="ShopRadio" onclick="toggleShops();" />
                                <label for="ShopRadioAll">
                                    <dw:TranslateLabel runat="server" Text="All" />
                                </label>
                            </td>
                            <td>
                                <input type="radio" runat="server" id="ShopRadioSelected" name="ShopRadio" onclick="toggleShops();" />
                                <label for="ShopRadioSelected">
                                    <dw:TranslateLabel runat="server" Text="Selected" />
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td>
                                <asp:CheckBoxList ID="SelectedShops" runat="server"></asp:CheckBoxList>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </div>
            <div class="separator-10">&nbsp;</div>
        </div>
    </form>

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
