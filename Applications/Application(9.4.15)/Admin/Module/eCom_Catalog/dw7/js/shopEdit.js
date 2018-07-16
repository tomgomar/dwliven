var backend = {
    patterns: null,
    index: 1,
    

    toggleUseAltImage: function () {
        var chk = $("UseAlternativeImages");
        document.getElementById('AlternativeImageSection').style.display = chk.checked ? 'block' : 'none';
    },

    toggleSearchInSubfolders: function () {
        document.getElementById('PatternsWarningContainer').style.display = $("ImageSearchInSubfolders").checked ? 'block' : 'none';
    },
};