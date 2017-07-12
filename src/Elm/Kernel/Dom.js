/*

import Elm.Kernel.Scheduler exposing (binding, fail, rawSpawn, succeed)
import Elm.Kernel.Utils exposing (Tuple0)
import Json.Decode as Json exposing (decodeValue)

*/


var _Dom_fakeNode = {
	addEventListener: function() {},
	removeEventListener: function() {}
};

var _Dom_onDocument = _Dom_on(typeof document !== 'undefined' ? document : _Dom_fakeNode);
var _Dom_onWindow = _Dom_on(typeof window !== 'undefined' ? window : _Dom_fakeNode);

function _Dom_on(node)
{
	return F3(function(eventName, decoder, toTask)
	{
		return __Scheduler_binding(function(callback) {

			function performTask(event)
			{
				var result = A2(__Json_decodeValue, decoder, event);
				if (result.$ === 'Ok')
				{
					__Scheduler_rawSpawn(toTask(result.a));
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
		: function(callback) { setTimeout(callback, 1000 / 60); };

function _Dom_withNode(id, doStuff)
{
	return __Scheduler_binding(function(callback)
	{
		_Dom_requestAnimationFrame(function()
		{
			var node = document.getElementById(id);
			if (node === null)
			{
				callback(__Scheduler_fail({ $: 'NotFound', a: id }));
				return;
			}
			callback(__Scheduler_succeed(doStuff(node)));
		});
	});
}


// FOCUS

function _Dom_focus(id)
{
	return _Dom_withNode(id, function(node) {
		node.focus();
		return __Utils_Tuple0;
	});
}

function _Dom_blur(id)
{
	return _Dom_withNode(id, function(node) {
		node.blur();
		return __Utils_Tuple0;
	});
}


// SCROLLING

function _Dom_getScrollTop(id)
{
	return _Dom_withNode(id, function(node) {
		return node.scrollTop;
	});
}

var _Dom_setScrollTop = F2(function(id, desiredScrollTop)
{
	return _Dom_withNode(id, function(node) {
		node.scrollTop = desiredScrollTop;
		return __Utils_Tuple0;
	});
});

function _Dom_toBottom(id)
{
	return _Dom_withNode(id, function(node) {
		node.scrollTop = node.scrollHeight;
		return __Utils_Tuple0;
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
		return __Utils_Tuple0;
	});
});

function _Dom_toRight(id)
{
	return _Dom_withNode(id, function(node) {
		node.scrollLeft = node.scrollWidth;
		return __Utils_Tuple0;
	});
}


// SIZE

var _Dom_width = F2(function(options, id)
{
	return _Dom_withNode(id, function(node) {
		switch (options.$)
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
		switch (options.$)
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
