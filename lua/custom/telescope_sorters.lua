local M = {}

local function filename_for(entry) return tostring(entry and entry.filename or ''):lower():gsub('\\', '/') end

function M.is_test_file(entry)
  local filename = filename_for(entry)

  return filename:match '_test%.go$' ~= nil
    or filename:match '%.test%.[^/]+$' ~= nil
    or filename:match '%.spec%.[^/]+$' ~= nil
    or filename:match '^tests?/' ~= nil
    or filename:find('/test/', 1, true) ~= nil
    or filename:find('/tests/', 1, true) ~= nil
    or filename:find('/__tests__/', 1, true) ~= nil
end

function M.test_last()
  local sorter = require('telescope.config').values.generic_sorter {}
  local base_scoring = sorter.scoring_function

  sorter.scoring_function = function(self, prompt, line, entry, ...)
    local score = base_scoring(self, prompt, line, entry, ...)
    if score == nil or score == -1 or not M.is_test_file(entry) then return score end

    -- Telescope ranks smaller scores first. Keep its native scoring and add a
    -- large penalty so matching test files remain visible after production code.
    return score + 100
  end

  return sorter
end

return M
