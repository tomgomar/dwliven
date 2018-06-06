var Carousel = function () { }

var slideTimer;

document.addEventListener("DOMContentLoaded", function (event) {
    var carousels = document.getElementsByClassName("js-carousel-container");

    for (var i = 0; i < carousels.length; i++) {
        Carousel.SlideShow(carousels[i]);
    }
});

Carousel.prototype.SlideShow = function (currentCarousel) {
    var carouselContainer = currentCarousel;
    var carouselData = carouselContainer.getElementsByClassName('js-carousel-data')[0];
    if (!carouselData) {
        return;
    }
    var currentSlide = carouselData.hasAttribute("data-current-slide") ? carouselData.getAttribute("data-current-slide") : 0;
    var totalSlides = carouselData != null ? carouselData.getAttribute("data-total-slides") : 0;
    var direction = carouselData.hasAttribute("data-direction") ? carouselData.getAttribute("data-direction") : "horizontal";
    var slidingType = carouselData.hasAttribute("data-sliding-type") ? carouselData.getAttribute("data-sliding-type") : "full";

    var slideHeight = carouselContainer.firstElementChild.firstElementChild.firstElementChild.offsetHeight + 5;
    var slideWidth = carouselContainer.firstElementChild.firstElementChild.firstElementChild.offsetWidth + 5;
    var slidesInView = carouselData.hasAttribute("data-slides-in-view") ? carouselData.getAttribute("data-slides-in-view") : 5;
    var slidesLeft = totalSlides - slidesInView;

    if (direction == "vertical") {
        carouselContainer.firstElementChild.style.top = 0;
    } else {
        carouselContainer.firstElementChild.style.left = 0;
    }

    if (slidingType == "items") {
        totalSlides = slidesLeft;
    }

    if (totalSlides > 1 && carouselData.getAttribute("data-carousel-slide-time") > 0) {
        slideTimer = setTimeout(function () {
            Carousel.ShiftSlide(currentCarousel, "next");
        }, carouselData.getAttribute("data-carousel-slide-time") * 1000);
    }

    if (totalSlides <= 1) {
        carouselData.classList.add("u-hidden");
    }

    var event = new CustomEvent('initSlideShow', { 'detail': { 'currentTarget': carouselContainer, 'currentSlide': currentSlide, 'totalSlides': totalSlides, 'direction': direction, "slidingType": slidingType } });
    carouselContainer.dispatchEvent(event);
    document.dispatchEvent(event);
}

Carousel.prototype.GetPreviousSlide = function (thisButton) {
    clearTimeout(slideTimer);
    Carousel.ShiftSlide(thisButton, "prev");
}

Carousel.prototype.GetNextSlide = function (thisButton) {
    clearTimeout(slideTimer);
    Carousel.ShiftSlide(thisButton, "next");
}

Carousel.prototype.GoToSlide = function (thisButton, number) {
    clearTimeout(slideTimer);
    Carousel.ShiftSlide(thisButton, number);
}

Carousel.prototype.ShiftSlide = function (thisButton, slideTo) {
    var carouselContainer = thisButton.closest('.js-carousel-container');
    var carouselData = thisButton.closest('.js-carousel-data') != null ? thisButton.closest('.js-carousel-data') : thisButton.getElementsByClassName('js-carousel-data')[0];
    var currentSlide = carouselData.hasAttribute("data-current-slide") ? carouselData.getAttribute("data-current-slide") : 0;
    var totalSlides = carouselData.getAttribute("data-total-slides");
    var direction = carouselData.hasAttribute("data-direction") ? carouselData.getAttribute("data-direction") : "horizontal";
    var slidingType = carouselData.hasAttribute("data-sliding-type") ? carouselData.getAttribute("data-sliding-type") : "full";

    var slideHeight = carouselContainer.firstElementChild.firstElementChild.firstElementChild.offsetHeight - 5;
    var slideWidth = carouselContainer.firstElementChild.firstElementChild.firstElementChild.offsetWidth + 5;
    var slidesInView = carouselData.hasAttribute("data-slides-in-view") ? carouselData.getAttribute("data-slides-in-view") : 5;
    var slidesLeft = totalSlides - slidesInView;

    //console.log(slideHeight);

    if (slidingType == "items") {
        totalSlides = slidesLeft;
    }

    if (slideTo == "next" || null) {
        if (currentSlide < (totalSlides - 1)) {
            currentSlide++;
        } else {
            currentSlide = 0;
        }
    }

    if (slideTo == "prev") {
        if (currentSlide > 0) {
            currentSlide--;
        } else {
            currentSlide = (totalSlides - 1);
        }
    }

    if (Number.isInteger(slideTo)) {
        currentSlide = slideTo;
    }

    if (direction == "vertical") {
        if (slidingType == "items") {
            carouselContainer.firstElementChild.style.top = -(currentSlide * slideHeight) + "px";
        } else {
            carouselContainer.firstElementChild.style.top = -(currentSlide * 100) + "%";
        }
    } else {
        if (slidingType == "items") {
            carouselContainer.firstElementChild.style.left = -(currentSlide * slideWidth) + "px";
        } else {
            carouselContainer.firstElementChild.style.left = -(currentSlide * 100) + "%";
        }
    }

    if (totalSlides <= 1) {
        carouselData.classList.add("u-hidden");
    }

    if (totalSlides > 1 && carouselData.getAttribute("data-carousel-slide-time") > 0) {
        slideTimer = setTimeout(function () {
            Carousel.ShiftSlide(carouselContainer, "next");
        }, carouselData.getAttribute("data-carousel-slide-time") * 1000);
    }

    carouselData.setAttribute("data-current-slide", currentSlide);

    var currentSlideElement = carouselContainer.getElementsByClassName("carousel__container__slide")[currentSlide];

    var event = new CustomEvent('shiftSlide', { 'detail': { 'currentTarget': carouselContainer, 'slideTo': slideTo, 'currentSlide': currentSlide, 'currentSlideElement': currentSlideElement, 'totalSlides': totalSlides } });
    carouselContainer.dispatchEvent(event);
    document.dispatchEvent(event);
}

var Carousel = new Carousel();