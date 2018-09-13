﻿<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="/Admin/Content/Management/EntryContent2.Master" CodeBehind="EcomAdvConfigProductManagement.aspx.vb" Inherits="Dynamicweb.Admin.EcomAdvConfigProductManagement" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>


<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    
    <script type="text/javascript" src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        
        page.onSave = function () { addIndex('IndexList_body', 'IndexSelectorValue'); return save(false); };
        page.saveAndClose = function () { addIndex('IndexList_body', 'IndexSelectorValue'); return save(true); };

        

        function save(close) {
            var fieldFactorControl = document.getElementById("FieldLanguageFactor");
            if (!fieldFactorControl.value || fieldFactorControl.value < 1) {
                dwGlobal.showControlErrors(fieldFactorControl, "<%=Translate.Translate("Must be more or equal 1")%>")
                return false;
            }
            var __o = new overlay('__ribbonOverlay');
            __o.show();
            var url = "EcomAdvConfigProductManagement.aspx?Save=true";
            if (close)
            url += "&Close=True";
            $("MainForm").action = url;
            $("MainForm").submit();
        }

        function addIndex(listId, inputId) {
            var items = [];
            var list = document.getElementById(listId);
            var selectedRows = list.getElementsByClassName("listRow selected")

            for(var i = 0; i < selectedRows.length; i++)
            {
                var dataString = "";

                for (var j = 1; j < 4; j++)
                {
                    dataString += selectedRows[i].children[j].innerText;

                    if(j < 3){
                        dataString += "|";
                    }
                    
                }
                items.push(dataString.trim());
            }

            var selectText = items.join();
            document.getElementById(inputId).value = selectText;
        }

        function displayFieldLanguageFactorWarning(event) {
            if (!event.target.value) {
                return;
            }

            if (event.target.value > 1) {
                document.getElementById("<%=FieldLanguageFactorWarningContainer.ClientID%>").style.display = 'block';

            }
            else {
                document.getElementById("<%=FieldLanguageFactorWarningContainer.ClientID%>").style.display = 'none';
            }
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <dwc:GroupBox runat="server" Title="List settings">
       <div id="FieldLanguageFactorWarningContainer" runat="server">
                    <dw:Infobar runat="server" Type="Warning" Message="Setting this value too high, can cause bad performance"></dw:Infobar>
                    <br/>
                </div>
        <dwc:InputNumber runat="server" ID="FieldLanguageFactor" Name="/Globalsettings/Settings/Ecom/PIM/FieldLanguageFactor" Label="Field/Language factor" Min="1" ClientIDMode="Static" ValidationMessage="" ></dwc:InputNumber>
    </dwc:GroupBox>

    <dwc:GroupBox runat="server" Title="Default Index">
        <dwc:SelectPicker runat="server" ID="DefaultIndexPicker" Name="DefaultIndexSelectorValue"></dwc:SelectPicker>
    </dwc:GroupBox>

    <dwc:GroupBox runat="server" Title="Available Indexes">
                    <input type="hidden" name="IndexSelectorValue" id="IndexSelectorValue" value="" />
                    <dw:List ID="IndexList" runat="server" AllowMultiSelect="true" Personalize="true" NoItemsMessage="No indexes"
                    StretchContent="false" UseCountForPaging="true"  HandlePagingManually="true"  OnClientSelect="addIndex('IndexList_body' , 'IndexSelectorValue')">
		            </dw:List>
    </dwc:GroupBox>

    <dwc:GroupBox runat="server" Title="Versioning" Visible="False">
        <dwc:InputNumber runat="server" ID="VersionRetention" Name="/Globalsettings/Settings/Ecom/PIM/VersionRetention" Label="Retention (Days)" Min="1" ClientIDMode="Static" ValidationMessage="" ></dwc:InputNumber>
    </dwc:GroupBox>

    <% Translate.GetEditOnlineScript() %>

    <script type="text/javascript">
        document.getElementById('FieldLanguageFactor').onchange = displayFieldLanguageFactorWarning;
        </script>
</asp:Content>