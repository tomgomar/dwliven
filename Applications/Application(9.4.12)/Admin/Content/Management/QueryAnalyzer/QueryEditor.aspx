<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="QueryEditor.aspx.vb" Inherits="Dynamicweb.Admin.Management.QueryAnalyzer.QueryEditor" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <script src="/Admin/Filemanager/FileEditor/CodeMirror-5.21/lib/codemirror.js" type="text/javascript"></script>
        <script src="/Admin/Filemanager/FileEditor/CodeMirror-5.21/mode/sql/sql.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/List/List.js" type="text/javascript"></script>
        <link rel="stylesheet" href="/Admin/Filemanager/FileEditor/CodeMirror-5.21/lib/codemirror.css" />
    </dwc:ScriptLib>
    <style type="text/css">
        /* Column names are fixed and do not scroll away when going through the recordset */

        /*body {
            border-top: 1px solid rgb(160, 175, 195);
        }*/

        /* .footer doesn't exist in the html output but it´s the last TR that contains paging.
        Improvement: Paging is fixed on the left side and always shown when scrolling through the recordset */
        .fix-subheader {
            background: none repeat scroll 0 0 rgb(255, 255, 255);
            bottom: 0 !important;
            left: 30px;
            right: 0;
            position: fixed;
            z-index: 100;
        }
    </style>
    <script type="text/javascript">
        (function ($) {

            var __o;

            var Fetch = function () {
                dwGlobal.hideControlErrors("txtSql", "");
                __o.show();
                Query = escape(editor.getValue());
                $.ajax({
                    type: "GET",
                    url: "QueryEditor.aspx",
                    data: "TestQuery=" + Query,
                    datatype: "xml",
                    success: function (transport) {
                        debugger;
                        if ($(transport).children("status").length > 0) {
                            $(transport).find("status").each(function () {
                                var complete = false;
                                var status = $(this).find("code").text();
                                var message = $(this).find("msg").text();
                                if (status == 200) {
                                    if (!isNaN(message)) {
                                        if (message > 0) {//update, insert, delete
                                            msg = "<%=Dynamicweb.SystemTools.Translate.JsTranslate("This will affect {#} records. Do you wish to continue?") %>"
                                            if (confirm(msg.replace("{#}", message))) {
                                                complete = true;
                                            }
                                        }
                                    }

                                } else if (status == "15002") {
                                    if (confirm("<%=Dynamicweb.SystemTools.Translate.JsTranslate("The effect of this statement cannot be evaluated prior to execution, but will affect the database immediately. Do you wish to continue?") %>")) {
                                            complete = true;
                                        }
                                    } else {
                                        showError("<%=Dynamicweb.SystemTools.Translate.JsTranslate("The following message was returned by the server") %>\n\n" + message);
                                    }
                                if (complete) {
                                    executeQuery(Query);
                                }
                            }
                            )
                        } else {
                            retrieveList(transport);
                        }
                    },
                    error: function (transport) {
                        showError("<%=Dynamicweb.SystemTools.Translate.JsTranslate("An error occured while attempting to contact the server.") %>!" + transport + "!");
                    }
                });
            }

            var executeQuery = function (Query) {
                $.ajax({
                    type: "GET",
                    url: "QueryEditor.aspx",
                    data: "Query=" + Query,
                    success: function (transport) {
                        retrieveList(transport);
                    },
                    error: function (transport) {
                        showError("<%=Dynamicweb.SystemTools.Translate.JsTranslate("An error occured while attempting to contact the server.") %>!" + transport + "!");
                    }
                });
            }

            var retrieveList = function (listMarkup) {
                $('#ListContainer')[0].innerHTML = listMarkup;
                __o.hide();
                var footer = $(".subheader");
                footer.addClass("fix-subheader");

                $(document).on("scroll", function (e) {
                    if (($(document).height() - $(window).height() - $(window).scrollTop()) < 180) {
                        footer.removeClass("fix-subheader");
                    } else {
                        footer.addClass("fix-subheader");
                    }
                });
            }

            function showError(msg) {
                dwGlobal.showControlErrors("txtSql", msg);
                __o.hide();
            }

            $(function () {

                __o = new overlay('wait');
                __o.message('');

                $(document).on('keypress', function (e) {
                    if (e.ctrlKey && (e.keyCode == 0xA || e.keyCode == 0xD)) {
                        Fetch();
                    }
                });
                editor.focus();

                $('#ExecuteQuery').on('click', Fetch);

                if (List) {
                    List.gotoPage = function (listID, pageIdx) {
                        __o.show();
                        executeQuery($('#Query').val() + "&PageIndex=" + pageIdx);
                    }
                }
            });
        })(jQuery);
    </script>
    <style>
        #helptxtSql{
            width: 96%;
            margin-left: 25px;
        }

        .table td {
            max-width: 250px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        #ListContainer{
            max-width:100%;
            overflow-x:scroll;
        }
    </style>
</head>
<body class="area-blue">
<div class="screen-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="SQL Firehose"></dwc:CardHeader>
            <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="ExecuteQuery" runat="server" Divide="None" Icon="Database"
                    Text="Execute Query (Ctrl plus Enter)">
                </dw:ToolbarButton>
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <dw:GroupBox runat="server">
                    <form id="form1" runat="server">
                        <div>
                            <dwc:InputTextArea ID="txtSql" runat="server" Value="SELECT * FROM " ValidationMessage="" />
                        </div>
                        <script type="text/javascript">
                            var editor = CodeMirror.fromTextArea(document.getElementById('txtSql'), {
                                mode: "text/x-mysql",
                                tabMode: "indent",
                                matchBrackets: true,
                                lineNumbers: true,
                                dragDrop: false
                            });
                        </script>
                        <div id="ListContainer">
                            <asp:Literal ID="listOutput" runat="server"></asp:Literal>
                        </div>
                    </form>
                </dw:GroupBox>
            </dwc:CardBody>
        </dwc:Card>
        <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
        </dw:Overlay>
    </div>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
%>
</html>
