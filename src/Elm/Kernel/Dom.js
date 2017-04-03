
var _Dom_fakeNode = {
	addEventListener: function() {},
	removeEventListener: function() {}
};

var _Dom_onDocument = on(typeof document !== 'undefined' ? document : _Dom_fakeNode);
var _Dom_onWindow = on(typeof window !== 'undefined' ? window : _Dom_fakeNode);

function _Dom_on(node)
{
	return F3(function(eventName, decoder, toTask)
	{
		return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {

			function performTask(event)
			{
				var result = A2(_elm_lang$core$Json_Decode$decodeValue, decoder, event);
				if (result.ctor === 'Ok')
				{
					_elm_lang$core$Native_Scheduler.rawSpawn(toTask(result._0));
				}
			}

			node.addEventListener(eventName, performTask);

			return function()
			{
				node.removeEventListener(eventName, performTask);
			};
		});
	});
}

var _Dom_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { callback(); };

function _Dom_withNode(id, doStuff)
{
	return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback)
	{
		_Dom_requestAnimationFrame(function()
		{
			var node = document.getElementById(id);
			if (node === null)
			{
				callback(_elm_lang$core$Native_Scheduler.fail({ ctor: 'NotFound', _0: id }));
				return;
			}
			callback(_elm_lang$core$Native_Scheduler.succeed(doStuff(node)));
		});
	});
}


// FOCUS

function _Dom_focus(id)
{
	return _Dom_withNode(id, function(node) {
		node.focus();
		return _elm_lang$core$Native_Utils.Tuple0;
	});
}

function _Dom_blur(id)
{
	return _Dom_withNode(id, function(node) {
		node.blur();
		return _elm_lang$core$Native_Utils.Tuple0;
	});
}


// SCROLLING

function _Dom_getScrollTop(id)
{
	return _Dom_withNode(id, function(node) {
		return node.scrollTop;
	});
}

var = _Dom_setScrollTop = F2(function(id, desiredScrollTop)
{
	return _Dom_withNode(id, function(node) {
		node.scrollTop = desiredScrollTop;
		return _elm_lang$core$Native_Utils.Tuple0;
	});
});

function _Dom_toBottom(id)
{
	return _Dom_withNode(id, function(node) {
		node.scrollTop = node.scrollHeight;
		return _elm_lang$core$Native_Utils.Tuple0;
	});
}

function _Dom_getScrollLeft(id)
{
	return _Dom_withNode(id, function(node) {
		return node.scrollLeft;
	});
}

var _Dom_setScrollLeft = F2(function(id, desiredScrollLeft)
{
	return _Dom_withNode(id, function(node) {
		node.scrollLeft = desiredScrollLeft;
		return _elm_lang$core$Native_Utils.Tuple0;
	});
});

function _Dom_toRight(id)
{
	return _Dom_withNode(id, function(node) {
		node.scrollLeft = node.scrollWidth;
		return _elm_lang$core$Native_Utils.Tuple0;
	});
}


// SIZE

var _Dom_width = F2(function(options, id)
{
	return _Dom_withNode(id, function(node) {
		switch (options.ctor)
		{
			case 'Content':
				return node.scrollWidth;
			case 'VisibleContent':
				return node.clientWidth;
			case 'VisibleContentWithBorders':
				return node.offsetWidth;
			case 'VisibleContentWithBordersAndMargins':
				var rect = node.getBoundingClientRect();
				return rect.right - rect.left;
		}
	});
});

var _Dom_height = F2(function(options, id)
{
	return _Dom_withNode(id, function(node) {
		switch (options.ctor)
		{
			case 'Content':
				return node.scrollHeight;
			case 'VisibleContent':
				return node.clientHeight;
			case 'VisibleContentWithBorders':
				return node.offsetHeight;
			case 'VisibleContentWithBordersAndMargins':
				var rect = node.getBoundingClientRect();
				return rect.bottom - rect.top;
		}
	});
});
