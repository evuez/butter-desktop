(function (App) {
	'use strict';

	var UpnpC = require('dlna-js').ControlPoint;
	var MediaRendererClient = require('upnp-mediarenderer-client');
	var collection = App.Device.Collection;
	var control = UpnpC.UpnpControlPoint;
	var cp = new control();

	var makeID = function (baseID) {
		return 'dlna-' + baseID.replace(':', '');
	};

	var Dlna = App.Device.Generic.extend({
		defaults: {
			type: 'dlna'
		},
		makeID: makeID,

		initialize: function (attrs) {
			this.device = attrs.device;
			this.client = new MediaRendererClient(this.device.location);
			this.attributes.name = this.device.friendlyName;
			this.attributes.id = this.makeID(this.device.location);
		},
		play: function (streamModel) {
			var url = streamModel.attributes.src;

			this.client.load(url, {
				autoplay: true
			}, function (err, result) {
				if (err) {
					throw err;
				}

			});
		},
		stop: function () {

			this.client.stop();
		},
		pause: function () {

			this.client.pause();
		},
		seekTo: function (newCurrentTime) {
			console.log('Dlna.seekTo %ss', newCurrentTime);
			this.get('device').seekTo(newCurrentTime, function (err, status) {
				if (err) {
					console.log('Chromecast.seekTo:Error', err);
				}
			});
		},

		seekPercentage: function (percentage) {
			console.log('Dlna.seekPercentage %s%', percentage.toFixed(2));
			var newCurrentTime = this.client.GetMediaInfo(function (res) {}) / 100 * percentage;
			this.seekTo(newCurrentTime.toFixed());
		},

		forward: function () {

			this.client.seek(30);
		},

		backward: function () {

			this.client.seek(-30);
		},

		unpause: function () {

			this.client.play();
		}

	});

	function filterDevice(device) {
		var type = device.deviceType.replace('urn:schemas-upnp-org:device:', '');
		type = (type.split(':')[0]);

		if (type !== 'MediaRenderer') {
			return null;
		}
		return device;
	}


	cp.on('device', function (device) {
		if (!filterDevice(device)) {
			return;
		}
		collection.add(new Dlna({
			device: device
		}));
	});


	cp.search();

	App.Device.Dlna = Dlna;
})(window.App);
