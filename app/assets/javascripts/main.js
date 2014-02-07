$(window).load(function(){   
    $( document ).ready(function() {
        
        //$("header").headroom();

        function init(){
            $('.loadPage').click(function() {
                //console.log($(this).attr("href"));
                loadPages($(this).attr("href"));
                return false;
            });

            $("header").headroom({
              "tolerance": 5,
              "offset": 205,
              "classes": {
                "initial": "animated",
                "pinned": "flipInX",
                "unpinned": "flipOutX"
              }
            });
            
            // cache container
            var container = $('#feed');  
            
            container.isotope({
                animationEngine : 'best-available',
                animationOptions: {
                    duration: 200,
                    queue: false
                },

                layoutMode: 'fitRows'
            }); 
                
            function splitColumns() { 
                var winWidth = $(window).width(), 
                    columnNumb = 1;
                
                console.log(winWidth)
                
                if (winWidth > 1500) {
                    columnNumb = 5;
                } else if (winWidth > 980) {
                    columnNumb = 4;
                } else if (winWidth > 768) {
                    columnNumb = 3;
                } else if (winWidth > 520) {
                    columnNumb = 2;
                } else if (winWidth < 520) {
                    columnNumb = 1;
                }
                
                return columnNumb;
            }       
            
            function setColumns() { 
                var winWidth = $(window).width(), 
                    columnNumb = splitColumns(), 
                    postWidth = Math.floor(winWidth / columnNumb) -20;
                
                container.find('.box').each(function () { 
                    jQuery(this).css( { 
                        width : postWidth + 'px' 
                    });
                });
            }       
            
            function setProjects() { 
                setColumns();
                container.isotope('reLayout');
            }       
            
            container.imagesLoaded(function () { 
                setColumns();
            });
            

            jQuery(window).bind('resize', function () { 
                setProjects();          
            });

            setProjects();  
        }

        function loadPages(page){
            var jqxhr = $.ajax( page )
            .done(function(html) {
                //alert( "success" );
                $('#main').html(html);
            })
            .fail(function() {
                alert( "error" );
            })
            .always(function(html) {
                //alert( "complete" );
                //console.log(page);
                init();
            }); 
        }

        loadPages("feed.php");


    });
});


