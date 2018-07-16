var EmailTypeSelect = {
    newBlankEmail: function (subject) {
        $('templateId').value = '';
        $('subject').value = subject;
        $('subject').focus();
        EmailTypeSelect.showDialog();
    },

    newTemplateBasedEmail: function (templateId, subject) {
        $('templateId').value = templateId;
        $('subject').value = subject;
        $('subject').focus();
        EmailTypeSelect.showDialog();
    },

    showDialog: function () {
        dialog.show('NewEmailDialog');
        $('subject').focus();
    },

    newEmailOk: function () {
        $('cmdSubmit').click();
        dialog.hide('NewEmailDialog');
        var __o = new overlay('ribbonOverlay');
        __o.message('');
        __o.show();
    }
};
