$(function(){
  //line-number
  var l = 0,i;
  var $lineNumber = $('#line-number');
  var $content = $('#content');
  $('#content > *').each(function(){
    var height = $(this).outerHeight(true);
    var n = Math.floor(height / 25);
    var m = height % 25;
    for(i=0;i<n;i++){
      l++;
      var p = $('<p></p>').text(l)
      if(i == n - 1 && m > 0)p.height(25+m);
      $lineNumber.append(p);
    }
  })
  //minimap
  var $contentCopy = $content.clone();
  var $minimap = $('#minimap')
  var $minimapContent = $('#minimap-content');
  var $minimapHandler = $('#minimap-handler');
  var $minimapMask = $('#minimap-mask');
  var $main = $('#main');
  var zoom = $minimapContent.width() / $content.width();
  var sh1 = $main.height()*zoom;
  var h = $content.outerHeight(true);
  $contentCopy.attr('id','content-copy').css({
    '-webkit-transform':'scale('+zoom+','+zoom+')'
  }).appendTo($minimapContent);
  $minimapHandler.height(sh1);
  $minimapMask.height(h*zoom);
  var moveMinimapHandler = function(y2){
    if(y2 < 0){
      $minimapHandler.css('top',0)
    }else if(y2 > h*zoom - sh1){
      $minimapHandler.css('top',(h*zoom - sh1)+'px')
    }else{
      $minimapHandler.css('top',y2+'px')
    }
  }
  var move = function(e){
    var y1 = e.offsetY;
    var y2 = y1 - sh1/2;
    var y = y2 / zoom;
    $main.scrollTop(y);
    moveMinimapHandler(y2);
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
  $( window ).resize(function() {
    sh1 = $main.height()*zoom;
    $minimapHandler.height(sh1);
  });
})
console.log('I already have a grilfriend.');