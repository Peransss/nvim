-- ~/.config/nvim/lua/core/db_env.lua

local function load_database_url()
  local dot_ok, dotenv = pcall(require, 'dotenv')
  if not dot_ok then
    print '[db_env] dotenv.nvim not found!'
    return
  end

  local loaded = dotenv.load()
  if not loaded then
    print '[db_env] Failed to load .env file.'
  end

  local url = os.getenv 'DATABASE_URL'
  if not url or url == '' then
    print '[db_env] DATABASE_URL is empty or not set'
  else
    print('[db_env] DATABASE_URL loaded:', url)
    vim.g.dadbod_database_url = url
    vim.g.dbs = {
      mydb = url,
    }
  end
end

return {
  load = load_database_url,
}
