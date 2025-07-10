return {
  'ellisonleao/dotenv.nvim',
  config = function()
    require('dotenv').setup {
      enable_on_load = true, -- load automatically
      verbose = true,
      file_name = 'myenvfile.env',
    }

    -- Optionally load manually:
    require('dotenv').load()
  end,
}
