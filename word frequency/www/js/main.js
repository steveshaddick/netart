var GLOBAL = {
    prefix: ''
};

if (typeof console === "undefined") {
    console = {
        log: function(log) {

        }
    }
};

var TransitionController = (function() {
    var transEndEventNames = {
        'WebkitTransition' : 'webkitTransitionEnd',
        'MozTransition'    : 'transitionend',
        'OTransition'      : 'oTransitionEnd',
        'msTransition'     : 'MSTransitionEnd',
        'transition'       : 'transitionend'
    };
    var strEnd = transEndEventNames[ Modernizr.prefixed('transition') ];

    function transitionEnd($obj, callback) {
        if (Modernizr.csstransitions) {
            $obj.unbind(strEnd);

            $obj.bind(strEnd, function() {
                $obj.unbind(strEnd);
                callback($obj);
            });
        } else {
            callback($obj);
        }
    }
    
    return {
        transitionEnd: transitionEnd
    };
    
}());

var Loader = (function() {

    var $element = null;
    var $text = null;
    var $right = null;
    var $left = null;
    var completeCallback = false
    var isComplete = false;
    var prefix = 'transform';
    var spinAmount = 1;
    var spinTotal = 0;
    var isInit = false;
    var timeout;


    function init(callback) {
        $element = $("#loader");
        $text = $(".loader-text", $element);
        $right = $(".spinner-right", $element);
        $left = $(".spinner-left", $element);
        completeCallback = callback;
        prefix = GLOBAL.prefix + prefix;
        isInit = true;
    }

    function setPercentage(percent) {
        var deg;
        if (percent >= 1) {

            if (isComplete) return;

            $text.html('Done.');
            $right.css(prefix, 'rotate(0deg)');
            $left.css(prefix, 'rotate(360deg)');
            destroy();
            isComplete = true;
            if (completeCallback) {
                completeCallback();
                completeCallback = null;
            }
            return;
        }

        isComplete = false;
        if (percent <= 0.5) {
            $left.css(prefix, 'rotate(180deg)');
            deg = -180 + parseInt((percent * 2) * 180);
            $right.css(prefix, 'rotate(' + deg +'deg)');
        } else {
            $right.css(prefix, 'rotate(0deg)');
            deg = 180 + parseInt(((percent - 0.5) * 2) * 180);
            $left.css(prefix, 'rotate(' + deg +'deg)');
        }
        $text.html('Loading ... ' + parseInt(percent * 100) + '%');
    }

    function startSpin(duration) {
        if (!isInit) {
            init();
        }
        spinAmount = (typeof duration !== "undefined") ? (1000 / duration) * (1 / 30) : 1 / 30;

        $text.html('Loading ... ');
        updateSpin();
    }

    function stopSpin() {
        clearTimeout(timeout);
    }

    function destroy() {
        $element = null;
        $text = null;
        $right = null;
        $left = null;
    }

    function updateSpin() {
        spinTotal += spinAmount;
        if (spinTotal >= 2) {
            spinTotal = 0;
        }

        if (spinTotal <= 0.5) {
            $left.css(prefix, 'rotate(180deg)');
            deg = -180 + parseInt((spinTotal * 2) * 180);
            $right.css(prefix, 'rotate(' + deg +'deg)');
        } else if (spinTotal <= 1) {
            $right.css(prefix, 'rotate(0deg)');
            deg = 180 + parseInt(((spinTotal - 0.5) * 2) * 180);
            $left.css(prefix, 'rotate(' + deg +'deg)');
        } else if (spinTotal <= 1.5) {
            $left.css(prefix, 'rotate(360deg)');
            deg = parseInt(((spinTotal - 1) * 2) * 180);
            $right.css(prefix, 'rotate(' + deg +'deg)');
        } else {
            $right.css(prefix, 'rotate(180deg)');
            deg = parseInt(((spinTotal - 1.5) * 2) * 180);
            $left.css(prefix, 'rotate(' + deg +'deg)');
        }

        timeout = setTimeout(updateSpin, 33);
    }

    return {
        init: init,
        setPercentage: setPercentage,
        startSpin: startSpin,
        stopSpin: stopSpin,
        destroy: destroy
    };

})();

