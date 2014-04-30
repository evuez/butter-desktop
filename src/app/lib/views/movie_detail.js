(function(App) {
    "use strict";
        

    var MovieDetail = Backbone.Marionette.ItemView.extend({
        template: '#movie-detail-tpl',
        className: 'app-overlay',

        ui: {
            selected_lang: '.selected-lang' 
        },

        events: {
            'click .movie-btn-watch': 'startStreaming',
            'click .movie-btn-watch-trailer': 'playTrailer',
            'click .movie-detail-close': 'closeDetails',
            'click #switch-hd-on': 'enableHD',
            'click #switch-hd-off': 'disableHD',
            'click #toggle-sub-dropdown': 'toggledropdown',
            'click #toggle-sub-dropdown-arrow': 'toggledropdown',
            'click #sub-flag-icon': 'closedropdown'
        },

        onShow: function() {

            // TODO: use the default in settings
            this.subtitle_selected = false;

            console.log('Show movie detail', this.model);

            var torrents = this.model.get('torrents');

            if(torrents['720p'] !== undefined && torrents['1080p'] !== undefined) {
            
            var torrentUrl = torrents['1080p'].url;
            this.model.set('quality', torrents['1080p'].url);

            }
            else if(torrents['1080p'] !== undefined ) {
            
            var torrentUrl = torrents['1080p'].url;
            this.model.set('quality', torrents['1080p'].url);

            }   else if(torrents['720p'] !== undefined ) {
            
            var torrentUrl = torrents['720p'].url;
            this.model.set('quality', torrents['720p'].url);

            }
            console.logger.debug(this.model.get('quality'));

	       $('.health-icon').tooltip();

             var background = $(".movie-backdrop").attr("data-bgr");
            $('<img/>').attr('src', background).load(function() {
             $(this).remove();
                $(".movie-backdrop").css('background-image', "url(" + background + ")");
             $(".movie-backdrop").fadeIn( 300 );
             });
  



        },

        onClose: function() {},
        showCover: function() {},
        toggledropdown: function() {

        $(".flag-container").fadeIn();


        },
        closedropdown: function(e) {

            e.preventDefault();
            this.subtitle_selected = $(e.currentTarget).attr("data-lang");
            this.ui.selected_lang.removeClass().addClass("flag").addClass("toggle").addClass("selected-lang").addClass(this.subtitle_selected);
            $(".flag-container").fadeOut();


        },

        startStreaming: function() {
            var torrentStart = new Backbone.Model({torrent: this.model.get('quality'), backdrop: this.model.get('backdrop'), subtitle: this.model.get('subtitle')});
            App.vent.trigger('stream:start', torrentStart);
        },

        playTrailer: function() {
            var trailer = new Backbone.Model({src: this.model.get('trailer'), type: 'video/youtube', subtitle: null });
            App.vent.trigger('stream:ready', trailer);
        },

        closeDetails: function() {
			App.vent.trigger('movie:closeDetail'); 	
        },

        enableHD: function () {

        var torrents = this.model.get('torrents');
        console.logger.debug('HD Enabled');


        if(torrents['1080p'] !== undefined) {
            var torrents = this.model.get('torrents');
            var torrentUrl = torrents['1080p'].url;
            this.model.set('quality', torrents['1080p'].url);
            console.logger.debug(this.model.get('quality'));
        }
        },

        disableHD: function () {

        var torrents = this.model.get('torrents');
        console.logger.debug('HD Disabled');
        console.logger.log(torrents['720p']);

        if(torrents['720p'] !== undefined) {
            var torrents = this.model.get('torrents');
             this.model.set('quality', torrents['720p'].url);
             console.logger.debug(this.model.get('quality'));
        }

        }

    });


    App.View.MovieDetail = MovieDetail;
})(window.App);
