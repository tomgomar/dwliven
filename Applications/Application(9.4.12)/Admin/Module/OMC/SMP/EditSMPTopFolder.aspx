<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/EntryContent.Master" CodeBehind="EditSMPTopFolder.aspx.vb" Inherits="Dynamicweb.Admin.OMC.SMP.EditSMPTopFolder" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <dw:Overlay ID="saveForward" runat="server"></dw:Overlay>
    <table border="0">
        <tr>
            <td>
                <dw:GroupBox ID="gbGeneral" Title="General" runat="server">
                    <table>
                        <tr>
                            <td style="width: 170px">
                                <dw:TranslateLabel ID="TranslateLabel7" Text="Folder Name" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox ID="txtFolderName" CssClass="std field-name" runat="server" MaxLength="255" ClientIDMode="Static" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </td>
        </tr>
        <tr>
            <td>
                <dw:GroupBox ID="GroupBox1" Title="Available channels" runat="server">
                    <table border="0" style="width: 100%;">
                        <tr>
                            <td valign="top" style="width: 170px;">
                                <b><dw:TranslateLabel ID="lbChannels" Text="Channels" runat="server" /></b>
                            </td>
                            <td id="channelListCell" runat="server"></td>
                        </tr>
                    </table>
                </dw:GroupBox>  
            </td>
        </tr>
    </table>

    <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
    <input type="hidden" id="CloseOnSave" name="CloseOnSave" value="True" />
    <iframe name="frmPostback" src="" style="display: none"></iframe>
</asp:Content>
