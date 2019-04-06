Hooks = {}

Hooks.registered = {}

function Hooks.bind(hook, callback)
	table.insert(Hooks.registered, { hook = hook, callback = callback })
end

function Hooks.execute(hook, ...)
	for _, registered_hook in ipairs(Hooks.registered) do 
		if registered_hook.hook == hook then registered_hook.callback(...) end
	end
end

return Hooks
