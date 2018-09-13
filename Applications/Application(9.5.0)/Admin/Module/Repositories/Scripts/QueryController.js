app.controller("queryController", function ($scope, $http, $timeout, queryRepository) {

    $scope.query = null;
    $scope.instanceTypes = null;
    $scope.search = {};
    $scope.search.parameters = {};
    $scope.search.result = {};
    $scope.datasources = [];
    $scope.supportedActions = [];
    $scope.model = {};
    $scope.terms = [];
    $scope.languages = [];
    $scope.updated;
    $scope.token = '';

    $scope.propertyName = 'Occurrences';
    $scope.reverse = true;
    $scope.showWarning = false;
    $scope.containsExtendedWarning = "Using the ContainsExtended operator can cause bad performance and higher memory usage";

    $scope.init = function (token) {
        $scope.token = 'Basic ' + token;       

        $scope.getDataSources();
        $scope.getQuery();
        $scope.getSupportedActions();
        $scope.getLanguages();
    }

    $scope.sortBy = function (propertyName) {
        $scope.reverse = ($scope.propertyName === propertyName) ? !$scope.reverse : false;
        $scope.propertyName = propertyName;
    };

    $scope.draftInstance = null;

    $scope.getQuery = function () {
        queryRepository.getQuery(function (results) {
            $scope.query = results;
            $scope.updateDataModel();
        }, $scope.token);
    }

    $scope.validateExpressions = function () {
        return validateExpression($scope.query.Expression);
    }

    $scope.onCancel = function () {
        if (calledFrom == "PIM") {
            document.location.href = '/Admin/Module/eCom_Catalog/dw7/ListSmartSearches.aspx?groupID=' + repositoryclean
        }
        else {
            document.location.href = '/Admin/Module/Repositories/ViewRepository.aspx?id=' + repositoryclean
        }
    }

    validateExpression = function (expression) {
        if (expression != null) {
            if (expression.Expressions != null) {
                for (var i = 0; i < expression.Expressions.length; i++) {
                    if (expression.Expressions[i].Expressions != null) {
                        if (!validateExpression(expression.Expressions[i])) {
                            return false;
                        }
                    } else {
                        if (!isSimpleExpressionValid(expression.Expressions[i])) {
                            return false;
                        }
                    }
                }
            } else {
                if (!isSimpleExpressionValid(expression)) {
                    return false;
                }
            }
        }
        return true;
    }

    isSimpleExpressionValid = function (expression) {
        return !((expression.Left == null || expression.Left.Field == null)
                || expression.Right == null
                || (expression.Right.class == "ConstantExpression" && (expression.Right.Value == null || expression.Right.Type == null))
                || (expression.Right.class == "ParameterExpression" && expression.Right.VariableName == null)
                || (expression.Right.class == "MacroExpression" && expression.Right.LookupString == null)
                || (expression.Right.class == "TermExpression" && (expression.Right.Value == null || expression.Right.Type == null))
                || expression.Operator == null);
    }

    $scope.setQuery = function () {
        $scope.trySaveQuery();
    }

    $scope.setQueryAndExit = function () {
        $scope.trySaveQuery(function() {
            if (calledFrom == "PIM") {
                document.location.href = '/Admin/Module/eCom_Catalog/dw7/PIM/PimMultiEdit.aspx?queryId=' + $scope.query.ID + '&groupId=' + repositoryclean;
            } else {
                document.location.href = '/Admin/Module/Repositories/ViewRepository.aspx?id=' + repositoryclean
            }
        });
    }

    $scope.trySaveQuery = function (afterSaveFn) {
        $scope.correctIsEmptyExpressions($scope.query.Expression);

        if (!$scope.validateExpressions()) {
            alert(_messages.saveQueryWithWrongExpression);
            return;
        }

        if ($scope.query.Name == "") {
            alert("Query name cannot be empty.");
            return;
        }
        var isNameHasWrongSymbols = false;

        for (var i = 0; !isNameHasWrongSymbols && i < _invalidQueryNameSymbols.length; i++) {
            isNameHasWrongSymbols = $scope.query.Name.indexOf(_invalidQueryNameSymbols[i]) > -1;
        }
        if (isNameHasWrongSymbols) {
            alert(_messages.invalidQueryName);
            return;
        }

        $scope.setViewLanguagesAndFields();

        queryRepository.setQuery($scope.query, function (results) {
            $scope.refreshTreeNode(results);
            if (afterSaveFn) {
                afterSaveFn(results);
            }
        }, $scope.token);
    }

    $scope.setViewLanguagesAndFields = function () {
        //Fetch data from selectionBoxes
        //Fields
        var fields = [];
        var viewFields = SelectionBox.getElementsRightAsOptionArray("ViewFieldList");
        for (var i = 0; i < viewFields.length; i++) {
            fields.push({ Name: viewFields[i].text, Source: viewFields[i].value, Sort: i })
        }

        $scope.query.ViewFields = fields;

        //Languages
        var languages = [];
        var viewLanguages = SelectionBox.getElementsRightAsOptionArray("ViewLanguagesList");
        for (var i = 0; i < viewLanguages.length; i++) {
            languages.push({ ID: viewLanguages[i].value, Name: viewLanguages[i].text, SortOrder: i })
        }

        $scope.query.ViewLanguages = languages;
    }

    $scope.refreshTreeNode = function (option) {
        if (calledFrom == "PIM") {
            console.log(option.NodeId)
            dwGlobal.getNavigatorWindow("PIM").dwGlobal.currentNavigator.refreshNode(option.NodeId)
        }
    }

    $scope.correctIsEmptyExpressions = function (expression) {
        if (expression != null) {
            if (expression.Expressions != null) {
                for (var i = 0; i < expression.Expressions.length; i++) {
                    if (expression.Expressions[i].Expressions != null) {
                        $scope.correctIsEmptyExpressions(expression.Expressions[i])
                    }
                    else {
                        if (expression.Expressions[i].Operator == 'IsEmpty') {
                            expression.Expressions[i].Right = {};
                            expression.Expressions[i].Right.class = 'ConstantExpression';
                            expression.Expressions[i].Right.Value = 'Empty';
                            expression.Expressions[i].Right.Type = 'System.String';
                        }
                    }
                }
            } else {

            }
        }
    }

    $scope.getInstanceTypes = function () {
        queryRepository.getInstanceTypes(function (results) {
            $scope.instanceTypes = results;
        }, function (err) { }, $scope.token);
    }

    $scope.getDataSources = function () {
        queryRepository.getDataSources(function (results) {
            res = [];
            for (var i = 0; i < results.length; i++) {
                if (results[i].Type == "Index")
                    res.push({
                        Repository: results[i].Repository,
                        Item: results[i].Name,
                        Type: results[i].Provider
                    });

                if (results[i].Name == $scope.query.Source.Item && results[i].Repository == $scope.query.Source.Repository) {
                    $scope.query.Source.Type = results[i].Provider;
                }
            }
            $scope.datasources = res;
        }, $scope.token);
    }

    $scope.updateDataModel = function () {
        queryRepository.getModel($scope.query.Source.Repository, $scope.query.Source.Item, function (results) {
            $scope.model = results;

            if ($scope.model.Fields) {
                $scope.model.Fields.sort(function (a, b) {
                    return a.Name == b.Name ? 0 : a.Name < b.Name ? -1 : 1;
                });
                $scope.model.Fields.sort(function (a, b) {
                    return a.Group == b.Group ? 0 : a.Group < b.Group ? -1 : 1;
                });
                $scope.model.SortFields = $scope.model.Fields;
                $scope.model.SortFields.push({ Name: "Score", SystemName: "_score", Type: "", Group: "" });
            }

            if (calledFrom == "PIM") {
                if ($scope.query.ViewFields == null || $scope.query.ViewFields.length == 0) {
                    $scope.query.ViewFields = [];
                    $scope.query.ViewFields.push({ Name: 'Active', Source: 'ProductActive' })
                    $scope.query.ViewFields.push({ Name: 'Product name', Source: 'ProductName' })
                    $scope.query.ViewFields.push({ Name: 'Product number', Source: 'ProductNumber' })
                    $scope.query.ViewFields.push({ Name: 'Price', Source: 'ProductPrice' })
                }

                $scope.fillDisplayFields();
                $scope.fillDisplayLanguages($scope.languages);
            }
        }, $scope.token);
    }

    $scope.getLanguages = function () {
        queryRepository.getLanguages(function (languages) {
            $scope.languages = languages;
        }, $scope.token);
    }

    $scope.getSupportedActions = function () {
        queryRepository.getSupportedActions(function (results) {
            res = [];
            for (var i = 0; i < results.length; i++) {
                var vals = results[i].split(':');
                res.push({
                    original: results[i],
                    namespace: vals[0],
                    name: vals[1]
                });
            }
            $scope.supportedActions = res;
        }, $scope.token);
    }

    $scope.addExpression = function (parent) {
        var binaryExpr = { 'class': 'BinaryExpression', Left: { "Field": null, "class": "FieldExpression" } };

        if (parent) {
            parent.Expressions.push(binaryExpr);
        }
        else {
            $scope.query.Expression = binaryExpr;
        }
    }

    $scope.addExpressionGroup = function (parent) {
        var groupExpr = { 'class': 'GroupExpression', Operator: 'And', Expressions: [{ 'class': 'BinaryExpression', Left: { "Field": null, "class": "FieldExpression" } }] };

        if (parent) {
            parent.Expressions.push(groupExpr);
        }
        else {
            $scope.query.Expression = groupExpr;
        }
    }

    $scope.haveExpressions = function () {
        if ($scope.query && $scope.query.Expression)
            return true;

        return false;
    }

    $scope.deleteExpression = function ($scope, index) {
        if (index == 0 && !$scope.$parent.$parent.expr) {
            $scope.query.Expression = null;
        }
        else {
            var arr = $scope.$parent.$parent.expr.Expressions;
            if (arr) {
                arr.splice(index, 1);
            }
        }
    }

    $scope.deleteExpressionGroup = function ($scope, index) {
        $scope.deleteExpression($scope, index);
    }

    $scope.removeProp = function (name) {
        delete $scope.query.Settings[name];
    }

    $scope.insertSetting = function (name, value) {
        $scope.query.Settings[name] = value;
    }


    $scope.openDlgSetting = function (name, val) {
        document.getElementById('dlgSettingName').value = name;
        document.getElementById('dlgSettingValue').value = val;
        dialog.show('dlgSetting');
    }

    $scope.saveDlgSetting = function () {

        if (document.getElementById('dlgSettingName').value.length > 0) {
            alert(document.getElementById('dlgSettingName').value + document.getElementById('dlgSettingValue').value)
            $scope.query.Settings[document.getElementById('dlgSettingName').value] = document.getElementById('dlgSettingValue').value;
            dialog.hide('dlgSetting');
        }

    }

    $scope.getFieldName = function (systemName) {
        for (var i = 0; i < $scope.model.Fields.length; i++) {
            var field = $scope.model.Fields[i];
            if (field.SystemName === systemName) {
                return field.Name;
            }
        }
    }

    /* DIALOGS */


    /* Search Dialog */
    $scope.openSearchDialog = function () {
        $scope.search = {};
        $scope.search.parameters = {};
        $scope.search.result = {};

        dialog.show('dlgSearch');
    }

    $scope.executeQuery = function () {
        queryRepository.executeQuery($scope.search.parameters, function (results) {
            $scope.search.result = results;
        }, $scope.token);

    }

    $scope.togglePreview = function () {
        $scope.setPreview(!$scope.preview);
    }

    $scope.setPreview = function (pview) {
        $scope.preview = pview;
    }

    $scope.removeQueryParameter = function (index) {
        $scope.query.Parameters.splice(index, 1);
    }

    $scope.openParameterDialog = function (param) {
        if (param) {
            $scope.selectedParam = param;
            $scope.draftParam = angular.copy(param);
        }
        else {
            $scope.selectedParam = null;
            $scope.draftParam = {}; // new parameter
        }
        dialog.show('ParameterDialog');
    }

    $scope.openSourceDialog = function () {
        dialog.show('SourceDialog');
    }

    $scope.saveSourceDialog = function () {
        dialog.hide('SourceDialog');
    }

    $scope.saveParameterDialog = function () {
        if ($scope.selectedParam) {
            $scope.selectedParam.Name = $scope.draftParam.Name;
            $scope.selectedParam.Type = $scope.draftParam.Type;
            $scope.selectedParam.DefaultValue = $scope.draftParam.DefaultValue;
        }
        else {
            if (!$scope.query.Parameters) {
                $scope.query.Parameters = [];
            }
            $scope.query.Parameters.push(angular.copy($scope.draftParam));
        }
        dialog.hide('ParameterDialog');
    }

    $scope.openSortingDialog = function (sort) {
        if (sort) {
            $scope.selectedSort = sort;
            $scope.draftSort = angular.copy(sort);
        }
        else {
            $scope.selectedSort = null;
            $scope.draftSort = {}; // new sorting
        }
        dialog.show('SortOrderDialog');
    }

    $scope.saveSortingDialog = function () {
        if ($scope.selectedSort) {
            $scope.selectedSort.Field = $scope.draftSort.Field;
            $scope.selectedSort.SortDirection = $scope.draftSort.SortDirection;
        }
        else {
            if (!$scope.query.SortOrder) {
                $scope.query.SortOrder = [];
            }
            $scope.query.SortOrder.push(angular.copy($scope.draftSort));
        }
        dialog.hide('SortOrderDialog');
    }

    $scope.removeSortingParameter = function (index) {
        $scope.query.SortOrder.splice(index, 1);
    }

    $scope.editExpression = function (expr) {
        $scope.selectedExpression = expr;

        var field = $scope.model.Fields.filter(function (x) { return x.SystemName == expr.Left.Field })

        $scope.fillTerms([], expr, function () {
            dialog.show('EditExpressionDialog');

            if (expr.Right && expr.Right.class == 'CodeExpression') {
                $scope.loadCodeParameters(expr);
            }

        });
    }

    $scope.populateTermSelector = function (control, field, expr, callback) {
        if (expr.Terms && (expr.Terms.Terms && expr.Terms.Terms.length > 0) && expr.Terms.Field == field.SystemName) {
            $scope.fillTerms(expr.Terms.Terms, expr, callback);
        }
        else {
            var spinner;
            if (control != "undefined") {
                spinner = new overlay("wait");
                spinner.overlay = control.getElementsByClassName("overlay-container")[0];
                spinner.show();
            }

            queryRepository.getTerms($scope.query.Source.Repository, $scope.query.Source.Item, field, function (results) {

                $scope.fillTerms(results, expr, callback);
                if (spinner){
                    spinner.hide();
                }
            }, $scope.token);
        }
    }

    $scope.fillTerms = function (results, expr, callback) {
        if (expr.Right != undefined) {
            $scope.rightExpressionDraft = angular.copy(expr.Right);

            if (!expr.Terms)
            {
                expr.Terms = {};
            }

            expr.Terms.Field = expr.Left.Field;
            expr.Terms.Terms = results;
            $scope.rightExpressionDraft.Terms = {};
            $scope.rightExpressionDraft.Terms.Field = expr.Left.Field;
            $scope.rightExpressionDraft.Terms.Terms = results;

            var terms = [];
            if (typeof $scope.rightExpressionDraft.DisplayValue == "string") {
                terms = $scope.rightExpressionDraft.DisplayValue.split(",");
            }
            else {
                terms = $scope.rightExpressionDraft.DisplayValue;
            }

            $scope.setSelected(expr, terms);
            $scope.selectTerm();
        }
        else {
            var field = expr.Left ? expr.Left.Field : expr.Terms.Field;
            var expressionClass = $scope.rightExpressionDraft ? $scope.rightExpressionDraft.class : "";
            $scope.rightExpressionDraft = {}; // new right expression
            $scope.rightExpressionDraft.class = expressionClass;
            $scope.rightExpressionDraft.Terms = {};
            $scope.rightExpressionDraft.Terms.Field = field;
            $scope.rightExpressionDraft.Terms.Terms = results;

            if (!expr.Terms) {
                expr.Terms = {};
            }

            expr.Terms.Field = field;
            expr.Terms.Terms = results;
            expr.selectedTerms = [];
        }
        if (callback){
            callback();
        }
    }

    $scope.setSelected = function (expr, terms) {
        if (typeof terms != "undefined") {
            for (var i = 0; i < terms.length; i++) {
                var term = expr.Terms.Terms.filter(function (term) {
                    return term.Value == terms[i];
                });

                if (term.length == 1) {
                    term[0].selected = true;
                }
            };

            expr.selectedTerms = expr.Terms.Terms.filter(
            function (e) {
                return e.selected == true
            });
            expr.DisplayValue = $scope.buildTermValue(expr.selectedTerms)
        }
    }

    $scope.selectTerm = function (field, expr, termKey) {        
        if (expr != undefined) {
            //Only allow one select term for equal
            if (expr.Operator == 'Equal' && expr.selectedTerms.length >= 1) {
                var terms = expr.Terms.Terms.filter(function (x) { return x.Key == termKey.Key });
                if (terms.length > 0) {
                    //unselect terms but keep the last selected or keep at least one selected
                    for (var i = 0; i < expr.Terms.Terms.length; i++) {                        
                        expr.Terms.Terms[i].selected = (expr.Terms.Terms[i].Key == terms[0].Key);
                    }
                    //select last checked term
                    expr.selectedTerms = terms;
                }
            }

            expr.selectedTerms = expr.Terms.Terms.filter(
                function (e) {
                    return e.selected == true;
                });

            if (expr) {
                expr.DisplayValue = $scope.buildTermValue(expr.selectedTerms);
                $scope.setTerms(field, expr)
            }
        }
    }

    $scope.setValue = function (expr) {
        expr.Right.class = 'ConstantExpression';
        expr.Right.Value = expr.Right.DisplayValue;

        var field = $scope.model.Fields.filter(function (x) { return x.SystemName == expr.Left.Field })
        expr.Right.Type = field[0].Type;
    }

    $scope.buildTermValue = function (selectedTerms) {
        var termValue = "";
        for (var i = 0; i < selectedTerms.length; i++) {
            if (termValue != "") {
                termValue = termValue.concat(",");
            }

            termValue = termValue.concat(selectedTerms[i].Value);
        }

        return termValue;
    }

    $scope.saveEditExpressionDialog = function () {
        if (!$scope.selectedExpression) {
            console.log("expression not set");
            return;
        }

        var expr = $scope.selectedExpression;
        expr.Right = {};
        expr.Right.class = $scope.rightExpressionDraft.class;
        var promises = [];

        if (expr.Right.class == 'ConstantExpression') {
            expr.Right.Value = $scope.rightExpressionDraft.DisplayValue;
            expr.Right.DisplayValue = $scope.rightExpressionDraft.DisplayValue;
            expr.Right.Type = $scope.rightExpressionDraft.Type;
        }
        else if (expr.Right.class == 'ParameterExpression') {
            expr.Right.VariableName = $scope.rightExpressionDraft.VariableName;
        }
        else if (expr.Right.class == 'MacroExpression') {
            expr.Right.LookupString = $scope.rightExpressionDraft.LookupString;
        }
        else if (expr.Right.class == 'TermExpression') {
            expr.Right.Value = $scope.rightExpressionDraft.selectedTerms.map(function (a) { return a.Key });
            expr.Right.DisplayValue = $scope.rightExpressionDraft.DisplayValue;

            var field = $scope.model.Fields.filter(function (x) { return x.SystemName == expr.Left.Field })

            expr.Right.Type = field[0].Type;

            if ($scope.rightExpressionDraft.selectedTerms.length > 1 && !expr.Right.Type.endsWith(']')) {
                expr.Right.Type = expr.Right.Type + '[]';
            }
            else {
                //The 'In' operator doesn't work with non-array types, so no matter what this should always return an array, if the operator is 'In'
                if ($scope.rightExpressionDraft.selectedTerms.length == 1 && !expr.Right.Type.endsWith(']') && expr.Operator == "In") {
                    expr.Right.Type = expr.Right.Type + '[]';
                }
            }

            if (expr.selectedTerms.length == 0) {
                expr.Right = undefined;
            }
        }
        else if (expr.Right.class == 'CodeExpression') {
            var typeElement = document.getElementById("AddInSelector_CodeProvider_params");

            var parametersElement = document.getElementById("ConfigurableAddIn_parameters");

            var parametersKeyValue = ""

            if (parametersElement != null) {
                var parameterString = parametersElement.value;

                var parameters = parameterString.split(",")

                for (var i = 0; i < parameters.length; i++) {
                    var tokens = parameters[i].split("(");
                    var parameterId = tokens[1].replace(")", "");
                    var parameterName = tokens[0];

                    //Get parameter element by ID
                    var element = document.getElementById(parameterId);

                    if (element == null) {
                        element = document.getElementsByName(parameterId)[0];
                    }

                    if (element != null) {
                        parametersKeyValue += parameterName + "::" + element.value + ";";
                    }
                }
            }

            var promise = queryRepository.getCodeParameters(typeElement.value, encodeURI(parametersKeyValue), function (data) {
                expr.Right.Parameters = data.Value;
                expr.Right.DisplayValue = data.DisplayValue;
                expr.Right.Type = data.Type;
            }, $scope.token);

            promises.push(promise);
        }

        Promise.all(promises).then(function () {
            $scope.rightExpressionDraft = null;
            dialog.hide('EditExpressionDialog');
        })
    }

    $scope.setTerms = function (field, expr) {
        expr.Right = {};
        expr.Right.class = 'TermExpression';

        expr.Right.Value = expr.selectedTerms.map(function (a) { return a.Key });
        expr.Right.DisplayValue = expr.DisplayValue;
        if (field) {
            expr.Right.Type = field.Type;
        }

        if (expr.selectedTerms.length > 1 && !expr.Right.Type.endsWith(']')) {
            expr.Right.Type = expr.Right.Type + '[]';
        }
        else {
            //The 'In' operator doesn't work with non-array types, so no matter what this should always return an array, if the operator is 'In'
            if (expr.selectedTerms.length == 1 && !expr.Right.Type.endsWith(']') && expr.Operator == "In") {
                expr.Right.Type = expr.Right.Type + '[]';
            }
        }

        if (expr.selectedTerms.length == 0) {
            expr.Right = undefined;
        }
    }

    $scope.toggleTermSelector = function (expr, e) {
        var optionsCol = e.currentTarget.parentElement.getElementsByClassName("termSelect-options");
        if (optionsCol.length) {
            var elm = optionsCol[0];

            if (elm.classList.contains('termSelect-options-hidden')) {
                elm.classList.remove('termSelect-options-hidden');
                var fieldSystemName = expr.Left ? expr.Left.Field : expr.Terms.Field;
                $scope.populateTermSelector(elm, $scope.getFieldBySystemName(fieldSystemName), expr);
            } else {
                elm.classList.add('termSelect-options-hidden');
            }
        }
    }

    $scope.loadCodeParameters = function (expr) {
        var element = document.getElementById("Dynamicweb.Extensibility.CodeProviderBase, Dynamicweb_AddInTypes");

        if (element != null) {
            if (element.value != expr.Right.Type) {
                element.value = expr.Right.Type;
                element.onchange();
                $scope.fillParameters(expr);
            }
            else {
                $scope.fillParameters(expr);
            }
        }
        else {
            $scope.loop($scope.loadCodeParameters, 200, expr);
        }
    }

    $scope.fillParameters = function (expr) {

        if (document.getElementById('ConfigurableAddIn_values') != null) {
            document.getElementById('ConfigurableAddIn_values').value = expr.Right.Parameters;
            var element = document.getElementById("Dynamicweb.Extensibility.CodeProviderBase, Dynamicweb_AddInTypes");
            element.onchange();
        }
        else {
            $scope.loop($scope.fillParameters, 200, expr);
        }
    }

    $scope.loop = function (callback, timeout, expr) {
        window.setTimeout(function () {
            callback(expr);
        }, timeout);
    }

    $scope.fillDisplayFields = function () {
        var fields = $scope.model.SortFields;
        var left = [];
        var right = [];

        //Unselected fields
        for (var i = 0; i < fields.length; i++) {
            //Is the field already set on the query
            if ($scope.query.ViewFields != null && $scope.query.ViewFields.filter(function (e) { return $scope.compareFields(e, fields[i]); }).length == 0) {
                if (typeof (fields[i].Source) != "undefined" && fields[i].Source.startsWith("ProductCategory")) {
                    $scope.handleCustomFields(left, fields[i]);
                }
                else {
                    left.push({ Name: fields[i].Name, Value: fields[i].Source });
                }
            }
        }

        //Previous selected fields
        for (var i = 0; i < $scope.query.ViewFields.length; i++) {
            if (typeof ($scope.query.ViewFields[i].Source) != "undefined" && $scope.query.ViewFields[i].Source.startsWith("ProductCategory")) {
                $scope.handleCustomFields(right, $scope.query.ViewFields[i]);
            }
            else {
                right.push({ Name: $scope.query.ViewFields[i].Name, Value: $scope.query.ViewFields[i].Source, Sort: $scope.query.ViewFields[i].Sort });
            }
        }

        left.sort(function (a, b) {
            return a.Name == b.Name ? 0 : a.Name < b.Name ? -1 : 1;
        });

        right.sort(function (a, b) {
            return a.Sort == b.Sort ? 0 : a.Sort < b.Sort ? -1 : 1;
        });

        SelectionBox.fillLists(JSON.stringify({ left: left, right: right }), 'ViewFieldList');
    }

    $scope.compareFields = function (viewField, field) {
        if (typeof (field.Source) != "undefined" && field.Source.startsWith("ProductCategory")) {
            return viewField.Source == field.Source && viewField.Name == (field.Group + ' - ' + field.Name);
        }
        else {
            return viewField.Source == field.Source && viewField.Name == field.Name;
        }
    }

    $scope.handleCustomFields = function (selectionBox, field) {
        var name = field.Name;

        if (field.Source.startsWith("ProductCategory") && field.Group != undefined) {
            name = field.Group + ' - ' + field.Name;
        }

        selectionBox.push({ Name: name, Value: field.Source, Sort: field.Sort })
    }

    $scope.fillDisplayLanguages = function (languages) {
        var left = [];
        var right = [];

        for (var i = 0; i < languages.length; i++) {
            //Is the language already set on the query
            if ($scope.query.ViewLanguages == null || $scope.query.ViewLanguages.filter(function (e) { return e.ID == languages[i]._LanguageId; }).length == 0) {
                left.push({ Name: languages[i]._Name, Value: languages[i]._LanguageId });
            }
        }

        if ($scope.query.ViewLanguages != null) {
            for (var i = 0; i < $scope.query.ViewLanguages.length; i++) {
                var language = $scope.query.ViewLanguages[i];
                right.push({ Name: language.Name, Value: language.ID, Sort: language.SortOrder });
            }
        }

        left.sort(function (a, b) {
            return a.Name == b.Name ? 0 : a.Name < b.Name ? -1 : 1;
        });

        right.sort(function (a, b) {
            return a.Sort == b.Sort ? 0 : a.Sort < b.Sort ? -1 : 1;
        });

        SelectionBox.fillLists(JSON.stringify({ left: left, right: right }), 'ViewLanguagesList');
    }

    $scope.getFieldBySystemName = function (systemName) {
        if ($scope.model.Fields != undefined) {
            for (var i = 0; i < $scope.model.Fields.length; i++) {
                var field = $scope.model.Fields[i];
                if (field.SystemName === systemName) {
                    return field;
                }
            }
        }
    }    

    $scope.usesContainsExtended = function () {
        if ($scope.query != null && $scope.query.Expression != undefined) {
            var expression = $scope.query.Expression;

            if (expression.class == "BinaryExpression") {
                return expression.Operator == "ContainsExtended";
            }

            for (var i = 0; i < expression.Expressions.length; i++) {
                if (expression.Expressions[i].Operator == "ContainsExtended") {
                    return true;
                }
            }
        }

        return false;
    }

    $scope.showTermSelector = function (expr) {

        var field = $scope.getFieldBySystemName(expr.Left.Field)

        if (field == undefined) {
            return false;
        }

        if ((field.Type == 'System.Boolean'
        || expr.Operator == 'Equal'
        || expr.Operator == 'In') && (expr.Right == undefined || (expr.Right.class == 'ConstantExpression' || expr.Right.class == 'TermExpression'))) {
            return true;
        }

        if (!expr.Right){
            return false;
        }


        if ((
        (expr.Right.class != 'ConstantExpression'
        && expr.Right.class != 'CodeExpression'
        && expr.Right.class != 'ParameterExpression'
        && expr.Right.class != 'MacroExpression'))
        && (field.Type == 'System.Boolean'
        || expr.Operator == 'Equal'
        || expr.Operator == 'In')) {
            return true;
        }

        return false;

    }

    $scope.showTextBox = function (expr) {

        if ($scope.showTermSelector(expr)) {
            return false;
        }

        if (expr.Operator && expr.Operator == 'IsEmpty') {
            return false;
        }

        if (!expr.Right || expr.Right.class == '') {
            return true;
        }

        if (expr.Right.class == 'ConstantExpression' || expr.Right.class == 'TermExpression' || expr.Right.class == 'CodeExpression') {
            return true;
        }
    }
});
