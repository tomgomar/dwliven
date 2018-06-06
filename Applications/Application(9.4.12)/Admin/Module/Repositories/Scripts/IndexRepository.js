app.factory('indexRepository', function ($http) {
    return {

        getIndex: function (callback, token) {
            var url = "/Admin/Api/repositories/Index/" + repository + "/" + item + "/";
            $http.get(url, {
                withCredentials: true,
                headers: { 'Authorization': token }
            }).success(callback);
        },

        setIndex: function (data, callback, token) {
            var url = "/Admin/Api/repositories/Index/" + repository + "/" + item + "/";
            $http.post(url, data, {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': token
                }
            }).success(callback).error(function (err) { alert(angular.toJson(err)); });
        },

        buildIndex: function (instance, build, incallback, token) {
            var url = "/Admin/Api/repositories/build/" + repository + "/" + item + "-index/" + instance + "/" + build + "/";
            $http.post(url, null, {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': token
                }
            }).success(incallback);
        },

        resumeIndex: function (instance, meta, incallback, token) {
            var url = "/Admin/Api/repositories/resume/" + repository + "/" + item + "-index/" + instance + "/";
            $http.post(url, meta, {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': token
                }
            }).success(incallback);
        },

        getStatus: function (callback, errorCallback, token) {
            var url = "/Admin/Api/repositories/_sys_status/" + repository + "/" + item + "/";
            $http.post(url, null, {
                headers: { 'Authorization': token }
            }).success(callback).error(errorCallback);
        },

        getInstanceTypes: function (callback, errorCallback, token) {
            var url = "/Admin/Api/repositories/_sys_instance_types/" + repository + "/" + item + "/";
            $http.post(url, null, {
                headers: { 'Authorization': token }
            }).success(callback).error(errorCallback);
        },

        getBuildTypes: function (callback, errorCallback, token) {
            var url = "/Admin/Api/repositories/_sys_build_types/" + repository + "/" + item + "/";
            $http.post(url, null, {
                headers: { 'Authorization': token }
            }).success(callback).error(errorCallback);
        },

        getBuildActions: function (callback, errorCallback, token) {
            var url = "/Admin/Api/repositories/_sys_build_actions/" + repository + "/" + item + "/";
            $http.post(url, null, {
                headers: { 'Authorization': token }
            }).success(callback).error(errorCallback);
        },

        getFieldTypes: function (callback, errorCallback) {
            //var url = "/Admin/Api/" + repository + "/" + item + "/_sys_field_types";
            //$http.post(url).success(callback).error(errorCallback);
            var fieldTypes = [];
            fieldTypes[0] = {
                Source: null,
                Type: 'FieldDefinition'
            };
            fieldTypes[1] = {
                Sources: [],
                Type: 'CopyFieldDefinition'
            };
            fieldTypes[2] = {
                Type: 'ExtensionFieldDefinition'
            };

            if (callback && typeof(callback) == 'function')
                callback(fieldTypes);
        },

        getFieldSources: function (builderType, settings, callback, token) {
            var url = "/Admin/Api/repositories/_sys_field_sources/" + encodeURIComponent(builderType) + "/";
            $http.post(url, settings, {
                headers: {
                    'Content-Type': 'application/json', 'Authorization': token
                }
            }).success(callback);
        },

        getExtensionTypes: function (callback, errorCallback, token) {
            var url = "/Admin/Api/repositories/_sys_extension_types/" + repository + "/" + item + "/";
            $http.post(url, null, {                
                headers: { 'Authorization': token }
            }).success(callback).error(errorCallback);
        },

        getExtensionFields: function (callback, errorCallback, token) {
            var url = "/Admin/Api/repositories/_sys_extension_fields/";
            $http.post(url, null, {                
                headers: { 'Authorization': token }
            }).success(callback).error(errorCallback);
        },

        getNotificationTemplates: function (callback, token) {
            $http.get("/Admin/Api/repositories/_sys_notification_templates", {                
                headers: { 'Authorization': token }
            }).success(callback);
        },

        getBuildTypeDefaultSettings: function (callback, token) {
            $http.post("/Admin/Api/repositories/_sys_build_default_settings", null, {                
                headers: { 'Authorization': token }
            }).success(callback);
        },

        getBalancerTypes: function (callback, token) {
            $http.post("/Admin/Api/repositories/_sys_build_balancer_types", null, {                
                headers: { 'Authorization': token }
            }).success(callback);
        }
    }

});

