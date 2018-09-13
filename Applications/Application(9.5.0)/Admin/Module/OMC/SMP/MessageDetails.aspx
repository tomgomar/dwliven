<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/EntryContent.Master" CodeBehind="MessageDetails.aspx.vb" Inherits="Dynamicweb.Admin.MessageDetails" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="cHeadMessage" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        div.tab-contents {
            display: none;
            overflow: hidden;
        }

            div.tab-contents.active {
                display: block !important;
            }

        ul.tabs,
        ul.tabs li {
            list-style: none;
            margin: 0;
            padding: 0;
        }
    </style>
    <script type="text/javascript">
        if (typeof (OMC) == 'undefined') {
            var OMC = new Object();
        }

        if (typeof (OMC.SMP) == 'undefined') {
            OMC.SMP = new Object();
        }

        OMC.SMP.Statistics = {
            terminology: {},

            initialize: function () {
                document.observe('dom:loaded', function () {
                    $($$('.smp-stats')[0]).observe('click', function (e) {
                        OMC.SMP.Statistics.filterByAdapter(Event.element(e).id);
                    });
                });
            },

            filterByAdapter: function (adapter) {
                var prefix = '';

                var getPrefix = function (t) {
                    var result = t.indexOf(':') > 0 ? t.substr(0, t.indexOf(':')) : '';

                    if (result.length > 1) {
                        result = '';
                    }

                    return result;
                }

                var setClass = function (t) {
                    var ad = '';

                    t = $(t);
                    ad = t.readAttribute('data-adapter');

                    if (getPrefix(ad) == prefix) {
                        if (ad == adapter) {
                            t.addClassName('active');
                        } else {
                            t.removeClassName('active');
                        }
                    }
                }

                prefix = getPrefix(adapter);

                if (adapter && adapter.length && prefix.length) {
                    $$('.smp-stats div[data-adapter]').each(setClass);
                }
            }
        }

        OMC.SMP.Statistics.initialize();
    </script>
</asp:Content>

<asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardBody runat="server">
            <div class="content-main smp-stats">
                <dw:RoundedFrame ID="RoundedFrame1" Title="Title" TranslateTitle="true" Width="853" runat="server">
                    <dw:Label ID="messageTitle" runat="server" doTranslation="false" />
                </dw:RoundedFrame>
                <br />
                <dw:RoundedFrame ID="frmLinks" Title="Links" TranslateTitle="true" Width="853" runat="server">
                    <asp:Panel ID="pLinks" runat="server">
                        <asp:Repeater ID="repLinksTabs" runat="server">
                            <HeaderTemplate>
                                <ul class="tabs">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <li>
                                    <input type="radio" name="links" id="l:<%#Eval("Id")%>" <%#If(CType(Eval("IsActive"), Boolean), " checked=""checked""", String.Empty)%> />
                                    <label for="l:<%#Eval("Id")%>"><%#Eval("Name")%></label>
                            </ItemTemplate>
                            <FooterTemplate>
                                </ul>
                            <div class="dashboard-clear"></div>
                            </FooterTemplate>
                        </asp:Repeater>

                        <div class="dashboard-separator"></div>

                        <asp:Repeater ID="repLinksTabContainer" OnItemDataBound="repLinksTabContainer_ItemDataBound" runat="server">
                            <ItemTemplate>
                                <div class="tab-contents list-container<%#If(CType(Eval("IsActive"), Boolean), " active", String.Empty)%><%#If(CType(Eval("HasLinks"), Boolean), " list-container-has-records", String.Empty)%>" data-adapter="l:<%#Eval("Id")%>">
                                    <dw:List ID="lstLinks" ShowTitle="false" NoItemsMessage="No data" ShowPaging="false" runat="server">
                                        <Columns>
                                            <dw:ListColumn Name="Url" TranslateName="true" runat="server" />
                                        </Columns>
                                    </dw:List>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </asp:Panel>
                    <asp:Panel ID="pNoLinks" runat="server">
                        <dw:TranslateLabel ID="lbNoLinks" Text="No data" runat="server" />
                    </asp:Panel>
                </dw:RoundedFrame>
                <br />
                <dw:RoundedFrame ID="frmContent" Title="Content" TranslateTitle="true" Width="853" runat="server">
                    <asp:Panel ID="pContent" runat="server">
                        <asp:Repeater ID="repContentTabs" runat="server">
                            <HeaderTemplate>
                                <ul class="tabs">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <li>
                                    <input type="radio" name="content" id='c:<%#Eval("Id")%>' <%#If(CType(Eval("IsActive"), Boolean), " checked=""checked""", String.Empty)%> />
                                    <label for="c:<%#Eval("Id")%>"><%#Eval("Name")%></label>
                            </ItemTemplate>
                            <FooterTemplate>
                                </ul>
                            <div class="dashboard-clear"></div>
                            </FooterTemplate>
                        </asp:Repeater>


                        <div class="dashboard-separator"></div>

                        <asp:Repeater ID="repContentTabContainer" OnItemDataBound="repContentTabContainer_ItemDataBound" runat="server">
                            <ItemTemplate>
                                <div class="tab-contents<%#If(CType(Eval("IsActive"), Boolean), " active", String.Empty)%>" data-adapter="c:<%#Eval("Id")%>">
                                    <asp:Panel ID="pEmpty" runat="server">
                                        <dw:TranslateLabel ID="lbNoContentAdapter" Text="No data" runat="server" />
                                    </asp:Panel>

                                    <asp:Repeater ID="repContentTabContents" runat="server">
                                        <HeaderTemplate>
                                            <ul>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <span class="adapterName"><%#Eval("Name")%></span>
                                            <p><%#Eval("Text")%></p>
                                            <div  style="display: <%#Eval("IsShowPost")%>;">
                                                <div id="postedImage<%#Eval("Name").ToString().Replace(" ", "")%>" style="display: <%#Eval("ShowImage")%>;">
                                                    <img src="<%#Eval("Image")%>" alt="">
                                                </div>
                                                <div id="postedLink<%#Eval("Name").ToString().Replace(" ", "")%>" style="display: <%#Eval("ShowLink")%>;">
                                                    <a href="<%#Eval("Link")%>"><%#Eval("Title")%></a>
                                                    <p><%#Eval("Description")%></p>
                                                </div>
                                            </div>
                                            <p></p>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </ul>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </asp:Panel>

                    <asp:Panel ID="pNoContent" runat="server">
                        <dw:TranslateLabel ID="lbNoContent" Text="No data" runat="server" />
                    </asp:Panel>
                </dw:RoundedFrame>
            </div>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>
