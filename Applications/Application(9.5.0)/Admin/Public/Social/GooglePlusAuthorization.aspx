<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GooglePlusAuthorization.aspx.vb" Inherits="Dynamicweb.Admin.GooglePlusAuthorization" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb" %>

<html>
<head>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludeUIStylesheet="true" CombineOutput="false" IncludePrototype="true" IncludeScriptaculous="true"></dw:ControlResources>
    <asp:Literal runat="server" ID="SetterBlock"></asp:Literal>
</head>

<script type="text/javascript">
    function signInCallback(authResult)
    {
        var authWnd = window.opener;
        var gpWnd = window;

        if(authResult['code'])
        {
            new Ajax.Request('<%=Request.Url.AbsolutePath%>', {
                method: 'POST',
                parameters: {
                    cmd: 'GetRefreshToken',
                    code: authResult['code'],
                    client_id: '<%=Request("ClientID")%>',
                    client_secret: '<%=Request("SecretKey")%>'
                },
                onComplete: function (transport)
                {
                    if(transport && transport.responseText)
                    {
                        var json = transport.responseText.evalJSON();

                        authWnd.document.getElementById('GooglePlus.RefreshToken').value = json['refresh_token'];
                        authWnd.Dynamicweb.SMP.ChannelEdit.onSuccess();
                        gpWnd.close();
                    }
                    else
                    {
                        authWnd.document.getElementById('GooglePlus.RefreshToken').value = null;
                        authWnd.Dynamicweb.SMP.ChannelEdit.onError();
                        gpWnd.close();
                    }
                }
            });
        }
        else
        {
            authWnd.document.getElementById('GooglePlus.RefreshToken').value = null;
            authWnd.Dynamicweb.SMP.ChannelEdit.onError();
            gpWnd.close();
        }
    }
</script>

<script type="text/javascript">
    (function ()
    {
        var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
        po.src = 'https://apis.google.com/js/client:plusone.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
    })();
</script>

<body>
    <div id="signinButton">
        <span class="g-signin"
            data-scope="https://www.googleapis.com/auth/plus.login"
            data-clientid="<%=Dynamicweb.Core.Converter.ToString(Request("ClientID"))%>"
            data-redirecturi="postmessage"
            data-accesstype="offline"
            data-approvalprompt="force"
            data-cookiepolicy="single_host_origin"
            data-callback="signInCallback"></span>
    </div>
</body>
</html>
