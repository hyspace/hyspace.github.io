$(function(){
  //line-number
  var $lineNumber = $('#line-number');
  var $content = $('#content');
  var rewriteLinenumber = function(){
    var l = 0,i;
    $lineNumber.empty();
    $('#content > *').each(function(){
      var height = $(this).outerHeight(true);
      var n = Math.floor(height / 25);
      var m = height % 25;
      for(i=0;i<n;i++){
        l++;
        var p = $('<p></p>').text(l);
        if(i == n - 1 && m > 0)p.height(25+m);
        $lineNumber.append(p);
      }
    })
  }
  rewriteLinenumber();
  //minimap
  var $contentCopy = $content.clone();
  var $minimap = $('#minimap')
  var $minimapContent = $('#minimap-content');
  var $minimapHandler = $('#minimap-handler');
  var $minimapMask = $('#minimap-mask');
  var $main = $('#main');
  var zoom = $minimapContent.width() / $content.width();
  var sh1 = Math.min($main.height(),$content.height())*zoom;
  var h = $content.outerHeight(true);
  $contentCopy.find('script').remove();
  $contentCopy.attr('id','content-copy').css({
    '-webkit-transform':'scale('+zoom+','+zoom+')'
  }).appendTo($minimapContent);
  $minimapHandler.height(sh1);
  var moveMinimapHandler = function(y2){
    if(y2 < 0){
      $minimapHandler.css('top',0)
      return false;
    }else if(y2 > h*zoom - sh1){
      $minimapHandler.css('top',(h*zoom - sh1)+'px')
      return false;
    }else{
      $minimapHandler.css('top',y2+'px')
      return true;
    }
  }
  var move = function(e){
    var y1 = e.offsetY;
    var y2 = y1 - sh1/2;
    var y = y2 / zoom;
    var scroll = moveMinimapHandler(y2);
    if(scroll) $main.scrollTop(y);
  }
  $minimapMask.on('mousedown',function(e){
    $(this).on('mousemove',move);
    $minimap.addClass('scrolling');
  }).on('mouseup mouseleave',function(e){
    $(this).off('mousemove',move);
    $minimap.removeClass('scrolling');
  })
  var t;
  $main.on('scroll',function(e){
    var y = $main.scrollTop()
    var y2 = y * zoom;
    moveMinimapHandler(y2);

    if(!$minimap.hasClass('scrolling')){
      $minimap.addClass('scrolling');
    }else{
      clearTimeout(t);
    }
    t = setTimeout(function(){
      $minimap.removeClass('scrolling');
    },2000)
  })
  var resize = function(e) {
    sh1 = Math.min($main.height(),$content.height())*zoom;
    h = $content.outerHeight(true);
    $minimapHandler.height(sh1);
  }
  $(window).resize(resize);
  $('#content img').on('load',function(){
    rewriteLinenumber();
    resize();
  })
  //folder
  $('.side-bar-group').on('click','.side-bar-folder',function(){
    $(this).toggleClass('active').next().slideToggle();
  })
})
console.log('I already have a grilfriend.');