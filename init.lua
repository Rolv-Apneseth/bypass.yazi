-- For development
--[[ local function notify(message) ]]
--[[     ya.notify({ title = "Bypass", content = message, timeout = 5 }) ]]
--[[ end ]]

---Returns the loading state of the current directory
---@type fun(): boolean
local is_directory_loaded = ya.sync(function(_)
    return cx.active.current.stage.is_loading
end)

---Enter hovered item if it is a directory
---@type fun(use_smart_enter: boolean): boolean
local initial = ya.sync(function(_, use_smart_enter)
    local hovered = cx.active.current.hovered
    if hovered == nil then
        return false
    end

    if not hovered.cha.is_dir then
        -- Open file if using "smart enter"
        if use_smart_enter then
            ya.manager_emit("escape", { visual = true, select = true })
            ya.manager_emit("open", { hovered = true })
        end
        return false
    end

    ya.manager_emit("escape", { visual = true, select = true })
    ya.manager_emit("enter", { hovered = true })

    return true
end)

---Enter hovered item if it is a directory and is the only item in the parent
---@type fun(): boolean
local bypass = ya.sync(function(_)
    local hovered = cx.active.current.hovered

    if hovered == nil or not hovered.cha.is_dir or #cx.active.current.files > 1 then
        return false
    end

    ya.manager_emit("enter", { hovered = true })

    return true
end)

---Leave the CWD, if the CWD has a parent
---@type fun(): boolean
local initial_rev = ya.sync(function(_)
    if cx.active.parent == nil then
        return false
    end

    ya.manager_emit("escape", { visual = true, select = true })
    ya.manager_emit("leave", {})

    return true
end)

---Leave the CWD, if the CWD has a parent and contains only one item
---@type fun(): boolean
local bypass_rev = ya.sync(function(_)
    if cx.active.parent == nil or #cx.active.current.files > 1 then
        return false
    end

    ya.manager_emit("leave", {})

    return true
end)

return {
    entry = function(_, job)
        -- old version of Yazi will pass args directly, new version passes job. Below code ensures we derive args in both 0.3 and 0.4 Yazi API versions.
        local args = job.args or job
        local use_smart_enter = args and args[1] == "smart_enter"
        local is_reverse = args and args[1] == "reverse"

        -- Initial run, should behave like a regular enter/smart-enter/leave
        local run = is_reverse and initial_rev() or initial(use_smart_enter)

        while run do
            -- Wait for directory to have loaded
            while is_directory_loaded() do
                ya.sleep(0.002)
            end

            -- Conditional enter/smart-enter/leave
            run = is_reverse and bypass_rev() or bypass()
        end
    end,
}
