/*

import Elm.Kernel.Json exposing (runHelp)
import Elm.Kernel.Scheduler exposing (binding, fail, rawSpawn, succeed)
import Elm.Kernel.Utils exposing (Tuple0)

*/



// EVENT LISTENERS


var _Dom_fakeNode = {
	addEventListener: function() {},
	removeEventListener: function() {}
};

var _Dom_on = F5(function(node, useCapture, eventName, handler, toTask)
{
	return __Scheduler_binding(function(callback) {

		function performTask(event)
		{
			var result = __Json_runHelp(handler.a, event);
			if (result.$ === 'Ok')
			{
				__Scheduler_rawSpawn(toTask(_Dom_processEvent(event, handler.$, result.a)));
			}
		}

		var options = _Dom_toOptions(handler.$, useCapture);

		node.addEventListener(eventName, performTask, options);

		return function()
		{
			node.removeEventListener(eventName, performTask, options);
		};
	});
});

var _Dom_onDocument = _Dom_on(typeof document !== 'undefined' ? document : _Dom_fakeNode);
var _Dom_onWindow = _Dom_on(typeof window !== 'undefined' ? window : _Dom_fakeNode);

function _Dom_processEvent(event, tag, value)
{
	var isCustom = tag === 'Custom';

	if (tag === 'Normal')
	{
		return value;
	}

	if (tag === 'MayStopPropagation' ? value.b : isCustom && value.__$stopPropagation) event.stopPropagation();
	if (tag === 'MayPreventDefault' ? value.b : isCustom && value.__$preventDefault) event.preventDefault();

	return isCustom ? value.__$message : value.a;
}



// PASSIVE EVENTS


function _Dom_toOptions(tag, useCapture) { return useCapture; }

try
{
	window.addEventListener("test", null, Object.defineProperty({}, "passive", {
		get: function()
		{
			_Dom_toOptions = function(tag, useCapture)
			{
				return {
					passive: tag === 'Normal' || tag === 'MayStopPropagation',
					capture: useCapture
				};
			}
		}
	}));
}
catch(e) {}



// MODIFY THE DOM


function _Dom_withNode(id, doStuff)
{
	return __Scheduler_binding(function(callback)
	{
		var node = document.getElementById(id);
		callback(node
			? __Scheduler_succeed(doStuff(node))
			: __Scheduler_fail({ $: 'NotFound', a: id })
		);
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
