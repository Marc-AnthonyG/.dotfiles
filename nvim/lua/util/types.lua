--- @class FormatterProvider
--- @field format function The formatting function
--- @field name string The name of the formatter
--- @field primary boolean Whether this is a primary formatter
--- @field priority number The priority of the formatter (higher = more priority)
--- @field sources function Function that return the method available for the formatter (e.g. textDocument/formatting).
--- This function should validate for instance if the client is running or not (ex: eslint sources function should check if client is running for current buffer)

--- @class Formatter : FormatterProvider
--- @field active boolean Whether this formatter is active
--- @field resolved string[] The sources that are resolved for this formatter

--- @class FormatOpt
--- @field buf? number Buffer handle to format (defaults to current buffer)
--- @field force? boolean Force formatting even if disabled for the buffer

--- @class GetClientsOpt : vim.lsp.get_clients.Filter
--- @field filter? function Additional filter function to apply to clients

--- @class CreateFormatterOps
--- @field filter string|table Filter for LSP clients (string = name filter, table = complex filter)

--- @class VimLspConfig : vim.lsp.Config
