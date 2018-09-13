
    function infoDirectRequest() {
        var form = document.getElementById('ordersubmit');
        var field1 = document.createElement('input');
        field1.type = 'hidden';
        field1.name = 'CartCmd';
        field1.id = 'CartCmd';
        field1.value = 'FetchingCustomerFromInfodirekt';
        form.appendChild(field1);
        var field2 = document.createElement('input');
        field2.type = 'hidden';
        field2.name = 'customerPhone';
        field2.id = 'customerPhone';
        field2.value = document.getElementById('EcomOrderCustomerPhone').value;
        form.appendChild(field2);
        updateCart();
    }
