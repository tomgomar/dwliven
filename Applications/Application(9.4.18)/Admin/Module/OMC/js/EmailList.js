function EmailList(opts) {
    
    var options = opts;
    
    return {
        help: window.showHelp,
        emailSelected: function() {
            var isAllEmailsFolder = options.isAllEmailsFolder;
            var isTemplatesFolder = options.isTemplatesFolder;
            if (List && List.getSelectedRows('lstEmailsList').length > 0) {
                if (!isTemplatesFolder && !isAllEmailsFolder) {
                    Toolbar.setButtonIsDisabled('cmdMove', false);
                    Toolbar.setButtonIsDisabled('cmdCopy', false);
                }
                Toolbar.setButtonIsDisabled('cmdDelete', false);
            } else {
                if (!isTemplatesFolder && !isAllEmailsFolder) {
                    Toolbar.setButtonIsDisabled('cmdMove', true);
                    Toolbar.setButtonIsDisabled('cmdCopy', true);
                }
                Toolbar.setButtonIsDisabled('cmdDelete', true);
            }
        },


        editEmail: function (emailId) {
            document.getElementById('LoadingOverlay').style.display = "block";
            var folderId = options.folderId;
            var topFolderId = options.topFolderId;

            var folder = "";
            if (folderId == -1) {
                folder = "folderId=" + folderId + "&AllEmails=true&topFolderId=" + topFolderId;
            }
            else if (folderId == -2) {
                folder = "folderId=" + folderId + "&AllEmailTemplates=true&topFolderId=" + topFolderId;
            }
            else {
                folder = "folderId=" + folderId + "&topFolderId=" + topFolderId;
            }

            if (emailId > 0) {
                dwGlobal.marketing.navigate("/Admin/Module/OMC/Emails/EditEmail.aspx?newsletterId=" + emailId + "&" + folder);
            }
            else {
                dwGlobal.marketing.navigate("/Admin/Module/OMC/Emails/EmailTypeSelect.aspx?" + folder);
            }
        },

        confirmDeleteEmail: function () {
            var self = this;
            var ids = dwGlobal.marketing.getCheckedRows('lstEmailsList');
            var row = null;
            var confirmStr = "";
            var rowID = window.ContextMenu.callingID;

            if (rowID && ids.length == 1) {
                row = window.List.getRowByID('lstEmailsList', 'row' + rowID);
                if (row) {
                    confirmStr = row.children[2].innerText ? row.children[2].innerText : row.children[2].innerHTML;
                    confirmStr = confirmStr.replace('&nbsp;', "");
                    confirmStr = confirmStr.replace('&qout;', "");
                }
            } else if (ids.length > 0) {
                var checkedRows = window.List.getSelectedRows('lstEmailsList');

                if (checkedRows && checkedRows.length > 0) {
                    for (var i = 0; i < checkedRows.length; i++) {
                        if (i != 0) {
                            confirmStr += " ' , '";
                        }
                        row = window.List.getRowByID('lstEmailsList', checkedRows[i].id);
                        if (row) {
                            confirmStr += row.children[2].innerText ? row.children[2].innerText : row.children[2].innerHTML;
                            confirmStr = confirmStr.replace('&nbsp;', "");
                            confirmStr = confirmStr.replace('&qout;', "");
                        }
                    }
                }
            }

            Action.Execute(options.actions.delete, {
                ids: ids,
                names: confirmStr
            });
        },

        copyEmail: function () {
            var ids = dwGlobal.marketing.getCheckedRows('lstEmailsList');
            Action.Execute(options.actions.copy, {
                ids: ids
            });
        },

        moveEmail: function() {
            var ids = dwGlobal.marketing.getCheckedRows('lstEmailsList');
            Action.Execute(options.actions.move, {
                ids: ids
            });
        },

        resendEmail: function (emailResendProvider) {
            var ids = dwGlobal.marketing.getCheckedRows('lstEmailsList');
            var folderId = options.draftFolderId;
            var topFolderId = options.topFolderId;
            Action.Execute(options.actions.resendEmail, {
                id: ids,
                provider: emailResendProvider
            });
        },

        showSaveAsTemplateDialog: function(emailId) {
            Action.Execute(options.actions.saveAsTemplate, {
                id: emailId
            });
        },

        emailStatistics: function (emailId) {
            document.getElementById('LoadingOverlay').style.display = "block";
            dwGlobal.marketing.navigate("/Admin/Module/OMC/Emails/Statistics.aspx?newsletterId=" + emailId);
        },

        showSplitTestReport: function (emailId) {
            document.getElementById('LoadingOverlay').style.display = "block";
            dwGlobal.marketing.navigate("/Admin/Module/OMC/Emails/SplitTestReport.aspx?newsletterId=" + emailId);
        },

        setContexMenuView: function (sender, args) {
            var ret = 'Basic';
            var row = List.getRowByID('lstEmailsList', args.callingID);

            if (row.hasAttribute('View')) {
                ret = row.readAttribute('View');
            }

            return ret;
        }
    };
}
