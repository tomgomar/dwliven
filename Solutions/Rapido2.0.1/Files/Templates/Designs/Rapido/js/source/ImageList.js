var ImageList = function () { }

ImageList.prototype.GetImage = function (thumb) {
    var galleryImage = document.getElementById(thumb.getAttribute("data-for"));
    var number = parseInt(thumb.getAttribute("data-number"));
    var galleryContainer = galleryImage.closest('.js-gallery-slider');
    var images = galleryContainer.getAttribute("data-images").split(",");
    var totalImages = galleryContainer.getAttribute("data-total-images");

    if (galleryImage) {
        galleryImage.setAttribute("data-number", number);
        galleryContainer.setAttribute("data-current-image", number);
    } else {
        return;
    }

    if (number >= 0 && number < totalImages) {
        galleryImage.src = images[number];
        galleryContainer.setAttribute("data-current-image", number);

        var counter = galleryContainer.getElementsByClassName("js-image-list-counter");
        if (counter.length > 0) {
            counter[0].innerHTML = (number + 1);
        }
    }

    //thumb
    if (thumb.closest(".js-thumb-btn")) {
        var thumbButtons = document.getElementsByClassName("js-thumb-btn");

        for (var i = 0; i < thumbButtons.length; i++) {
            var thumbBtn = thumbButtons[i];
            if (thumbBtn.getAttribute('data-for') == thumb.getAttribute('data-for')) {
                thumbBtn.classList.remove('thumb-list__item--active');
            }
        }

        thumb.closest(".js-thumb-btn").classList.add('thumb-list__item--active');
    }

    var event = new CustomEvent('imageListOpenImage', { 'detail': { 'currentTarget': galleryImage, 'galleryContainer': galleryContainer, 'src': images[number], 'number': number, 'totalImages': totalImages } });
    document.dispatchEvent(event);
}

ImageList.prototype.GetPreviousImage = function (thisButton) {
    var galleryContainer = thisButton.closest('.js-gallery-slider');
    var galleryImage = galleryContainer.getElementsByClassName("js-gallery-image")[0];
    var images = galleryContainer.getAttribute("data-images").split(",");
    var currentImage = galleryContainer.getAttribute("data-current-image");
    var totalImages = galleryContainer.getAttribute("data-total-images");

    if (currentImage > 0) {
        currentImage--;
    } else {
        currentImage = (totalImages - 1);
    }

    galleryImage.src = images[currentImage];
    galleryContainer.setAttribute("data-current-image", currentImage);


    var counter = galleryContainer.getElementsByClassName("js-image-list-counter");
    if (counter.length > 0) {
        counter[0].innerHTML = (currentImage + 1);
    }

    var event = new CustomEvent('imageListPreviousImage', { 'detail': { 'currentTarget': galleryImage, 'galleryContainer': galleryContainer, 'src': images[currentImage], 'currentImage': currentImage, 'totalImages': totalImages } });
    document.dispatchEvent(event);
}

ImageList.prototype.GetNextImage = function (thisButton) {
    var galleryContainer = thisButton.closest('.js-gallery-slider');
    var galleryImage = galleryContainer.getElementsByClassName("js-gallery-image")[0];
    var images = galleryContainer.getAttribute("data-images").split(",");
    var currentImage = galleryContainer.getAttribute("data-current-image");
    var totalImages = galleryContainer.getAttribute("data-total-images");

    if (currentImage < (totalImages-1)) {        
        currentImage++;
    } else {
        currentImage = 0;
    }

    galleryImage.src = images[currentImage];
    galleryContainer.setAttribute("data-current-image", currentImage);
    var counter = galleryContainer.getElementsByClassName("js-image-list-counter");
    if (counter.length > 0) {
        counter[0].innerHTML = (currentImage + 1);
    }

    var event = new CustomEvent('imageListNextImage', { 'detail': { 'currentTarget': galleryImage, 'galleryContainer': galleryContainer, 'src': images[currentImage], 'currentImage': currentImage, 'totalImages': totalImages } });
    document.dispatchEvent(event);
}

var ImageList = new ImageList();