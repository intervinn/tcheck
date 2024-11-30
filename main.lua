local tc = require(".")

local keycode = tc.either(
    tc.number(1),
    tc.number(2),
    tc.number(3)
)
print(tc.match(keycode, ""))

local object = tc.object({
    name = tc.string(),
    keycode = keycode
})

local func = tc.func(tc.either(tc.string(), tc.null())).impl(function(msg)
    print(msg)
end).wrap()

func("")