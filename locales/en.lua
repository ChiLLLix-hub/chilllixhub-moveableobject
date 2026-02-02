local Translations = {
    interact = {
        open = '[E] Open %{label}',
        close = '[E] Close %{label}',
        toggle = '[E] %{action} %{label}',
        moving = 'Moving...',
    },
    error = {
        no_access = 'You do not have access to this',
        missing_item = 'You need %{item} to use this',
        already_moving = 'Object is already moving',
    },
    success = {
        opened = '%{label} opened',
        closed = '%{label} closed',
        state_changed = '%{label} %{state}',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