var Main = (function() {

    var $htmlData;
    var words = [];
    var totalPages = 1;
    var currentPage = 1;
    var $page;
    var $window;
    var $document;
    var $body;
    var isLoading = false;
    
    var currentWord = 0;

    var $lineBreaks;
    var currentBreak = 0;

    var lastTime = 0;

    var $loadMore = $('<span>Loading ...</span>');
    var $wordMarker = $('<span class="word-marker">_</span>');
    var userScroll = false;
    var autoScroll = false;
    var scrollTimeout = false;

    var isMute = false;

    function init() {
        
        GLOBAL.prefix = Modernizr.prefixed('transform').replace(/([A-Z])/g, function(str,m1){ return '-' + m1.toLowerCase(); }).replace(/^ms-/,'-ms-').replace('transform', '');
        $page = $('.page');
        $window = $(window);
        $body = $('body,html');

        $window.scrollTop(0);
        $.ajax({
          url: "/speakClient.js",
          dataType: "script",
          cache: true
        });
        Loader.startSpin();
        $("#mute").click(toggleMute);

    }

    function toggleMute() {
        if (!isMute) {
            isMute = true;
            $("#player")[0].volume = 0;
            $("#mute").addClass('muted');
        } else {
            isMute = false;
            $("#player")[0].volume = 1;
            $("#mute").removeClass('muted');
        }
    }

    function workerLoadComplete() {
        $.ajax({
          url: '/tell-tale-heart.html',
          dataType: "text",
          cache: true,
          success: loadingComplete
        });
        //$('.page').load('/tell-tale-heart.html', loadingComplete);
    }

    function loadingComplete(data) {

        var lines = data.split("\n");
        var lineCount = 0;

        $("#mute").removeClass('hidden');

        var strHTML = '<span id="page_1"><br>';
        $.each(lines, function(n, elem) {

            strHTML += elem + "<br>";
            words.push(elem);
            lineCount ++;
            
            if (lineCount >= 500) {
                strHTML += "</span>";
                lineCount = 0;
                totalPages ++;
                strHTML += '<span id="page_' + totalPages +'">';
            }
        });
        if (lineCount > 0) {
            strHTML += "</span>";
        }
        $htmlData = $("<span>" + strHTML + "</span>");
        $("#loader").slideUp({
            complete: function() {
                $("#loader").remove();
                $("header").css({
                    top: 0,
                    'margin-top': 0
                });
                TransitionController.transitionEnd($("header"), 
                    function(){ 
                        $("header").css('position', 'fixed');
                        $lineBreaks = $("br", $("#page_1", $htmlData));
                        currentBreak = 0;
                        $page.append($("#page_1", $htmlData)).slideDown();
                        if (totalPages > 1) {
                            $document = $(document);
                            $window.scroll(pageScroll);
                        }
                        nextWord();
                    });
            }
        })
    }

    function nextWord() {
        if (currentWord < words.length) {
            setTimeout(speakWord, 450);
        } else {
            $wordMarker.remove();
        }
        
    }

    function speakWord() {
        $($lineBreaks[currentBreak]).after($wordMarker);
        
        lastTime = Date.now();
        speak(words[currentWord]);
        currentWord ++;
        currentBreak = currentWord;

        if (!userScroll) {
            var pos = $wordMarker.offset().top - $window.scrollTop();
            if (pos > $window.height() - 50) {
                autoScroll = true;
                $body.animate({
                    scrollTop: $window.scrollTop() + ($window.height()- 200)
                },
                500,
                'swing',
                function() {
                    autoScroll = false;
                }
                );
            }
        }
    }

    function pageScroll() {
        if (!autoScroll) {
            userScroll = true;
        }
        if (scrollTimeout) clearTimeout(scrollTimeout);

        if ($window.scrollTop() + $window.height() >= $document.height() - 100) {
            $page.append($loadMore);
            currentPage ++;
            setTimeout(
                function(){
                    $lineBreaks = $.merge($lineBreaks, $("br", $("#page_" + currentPage, $htmlData)));

                    $page.append($("#page_" + currentPage, $htmlData)).css('display', 'block');
                    $loadMore.remove();
                },0);
        }

        scrollTimeout = setTimeout(function() {
            userScroll = false;
            $body.animate({
                    scrollTop: $($lineBreaks[currentBreak]).offset().top - 200
                },
                500
                );   
        }, 5000);

    }

    return {
        init: init,
        workerLoadComplete: workerLoadComplete,
        nextWord: nextWord
    };

})();