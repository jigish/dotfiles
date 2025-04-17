return {
  { 'echasnovski/mini.icons', version = '*', opts = {} },
  {
    'echasnovski/mini.trailspace',
    version = '*',
    opts = {},
  },
  {
    'echasnovski/mini.move',
    version = false,
    opts = {
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = '<M-H>',
        right = '<M-L>',
        down = '<M-J>',
        up = '<M-K>',

        -- Move current line in Normal mode
        line_left = '<M-H>',
        line_right = '<M-L>',
        line_down = '<M-J>',
        line_up = '<M-K>',
      },
    },
  },
  {
    'echasnovski/mini.comment',
    version = '*',
    opts = {
      mappings = {
        -- Toggle comment (like `gcip` - comment inner paragraph) for both
        -- Normal and Visual modes
        comment = '<leader>c',

        -- Toggle comment on current line
        comment_line = '<leader>cc',

        -- Toggle comment on visual selection
        comment_visual = '<leader>c',

        -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        -- Works also in Visual mode if mapping differs from `comment_visual`
        textobject = '<leader>c',
      },
    },
  },
  {
    'echasnovski/mini.surround',
    version = '*',
    opts = {
      mappings = {
        add = '<leader>sa', -- Add surrounding in Normal and Visual modes
        delete = '<leader>sd', -- Delete surrounding
        find = '<leader>sf', -- Find surrounding (to the right)
        find_left = '<leader>sF', -- Find surrounding (to the left)
        highlight = '<leader>sh', -- Highlight surrounding
        replace = '<leader>sr', -- Replace surrounding
        update_n_lines = '<leader>sn', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    }
  },
}
