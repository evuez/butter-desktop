(function (App) {
	'use strict';

	var SCROLL_MORE = 0.7; // 70% of window height
	var NUM_MOVIES_IN_ROW = 7;
	var _this;

	function elementInViewport(container, element) {
		var $container = $(container),
			$el = $(element);

		var docViewTop = $container.offset().top;
		var docViewBottom = docViewTop + $container.height();

		var elemTop = $el.offset().top;
		var elemBottom = elemTop + $el.height();

		return ((elemBottom >= docViewTop) && (elemTop <= docViewBottom) && (elemBottom <= docViewBottom) && (elemTop >= docViewTop));
	}

	var ErrorView = Backbone.Marionette.ItemView.extend({
		template: '#movie-error-tpl',
		onBeforeRender: function () {
			this.model.set('error', this.error);
		}
	});

	var List = Backbone.Marionette.CompositeView.extend({
		template: '#list-tpl',

		tagName: 'ul',
		className: 'list',

		itemView: App.View.Item,
		itemViewContainer: '.items',

		events: {
			'scroll': 'onScroll',
			'mousewheel': 'onScroll',
			'keydown': 'onScroll'
		},

		ui: {
			spinner: '.spinner'
		},


		isEmpty: function () {
			return !this.collection.length && this.collection.state !== 'loading';
		},

		getEmptyView: function () {
			switch (App.currentview) {
			case 'movies':
			case 'shows':
			case 'anime':
				if (this.collection.state === 'error') {
					return ErrorView.extend({
						error: i18n.__('Error loading data, try again later...')
					});
				} else {
					return ErrorView.extend({
						error: i18n.__('No ' + App.currentview + ' found...')
					});
				}
				break;

			case 'Favorites':
				if (this.collection.state === 'error') {
					return ErrorView.extend({
						error: i18n.__('Error, database is probably corrupted. Try flushing the bookmarks in settings.')
					});
				} else {
					return ErrorView.extend({
						error: i18n.__('No ' + App.currentview + ' found...')
					});
				}
				break;
			case 'Watchlist':
				if (this.collection.state === 'error') {
					return ErrorView.extend({
						error: i18n.__('This feature only works if you have your TraktTv account synced. Please go to Settings and enter your credentials.')
					});
				} else {
					return ErrorView.extend({
						error: i18n.__('No ' + App.currentview + ' found...')
					});
				}
				break;
			}
		},

		initialize: function () {
			_this = this;
			this.listenTo(this.collection, 'loading', this.onLoading);
			this.listenTo(this.collection, 'loaded', this.onLoaded);

			App.vent.on('shortcuts:movies', _this.initKeyboardShortcuts);
			_this.initKeyboardShortcuts();

			_this.initPosterResizeKeys();
		},

		initKeyboardShortcuts: function () {
			Mousetrap.bind('up', _this.moveUp);

			Mousetrap.bind('down', _this.moveDown);

			Mousetrap.bind('left', _this.moveLeft);

			Mousetrap.bind('right', _this.moveRight);

			Mousetrap.bind('f', _this.toggleSelectedFavourite);

			Mousetrap.bind('w', _this.toggleSelectedWatched);

			Mousetrap.bind(['enter', 'space'], _this.selectItem);

			Mousetrap.bind(['ctrl+f', 'command+f'], _this.focusSearch);

			Mousetrap.bind('tab', function () {
				switch (App.currentview) {
				case 'movies':
					App.currentview = 'shows';
					App.vent.trigger('shows:list', []);
					$('.source.showMovies').removeClass('active');
					$('.source.showShows').addClass('active');
					break;
				case 'shows':
					App.currentview = 'anime';
					App.vent.trigger('anime:list', []);
					$('.source.showMovies').removeClass('active');
					$('.source.showShows').removeClass('active');
					$('.source.showAnime').addClass('active');
					break;
				default:
					App.currentview = 'movies';
					App.vent.trigger('movies:list');
				}
			});

			Mousetrap.bind('shift+tab', function () {
				switch (App.currentview) {
				case 'movies':
					App.currentview = 'anime';
					App.vent.trigger('anime:list', []);
					$('.source.showMovies').removeClass('active');
					$('.source.showAnime').addClass('active');
					break;
				case 'anime':
					App.currentview = 'shows';
					App.vent.trigger('shows:list', []);
					$('.source.showMovies').removeClass('active');
					$('.source.showAnime').removeClass('active');
					$('.source.showShows').addClass('active');
					break;
				default:
					App.currentview = 'movies';
					App.vent.trigger('movies:list');
				}
			});

			Mousetrap.bind('ctrl+1', function () {
				App.currentview = 'movies';
				App.vent.trigger('movies:list', []);
				$('.source.showShows').removeClass('active');
				$('.source.showAnime').removeClass('active');
				$('.source.showMovies').addClass('active');
			});

			Mousetrap.bind('ctrl+2', function () {
				App.currentview = 'shows';
				App.vent.trigger('shows:list', []);
				$('.source.showMovies').removeClass('active');
				$('.source.showAnime').removeClass('active');
				$('.source.showShows').addClass('active');
			});

			Mousetrap.bind('ctrl+3', function () {
				App.currentview = 'anime';
				App.vent.trigger('anime:list', []);
				$('.source.showMovies').removeClass('active');
				$('.source.showShows').removeClass('active');
				$('.source.showAnime').addClass('active');
			});
		},

		initPosterResizeKeys: function () {
			$(window)
				.on('mousewheel', function (event) { // Ctrl + wheel doesnt seems to be working on node-webkit (works just fine on chrome)
					if (event.altKey === true) {
						event.preventDefault();
						if (event.originalEvent.wheelDelta > 0) {
							_this.increasePoster();
						} else {
							_this.decreasePoster();
						}
					}
				})
				.on('keydown', function (event) {
					if (event.ctrlKey === true || event.metaKey === true) {

						if ($.inArray(event.keyCode, [107, 187]) !== -1) {
							_this.increasePoster();
							return false;

						} else if ($.inArray(event.keyCode, [109, 189]) !== -1) {
							_this.decreasePoster();
							return false;
						}
					}
				});
		},

		onShow: function () {
			if (this.collection.state === 'loading') {
				this.onLoading();
			}
		},

		onLoading: function () {
			$('.status-loadmore').hide();
			$('#loading-more-animi').show();
		},

		onLoaded: function () {
			console.timeEnd('App startup time');
			this.checkEmpty();
			var self = this;
			this.addloadmore();

			this.AddGhostsToBottomRow();
			$(window).resize(function () {
				var addghost;
				clearTimeout(addghost);
				addghost = setTimeout(function () {
					self.AddGhostsToBottomRow();
				}, 100);
			});

			if (typeof (this.ui.spinner) === 'object') {
				this.ui.spinner.hide();
			}

			$('.filter-bar').on('mousedown', function (e) {
				if (e.target.localName !== 'div') {
					return;
				}
				_.defer(function () {
					self.$('.items:first').focus();
				});
			});
			$('.items').attr('tabindex', '1');
			_.defer(function () {
				self.$('.items:first').focus();
			});


		},

		addloadmore: function () {
			var self = this;

			switch (App.currentview) {
			case 'movies':
			case 'shows':
			case 'anime':
				$('#load-more-item').remove();
				// we add a load more
				if (this.collection.hasMore && !this.collection.filter.keywords && this.collection.state !== 'error') {
					$('.items').append('<div id="load-more-item" class="load-more"><span class="status-loadmore">' + i18n.__('Load More') + '</span><div id="loading-more-animi" class="loading-container"><div class="ball"></div><div class="ball1"></div></div></div>');

					$('#load-more-item').click(function () {
						$('#load-more-item').off('click');
						self.collection.fetchMore();
					});

					$('#loading-more-animi').hide();
					$('.status-loadmore').show();
				}
				break;

			case 'Favorites':

				break;
			case 'Watchlist':

				break;
			}
		},

		AddGhostsToBottomRow: function () {
			var divsInLastRow, divsInRow, to_add;
			$('.ghost').remove();
			divsInRow = 0;
			$('.items .item').each(function () {
				if ($(this).prev().length > 0) {
					if ($(this).position().top !== $(this).prev().position().top) {
						return false;
					}
					divsInRow++;
				} else {
					divsInRow++;
				}
			});
			divsInLastRow = $('.items .item').length % divsInRow;
			if (divsInLastRow === 0) {
				divsInLastRow = -Math.abs(Math.round($('.items').width() / $('.item').outerWidth(true)) - divsInRow);
			}
			NUM_MOVIES_IN_ROW = divsInRow;
			to_add = divsInRow - divsInLastRow;
			while (to_add > 0) {
				$('.items').append($('<li/>').addClass('item ghost'));
				to_add--;
			}
		},
		onScroll: function () {
			if (!this.collection.hasMore) {
				return;
			}

			var totalHeight = this.$el.prop('scrollHeight');
			var currentPosition = this.$el.scrollTop() + this.$el.height();

			if (this.collection.state === 'loaded' &&
				(currentPosition / totalHeight) > SCROLL_MORE) {
				this.collection.fetchMore();
			}
		},

		focusSearch: function (e) {
			$('.search input').focus();
		},

		increasePoster: function (e) {
			var postersWidthIndex = Settings.postersJump.indexOf(parseInt(Settings.postersWidth));

			if (postersWidthIndex !== -1 && postersWidthIndex + 1 in Settings.postersJump) {
				App.db.writeSetting({
					key: 'postersWidth',
					value: Settings.postersJump[postersWidthIndex + 1]
				})
					.then(function () {
						App.vent.trigger('updatePostersSizeStylesheet');
					});
			} else {
				// do nothing for now
			}
		},

		decreasePoster: function (e) {
			var postersWidth;
			var postersWidthIndex = Settings.postersJump.indexOf(parseInt(Settings.postersWidth));

			if (postersWidthIndex !== -1 && postersWidthIndex - 1 in Settings.postersJump) {
				postersWidth = Settings.postersJump[postersWidthIndex - 1];
			} else {
				postersWidth = Settings.postersJump[0];
			}

			App.db.writeSetting({
				key: 'postersWidth',
				value: postersWidth
			})
				.then(function () {
					App.vent.trigger('updatePostersSizeStylesheet');
				});
		},


		selectItem: function (e) {
			if (e.type) {
				e.preventDefault();
				e.stopPropagation();
			}
			$('.item.selected .cover').trigger('click');
		},

		selectIndex: function (index) {
			if ($('.items .item').eq(index).length === 0 || $('.items .item').eq(index).children().length === 0) {
				return;
			}
			$('.item.selected').removeClass('selected');
			$('.items .item').eq(index).addClass('selected');

			var $movieEl = $('.item.selected')[0];
			if (!elementInViewport(this.$el, $movieEl)) {
				$movieEl.scrollIntoView(false);
				this.onScroll();
			}
		},

		moveUp: function (e) {
			if (e.type) {
				e.preventDefault();
				e.stopPropagation();
			}
			var index = $('.item.selected').index();
			if (index === -1) {
				index = 0;
			} else {
				index = index - NUM_MOVIES_IN_ROW;
			}
			if (index < 0) {
				return;
			}
			_this.selectIndex(index);
		},

		moveDown: function (e) {
			if (e.type) {
				e.preventDefault();
				e.stopPropagation();
			}
			var index = $('.item.selected').index();
			if (index === -1) {
				index = 0;
			} else {
				index = index + NUM_MOVIES_IN_ROW;
			}
			_this.selectIndex(index);
		},

		moveLeft: function (e) {
			if (e.type) {
				e.preventDefault();
				e.stopPropagation();
			}
			var index = $('.item.selected').index();
			if (index === -1) {
				index = 0;
			} else if (index === 0) {
				index = 0;
			} else {
				index = index - 1;
			}
			_this.selectIndex(index);
		},

		moveRight: function (e) {
			if (e.type) {
				e.preventDefault();
				e.stopPropagation();
			}
			var index = $('.item.selected').index();
			if (index === -1) {
				index = 0;
			} else {
				index = index + 1;
			}
			_this.selectIndex(index);
		},

		toggleSelectedFavourite: function (e) {
			$('.item.selected .actions-favorites').click();
		},

		toggleSelectedWatched: function (e) {
			$('.item.selected .actions-watched').click();
		},
	});

	App.View.List = List;
})(window.App);
